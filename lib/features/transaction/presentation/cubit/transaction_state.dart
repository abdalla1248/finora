import 'package:equatable/equatable.dart';
import '../../domain/entities/transaction.dart';

enum DateRangeFilter { all, today, yesterday, thisWeek, thisMonth, custom }

enum TransactionSortOption {
  newest,
  oldest,
  highestAmount,
  lowestAmount,
  alphabetical,
}

class TransactionState extends Equatable {
  final List<Transaction> allTransactions;
  final List<Transaction> filteredTransactions;
  final bool isLoading;
  final String? errorMessage;
  final String searchQuery;
  final String? selectedCategoryFilter;
  final TransactionType? selectedTypeFilter;
  final DateRangeFilter dateRangeFilter;
  final DateTime? customStartDate;
  final DateTime? customEndDate;
  final double? minAmountFilter;
  final double? maxAmountFilter;
  final TransactionSortOption sortOption;

  const TransactionState({
    this.allTransactions = const [],
    this.filteredTransactions = const [],
    this.isLoading = false,
    this.errorMessage,
    this.searchQuery = '',
    this.selectedCategoryFilter,
    this.selectedTypeFilter,
    this.dateRangeFilter = DateRangeFilter.all,
    this.customStartDate,
    this.customEndDate,
    this.minAmountFilter,
    this.maxAmountFilter,
    this.sortOption = TransactionSortOption.newest,
  });

  TransactionState copyWith({
    List<Transaction>? allTransactions,
    List<Transaction>? filteredTransactions,
    bool? isLoading,
    String? errorMessage,
    String? searchQuery,
    String? selectedCategoryFilter,
    bool clearCategoryFilter = false,
    TransactionType? selectedTypeFilter,
    bool clearTypeFilter = false,
    DateRangeFilter? dateRangeFilter,
    DateTime? customStartDate,
    DateTime? customEndDate,
    double? minAmountFilter,
    double? maxAmountFilter,
    TransactionSortOption? sortOption,
  }) {
    return TransactionState(
      allTransactions: allTransactions ?? this.allTransactions,
      filteredTransactions: filteredTransactions ?? this.filteredTransactions,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategoryFilter: clearCategoryFilter
          ? null
          : (selectedCategoryFilter ?? this.selectedCategoryFilter),
      selectedTypeFilter: clearTypeFilter
          ? null
          : (selectedTypeFilter ?? this.selectedTypeFilter),
      dateRangeFilter: dateRangeFilter ?? this.dateRangeFilter,
      customStartDate: customStartDate ?? this.customStartDate,
      customEndDate: customEndDate ?? this.customEndDate,
      minAmountFilter: minAmountFilter ?? this.minAmountFilter,
      maxAmountFilter: maxAmountFilter ?? this.maxAmountFilter,
      sortOption: sortOption ?? this.sortOption,
    );
  }

  @override
  List<Object?> get props => [
    allTransactions,
    filteredTransactions,
    isLoading,
    errorMessage,
    searchQuery,
    selectedCategoryFilter,
    selectedTypeFilter,
    dateRangeFilter,
    customStartDate,
    customEndDate,
    minAmountFilter,
    maxAmountFilter,
    sortOption,
  ];
}
