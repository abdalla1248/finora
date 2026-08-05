import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:finora/core/error/failures.dart';
import 'package:finora/features/budget/domain/entities/budget.dart';
import 'package:finora/features/budget/domain/repositories/budget_repository.dart';
import 'package:finora/features/budget/presentation/cubit/budget_cubit.dart';
import 'package:finora/features/budget/presentation/cubit/budget_state.dart';

class MockBudgetRepository extends Mock implements BudgetRepository {}

void main() {
  late BudgetRepository mockRepository;
  late BudgetCubit budgetCubit;

  final now = DateTime.utc(2026, 8, 3);
  final tBudget = Budget(
    id: 'b_1',
    name: 'Food Budget',
    categoryId: 'food',
    budgetType: BudgetType.monthly,
    amount: 500.0,
    currencyCode: 'USD',
    startDate: now,
    endDate: now.add(const Duration(days: 30)),
    createdAt: now,
    updatedAt: now,
  );

  setUp(() {
    mockRepository = MockBudgetRepository();
    budgetCubit = BudgetCubit(mockRepository);
  });

  tearDown(() {
    budgetCubit.close();
  });

  test('initial state has empty budgets list', () {
    expect(budgetCubit.state, const BudgetState());
  });

  group('loadBudgets', () {
    test('emits [loading, loaded] when budgets are retrieved', () async {
      when(
        () => mockRepository.getBudgets(),
      ).thenAnswer((_) async => Right([tBudget]));

      final future = expectLater(
        budgetCubit.stream,
        emitsInOrder([
          const BudgetState(isLoading: true),
          BudgetState(budgets: [tBudget], isLoading: false),
        ]),
      );

      await budgetCubit.loadBudgets();
      await future;
    });

    test('emits error message when load fails', () async {
      when(
        () => mockRepository.getBudgets(),
      ).thenAnswer((_) async => const Left(DatabaseFailure('Storage Error')));

      final future = expectLater(
        budgetCubit.stream,
        emitsInOrder([
          const BudgetState(isLoading: true),
          const BudgetState(isLoading: false, errorMessage: 'Storage Error'),
        ]),
      );

      await budgetCubit.loadBudgets();
      await future;
    });
  });
}
