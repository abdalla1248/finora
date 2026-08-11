import '../../../account/domain/entities/account.dart';
import '../entities/savings_goal.dart';

class GoalAllocationService {
  const GoalAllocationService();

  /// Calculates total money allocated to all goals linked to a specific account ID.
  /// If a goal has no linkedAccountId, it falls back to the default account.
  static double calculateTotalAllocatedForAccount(
    String accountId,
    List<SavingsGoal> allGoals, {
    bool isDefaultAccount = false,
  }) {
    double total = 0.0;
    for (final goal in allGoals) {
      if (goal.linkedAccountId == accountId) {
        total += goal.allocatedAmount;
      } else if (goal.linkedAccountId == null && isDefaultAccount) {
        total += goal.allocatedAmount;
      }
    }
    return total;
  }

  /// Calculates available unallocated balance for an account.
  static double calculateUnallocatedBalance(
    Account account,
    List<SavingsGoal> allGoals,
  ) {
    final allocated = calculateTotalAllocatedForAccount(
      account.id,
      allGoals,
      isDefaultAccount: account.isDefault,
    );
    final available = account.balance - allocated;
    return available < 0 ? 0.0 : available;
  }

  /// Validates an allocation attempt toward a goal.
  /// Returns null if valid, or an error message key/string if invalid.
  static String? validateAllocation({
    required double amountToAllocate,
    required SavingsGoal goal,
    required Account targetAccount,
    required List<SavingsGoal> allGoals,
  }) {
    if (amountToAllocate <= 0) {
      return 'Allocation amount must be greater than zero.';
    }

    final availableUnallocated = calculateUnallocatedBalance(
      targetAccount,
      allGoals,
    );
    if (amountToAllocate > availableUnallocated) {
      return 'Insufficient unallocated balance. Available: ${availableUnallocated.toStringAsFixed(2)} ${targetAccount.currencyCode}';
    }

    final remainingGoal = goal.remainingAmount;
    if (amountToAllocate > remainingGoal) {
      return 'Allocation exceeds remaining goal target (${remainingGoal.toStringAsFixed(2)} ${targetAccount.currencyCode}).';
    }

    return null;
  }
}
