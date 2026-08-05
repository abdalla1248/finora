import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:finora/features/budget/domain/entities/savings_goal.dart';
import 'package:finora/features/budget/domain/repositories/savings_goal_repository.dart';
import 'package:finora/features/budget/presentation/cubit/savings_goal_cubit.dart';
import 'package:finora/features/budget/presentation/cubit/savings_goal_state.dart';

class MockSavingsGoalRepository extends Mock implements SavingsGoalRepository {}

void main() {
  late SavingsGoalRepository mockRepository;
  late SavingsGoalCubit goalCubit;

  final now = DateTime.utc(2026, 8, 3);
  final tGoal = SavingsGoal(
    id: 'g_1',
    title: 'Vacation Trip',
    targetAmount: 2000.0,
    currentAmount: 500.0,
    deadline: now.add(const Duration(days: 100)),
    createdAt: now,
    updatedAt: now,
  );

  setUp(() {
    mockRepository = MockSavingsGoalRepository();
    goalCubit = SavingsGoalCubit(mockRepository);
  });

  tearDown(() {
    goalCubit.close();
  });

  test('initial state has empty goals list', () {
    expect(goalCubit.state, const SavingsGoalState());
  });

  group('loadGoals', () {
    test('emits [loading, loaded] when goals are retrieved', () async {
      when(
        () => mockRepository.getGoals(),
      ).thenAnswer((_) async => Right([tGoal]));

      final future = expectLater(
        goalCubit.stream,
        emitsInOrder([
          const SavingsGoalState(isLoading: true),
          SavingsGoalState(goals: [tGoal], isLoading: false),
        ]),
      );

      await goalCubit.loadGoals();
      await future;
    });
  });
}
