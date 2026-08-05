import 'package:flutter_test/flutter_test.dart';
import 'package:finora/features/budget/domain/entities/budget.dart';

void main() {
  final now = DateTime.utc(2026, 8, 3);
  final tBudget = Budget(
    id: 'budget_1',
    name: 'Monthly Dining Budget',
    categoryId: 'food',
    budgetType: BudgetType.monthly,
    amount: 1000.0,
    currencyCode: 'USD',
    startDate: now,
    endDate: now.add(const Duration(days: 30)),
    createdAt: now,
    updatedAt: now,
  );

  group('Budget Entity', () {
    test('calculates correct alert levels', () {
      expect(tBudget.getAlertLevel(500.0), equals(BudgetAlertLevel.green));
      expect(tBudget.getAlertLevel(750.0), equals(BudgetAlertLevel.yellow));
      expect(tBudget.getAlertLevel(950.0), equals(BudgetAlertLevel.red));
      expect(tBudget.getAlertLevel(1050.0), equals(BudgetAlertLevel.exceeded));
    });

    test('copyWith updates properties correctly', () {
      final updated = tBudget.copyWith(amount: 1200.0, name: 'Updated Name');
      expect(updated.amount, equals(1200.0));
      expect(updated.name, equals('Updated Name'));
    });
  });
}
