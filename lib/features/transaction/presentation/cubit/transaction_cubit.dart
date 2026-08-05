import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../account/domain/repositories/account_repository.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/repositories/transaction_repository.dart';
import 'transaction_state.dart';

class TransactionCubit extends Cubit<TransactionState> {
  final TransactionRepository _transactionRepository;
  final AccountRepository? _accountRepository;

  TransactionCubit(
    this._transactionRepository, [
    this._accountRepository,
  ]) : super(const TransactionState());

  Future<void> loadTransactions() async {
    emit(state.copyWith(isLoading: true));
    final result = await _transactionRepository.getTransactions();
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (transactions) {
        final filtered = _applyFilterAndSort(transactions, state);
        emit(
          state.copyWith(
            allTransactions: transactions,
            filteredTransactions: filtered,
            isLoading: false,
          ),
        );
      },
    );
  }

  Future<void> addTransaction(Transaction transaction) async {
    emit(state.copyWith(isLoading: true));
    final result = await _transactionRepository.saveTransaction(transaction);
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (_) async {
        await _applyAccountBalanceDelta(transaction, isAdding: true);
        await loadTransactions();
      },
    );
  }

  Future<void> updateTransaction(Transaction transaction) async {
    emit(state.copyWith(isLoading: true));
    final oldTxIndex = state.allTransactions.indexWhere((t) => t.id == transaction.id);
    if (oldTxIndex != -1) {
      final oldTx = state.allTransactions[oldTxIndex];
      // Reverse old transaction effect
      await _applyAccountBalanceDelta(oldTx, isAdding: false);
    }
    final updated = transaction.copyWith(updatedAt: DateTime.now());
    final result = await _transactionRepository.saveTransaction(updated);
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (_) async {
        await _applyAccountBalanceDelta(updated, isAdding: true);
        await loadTransactions();
      },
    );
  }

  Future<void> deleteTransaction(String id) async {
    emit(state.copyWith(isLoading: true));
    final txToDelete = state.allTransactions.where((t) => t.id == id).firstOrNull;
    final result = await _transactionRepository.deleteTransaction(id);
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (_) async {
        if (txToDelete != null) {
          await _applyAccountBalanceDelta(txToDelete, isAdding: false);
        }
        await loadTransactions();
      },
    );
  }

  Future<void> _applyAccountBalanceDelta(Transaction tx, {required bool isAdding}) async {
    if (_accountRepository == null) return;
    double delta = tx.amount;
    if (!isAdding) delta = -delta;

    switch (tx.transactionType) {
      case TransactionType.income:
        await _accountRepository.updateBalance(tx.accountId, delta);
        break;
      case TransactionType.expense:
        await _accountRepository.updateBalance(tx.accountId, -delta);
        break;
      case TransactionType.transfer:
        await _accountRepository.updateBalance(tx.accountId, -delta);
        final targetAccountId = _extractTargetAccountId(tx.note);
        if (targetAccountId != null && targetAccountId.isNotEmpty) {
          await _accountRepository.updateBalance(targetAccountId, delta);
        }
        break;
    }
  }

  String? _extractTargetAccountId(String note) {
    final match = RegExp(r'TargetAccount:([^\s]+)').firstMatch(note);
    return match?.group(1);
  }

  void setSearchQuery(String query) {
    final newState = state.copyWith(searchQuery: query);
    final filtered = _applyFilterAndSort(state.allTransactions, newState);
    emit(newState.copyWith(filteredTransactions: filtered));
  }

  void setCategoryFilter(String? categoryId) {
    final newState = categoryId == null
        ? state.copyWith(clearCategoryFilter: true)
        : state.copyWith(selectedCategoryFilter: categoryId);
    final filtered = _applyFilterAndSort(state.allTransactions, newState);
    emit(newState.copyWith(filteredTransactions: filtered));
  }

  void setTypeFilter(TransactionType? type) {
    final newState = type == null
        ? state.copyWith(clearTypeFilter: true)
        : state.copyWith(selectedTypeFilter: type);
    final filtered = _applyFilterAndSort(state.allTransactions, newState);
    emit(newState.copyWith(filteredTransactions: filtered));
  }

  void setDateRangeFilter(
    DateRangeFilter filter, {
    DateTime? start,
    DateTime? end,
  }) {
    final newState = state.copyWith(
      dateRangeFilter: filter,
      customStartDate: start,
      customEndDate: end,
    );
    final filtered = _applyFilterAndSort(state.allTransactions, newState);
    emit(newState.copyWith(filteredTransactions: filtered));
  }

  void setSortOption(TransactionSortOption option) {
    final newState = state.copyWith(sortOption: option);
    final filtered = _applyFilterAndSort(state.allTransactions, newState);
    emit(newState.copyWith(filteredTransactions: filtered));
  }

  void clearFilters() {
    final newState = state.copyWith(
      searchQuery: '',
      clearCategoryFilter: true,
      clearTypeFilter: true,
      dateRangeFilter: DateRangeFilter.all,
      sortOption: TransactionSortOption.newest,
    );
    final filtered = _applyFilterAndSort(state.allTransactions, newState);
    emit(newState.copyWith(filteredTransactions: filtered));
  }

  List<Transaction> _applyFilterAndSort(
    List<Transaction> transactions,
    TransactionState currentState,
  ) {
    var result = List<Transaction>.from(transactions);

    // 1. Search Query Filter (title, note, categoryId)
    if (currentState.searchQuery.trim().isNotEmpty) {
      final q = currentState.searchQuery.trim().toLowerCase();
      result = result.where((tx) {
        final titleMatch = tx.title.toLowerCase().contains(q);
        final noteMatch = tx.note.toLowerCase().contains(q);
        final categoryMatch = tx.categoryId.toLowerCase().contains(q);
        return titleMatch || noteMatch || categoryMatch;
      }).toList();
    }

    // 2. Category Filter
    if (currentState.selectedCategoryFilter != null) {
      result = result
          .where((tx) => tx.categoryId == currentState.selectedCategoryFilter)
          .toList();
    }

    // 3. Type Filter
    if (currentState.selectedTypeFilter != null) {
      result = result
          .where((tx) => tx.transactionType == currentState.selectedTypeFilter)
          .toList();
    }

    // 4. Date Range Filter
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    switch (currentState.dateRangeFilter) {
      case DateRangeFilter.today:
        result = result.where((tx) {
          final d = tx.transactionDate;
          return d.year == today.year &&
              d.month == today.month &&
              d.day == today.day;
        }).toList();
        break;
      case DateRangeFilter.yesterday:
        final yesterday = today.subtract(const Duration(days: 1));
        result = result.where((tx) {
          final d = tx.transactionDate;
          return d.year == yesterday.year &&
              d.month == yesterday.month &&
              d.day == yesterday.day;
        }).toList();
        break;
      case DateRangeFilter.thisWeek:
        final firstDayOfWeek = today.subtract(
          Duration(days: today.weekday - 1),
        );
        result = result.where((tx) {
          return tx.transactionDate.isAfter(
            firstDayOfWeek.subtract(const Duration(seconds: 1)),
          );
        }).toList();
        break;
      case DateRangeFilter.thisMonth:
        result = result.where((tx) {
          return tx.transactionDate.year == now.year &&
              tx.transactionDate.month == now.month;
        }).toList();
        break;
      case DateRangeFilter.custom:
        if (currentState.customStartDate != null) {
          result = result
              .where(
                (tx) =>
                    tx.transactionDate.isAfter(currentState.customStartDate!),
              )
              .toList();
        }
        if (currentState.customEndDate != null) {
          result = result
              .where(
                (tx) =>
                    tx.transactionDate.isBefore(currentState.customEndDate!),
              )
              .toList();
        }
        break;
      case DateRangeFilter.all:
        break;
    }

    // 5. Amount Range Filter
    if (currentState.minAmountFilter != null) {
      result = result
          .where((tx) => tx.amount >= currentState.minAmountFilter!)
          .toList();
    }
    if (currentState.maxAmountFilter != null) {
      result = result
          .where((tx) => tx.amount <= currentState.maxAmountFilter!)
          .toList();
    }

    // 6. Sorting
    switch (currentState.sortOption) {
      case TransactionSortOption.newest:
        result.sort((a, b) => b.transactionDate.compareTo(a.transactionDate));
        break;
      case TransactionSortOption.oldest:
        result.sort((a, b) => a.transactionDate.compareTo(b.transactionDate));
        break;
      case TransactionSortOption.highestAmount:
        result.sort((a, b) => b.amount.compareTo(a.amount));
        break;
      case TransactionSortOption.lowestAmount:
        result.sort((a, b) => a.amount.compareTo(b.amount));
        break;
      case TransactionSortOption.alphabetical:
        result.sort(
          (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
        );
        break;
    }

    return result;
  }
}
