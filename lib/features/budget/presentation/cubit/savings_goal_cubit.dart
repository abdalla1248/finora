import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/savings_goal.dart';
import '../../domain/repositories/savings_goal_repository.dart';
import 'savings_goal_state.dart';

class SavingsGoalCubit extends Cubit<SavingsGoalState> {
  final SavingsGoalRepository _goalRepository;

  SavingsGoalCubit(this._goalRepository) : super(const SavingsGoalState());

  Future<void> loadGoals() async {
    emit(state.copyWith(isLoading: true));
    final result = await _goalRepository.getGoals();
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (goals) => emit(state.copyWith(goals: goals, isLoading: false)),
    );
  }

  Future<void> addGoal(SavingsGoal goal) async {
    emit(state.copyWith(isLoading: true));
    final result = await _goalRepository.saveGoal(goal);
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (_) => loadGoals(),
    );
  }

  Future<void> updateGoal(SavingsGoal goal) async {
    emit(state.copyWith(isLoading: true));
    final updated = goal.copyWith(updatedAt: DateTime.now());
    final result = await _goalRepository.saveGoal(updated);
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (_) => loadGoals(),
    );
  }

  Future<void> deleteGoal(String id) async {
    emit(state.copyWith(isLoading: true));
    final result = await _goalRepository.deleteGoal(id);
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (_) => loadGoals(),
    );
  }
}
