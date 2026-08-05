import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/budget.dart';
import '../../domain/repositories/budget_repository.dart';
import 'budget_state.dart';

class BudgetCubit extends Cubit<BudgetState> {
  final BudgetRepository _budgetRepository;

  BudgetCubit(this._budgetRepository) : super(const BudgetState());

  Future<void> loadBudgets() async {
    emit(state.copyWith(isLoading: true));
    final result = await _budgetRepository.getBudgets();
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (budgets) => emit(state.copyWith(budgets: budgets, isLoading: false)),
    );
  }

  Future<void> addBudget(Budget budget) async {
    emit(state.copyWith(isLoading: true));
    final result = await _budgetRepository.saveBudget(budget);
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (_) => loadBudgets(),
    );
  }

  Future<void> updateBudget(Budget budget) async {
    emit(state.copyWith(isLoading: true));
    final updated = budget.copyWith(updatedAt: DateTime.now());
    final result = await _budgetRepository.saveBudget(updated);
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (_) => loadBudgets(),
    );
  }

  Future<void> deleteBudget(String id) async {
    emit(state.copyWith(isLoading: true));
    final result = await _budgetRepository.deleteBudget(id);
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (_) => loadBudgets(),
    );
  }
}
