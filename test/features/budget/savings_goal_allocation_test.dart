import 'package:finora/features/account/domain/entities/account.dart';
import 'package:finora/features/budget/domain/entities/savings_goal.dart';
import 'package:finora/features/budget/domain/services/goal_allocation_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime.now();
  final testAccount = Account(
    id: 'acc_1',
    name: 'Savings Account',
    type: AccountType.savings,
    balance: 10000.0,
    currencyCode: 'USD',
    createdAt: now,
    updatedAt: now,
    isDefault: true,
  );

  group('SavingsGoal Progress & Remaining Calculations', () {
    test('0 / 10,000 = 0%', () {
      final goal = SavingsGoal(
        id: 'g1',
        title: 'Laptop',
        targetAmount: 10000.0,
        allocatedAmount: 0.0,
        deadline: now.add(const Duration(days: 30)),
        createdAt: now,
        updatedAt: now,
      );
      expect(goal.progressPercentage, equals(0.0));
      expect(goal.remainingAmount, equals(10000.0));
      expect(goal.status, equals(SavingsGoalStatus.active));
    });

    test('2,500 / 10,000 = 25%', () {
      final goal = SavingsGoal(
        id: 'g1',
        title: 'Laptop',
        targetAmount: 10000.0,
        allocatedAmount: 2500.0,
        deadline: now.add(const Duration(days: 30)),
        createdAt: now,
        updatedAt: now,
      );
      expect(goal.progressPercentage, equals(25.0));
      expect(goal.remainingAmount, equals(7500.0));
    });

    test('5,000 / 10,000 = 50%', () {
      final goal = SavingsGoal(
        id: 'g1',
        title: 'Laptop',
        targetAmount: 10000.0,
        allocatedAmount: 5000.0,
        deadline: now.add(const Duration(days: 30)),
        createdAt: now,
        updatedAt: now,
      );
      expect(goal.progressPercentage, equals(50.0));
      expect(goal.remainingAmount, equals(5000.0));
    });

    test('10,000 / 10,000 = 100% and Completed status', () {
      final goal = SavingsGoal(
        id: 'g1',
        title: 'Laptop',
        targetAmount: 10000.0,
        allocatedAmount: 10000.0,
        deadline: now.add(const Duration(days: 30)),
        createdAt: now,
        updatedAt: now,
      );
      expect(goal.progressPercentage, equals(100.0));
      expect(goal.remainingAmount, equals(0.0));
      expect(goal.status, equals(SavingsGoalStatus.completed));
    });

    test('Allocated amount exceeding target clamps progress to 100%', () {
      final goal = SavingsGoal(
        id: 'g1',
        title: 'Laptop',
        targetAmount: 10000.0,
        allocatedAmount: 12000.0,
        deadline: now.add(const Duration(days: 30)),
        createdAt: now,
        updatedAt: now,
      );
      expect(goal.progressPercentage, equals(100.0));
      expect(goal.remainingAmount, equals(0.0));
      expect(goal.status, equals(SavingsGoalStatus.completed));
    });
  });

  group('Goal Allocation Service & Validation Rules', () {
    test('Valid allocation succeeds', () {
      final goal = SavingsGoal(
        id: 'g1',
        title: 'Laptop',
        targetAmount: 10000.0,
        allocatedAmount: 2000.0,
        linkedAccountId: 'acc_1',
        deadline: now.add(const Duration(days: 30)),
        createdAt: now,
        updatedAt: now,
      );

      final error = GoalAllocationService.validateAllocation(
        amountToAllocate: 3000.0,
        goal: goal,
        targetAccount: testAccount,
        allGoals: [goal],
      );

      expect(error, isNull);
    });

    test('Zero allocation is rejected', () {
      final goal = SavingsGoal(
        id: 'g1',
        title: 'Laptop',
        targetAmount: 10000.0,
        allocatedAmount: 2000.0,
        linkedAccountId: 'acc_1',
        deadline: now.add(const Duration(days: 30)),
        createdAt: now,
        updatedAt: now,
      );

      final error = GoalAllocationService.validateAllocation(
        amountToAllocate: 0.0,
        goal: goal,
        targetAccount: testAccount,
        allGoals: [goal],
      );

      expect(error, isNotNull);
      expect(error, contains('greater than zero'));
    });

    test('Negative allocation is rejected', () {
      final goal = SavingsGoal(
        id: 'g1',
        title: 'Laptop',
        targetAmount: 10000.0,
        allocatedAmount: 2000.0,
        linkedAccountId: 'acc_1',
        deadline: now.add(const Duration(days: 30)),
        createdAt: now,
        updatedAt: now,
      );

      final error = GoalAllocationService.validateAllocation(
        amountToAllocate: -500.0,
        goal: goal,
        targetAccount: testAccount,
        allGoals: [goal],
      );

      expect(error, isNotNull);
    });

    test('Allocation exceeding unallocated balance is rejected', () {
      // Account balance 10,000. Goal 1 allocated 7,000. Unallocated = 3,000.
      final goal1 = SavingsGoal(
        id: 'g1',
        title: 'Laptop',
        targetAmount: 15000.0,
        allocatedAmount: 7000.0,
        linkedAccountId: 'acc_1',
        deadline: now.add(const Duration(days: 30)),
        createdAt: now,
        updatedAt: now,
      );

      // Try allocating 4,000 when unallocated is 3,000
      final error = GoalAllocationService.validateAllocation(
        amountToAllocate: 4000.0,
        goal: goal1,
        targetAccount: testAccount,
        allGoals: [goal1],
      );

      expect(error, isNotNull);
      expect(error, contains('Insufficient unallocated balance'));
    });

    test('Allocation exceeding remaining goal target is rejected', () {
      // Target 10,000. Allocated 8,000. Remaining = 2,000.
      final goal = SavingsGoal(
        id: 'g1',
        title: 'Laptop',
        targetAmount: 10000.0,
        allocatedAmount: 8000.0,
        linkedAccountId: 'acc_1',
        deadline: now.add(const Duration(days: 30)),
        createdAt: now,
        updatedAt: now,
      );

      // Attempt to allocate 3,000 when remaining is 2,000
      final accountWithBalance = testAccount.copyWith(balance: 20000.0);
      final error = GoalAllocationService.validateAllocation(
        amountToAllocate: 3000.0,
        goal: goal,
        targetAccount: accountWithBalance,
        allGoals: [goal],
      );

      expect(error, isNotNull);
      expect(error, contains('exceeds remaining goal target'));
    });
  });

  group('Multiple Goals Allocation Rules', () {
    test('Multiple goals correctly share account balance without double-counting', () {
      final goal1 = SavingsGoal(
        id: 'g1',
        title: 'Laptop',
        targetAmount: 10000.0,
        allocatedAmount: 5000.0,
        linkedAccountId: 'acc_1',
        deadline: now.add(const Duration(days: 30)),
        createdAt: now,
        updatedAt: now,
      );

      final goal2 = SavingsGoal(
        id: 'g2',
        title: 'Phone',
        targetAmount: 5000.0,
        allocatedAmount: 3000.0,
        linkedAccountId: 'acc_1',
        deadline: now.add(const Duration(days: 30)),
        createdAt: now,
        updatedAt: now,
      );

      final goals = [goal1, goal2];

      final totalAllocated = GoalAllocationService.calculateTotalAllocatedForAccount('acc_1', goals);
      final unallocated = GoalAllocationService.calculateUnallocatedBalance(testAccount, goals);

      expect(totalAllocated, equals(8000.0));
      expect(unallocated, equals(2000.0));
    });
  });

  group('Deadline & Status Priority', () {
    test('Completed status takes priority over overdue deadline', () {
      final yesterday = now.subtract(const Duration(days: 2));
      final goal = SavingsGoal(
        id: 'g1',
        title: 'Laptop',
        targetAmount: 10000.0,
        allocatedAmount: 10000.0,
        deadline: yesterday,
        createdAt: now,
        updatedAt: now,
      );

      expect(goal.status, equals(SavingsGoalStatus.completed));
      expect(goal.isExpired, isFalse);
    });

    test('Uncompleted goal with past deadline is overdue', () {
      final yesterday = now.subtract(const Duration(days: 2));
      final goal = SavingsGoal(
        id: 'g1',
        title: 'Laptop',
        targetAmount: 10000.0,
        allocatedAmount: 5000.0,
        deadline: yesterday,
        createdAt: now,
        updatedAt: now,
      );

      expect(goal.status, equals(SavingsGoalStatus.overdue));
      expect(goal.isExpired, isTrue);
    });
  });
}
