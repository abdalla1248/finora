import 'package:flutter_test/flutter_test.dart';
import 'package:finora/features/analytics/domain/services/analytics_service.dart';
import 'package:finora/features/transaction/domain/entities/transaction.dart';

void main() {
  const service = AnalyticsService();
  final now = DateTime.utc(2026, 8, 3);

  final tIncome = Transaction(
    id: 'tx_1',
    title: 'Salary Deposit',
    amount: 5000.0,
    transactionType: TransactionType.income,
    categoryId: 'salary',
    accountId: 'default',
    currencyCode: 'USD',
    transactionDate: now,
    createdAt: now,
    updatedAt: now,
  );

  final tExpense1 = Transaction(
    id: 'tx_2',
    title: 'Grocery Store',
    amount: 200.0,
    transactionType: TransactionType.expense,
    categoryId: 'food',
    accountId: 'default',
    currencyCode: 'USD',
    transactionDate: now,
    createdAt: now,
    updatedAt: now,
  );

  final tExpense2 = Transaction(
    id: 'tx_3',
    title: 'Bus Ticket',
    amount: 50.0,
    transactionType: TransactionType.expense,
    categoryId: 'transportation',
    accountId: 'default',
    currencyCode: 'USD',
    transactionDate: now,
    createdAt: now,
    updatedAt: now,
  );

  final transactions = [tIncome, tExpense1, tExpense2];

  group('AnalyticsService', () {
    test('calculateTotalIncome sums income transactions correctly', () {
      final total = service.calculateTotalIncome(transactions);
      expect(total, equals(5000.0));
    });

    test('calculateTotalExpense sums expense transactions correctly', () {
      final total = service.calculateTotalExpense(transactions);
      expect(total, equals(250.0));
    });

    test('calculateNetCashFlow calculates difference correctly', () {
      final net = service.calculateNetCashFlow(5000.0, 250.0);
      expect(net, equals(4750.0));
    });

    test('calculateSavingsRate computes percentage correctly', () {
      final rate = service.calculateSavingsRate(5000.0, 250.0);
      expect(rate, equals(95.0));
    });

    test('generateInsights builds deterministic insights list', () {
      final insights = service.generateInsights(transactions, 'USD');
      expect(insights, isNotEmpty);
      expect(insights.any((i) => i.id == 'highest_spending_category'), isTrue);
      expect(insights.any((i) => i.id == 'largest_expense'), isTrue);
      expect(insights.any((i) => i.id == 'largest_income'), isTrue);
    });
  });
}
