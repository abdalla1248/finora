import 'package:equatable/equatable.dart';
import '../../domain/entities/savings_goal.dart';

class SavingsGoalState extends Equatable {
  final List<SavingsGoal> goals;
  final bool isLoading;
  final String? errorMessage;

  const SavingsGoalState({
    this.goals = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  SavingsGoalState copyWith({
    List<SavingsGoal>? goals,
    bool? isLoading,
    String? errorMessage,
  }) {
    return SavingsGoalState(
      goals: goals ?? this.goals,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [goals, isLoading, errorMessage];
}
