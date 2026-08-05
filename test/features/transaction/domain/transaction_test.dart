import 'package:flutter_test/flutter_test.dart';
import 'package:finora/features/transaction/domain/entities/transaction.dart';

void main() {
  final now = DateTime.utc(2026, 8, 3);
  final tTransaction = Transaction(
    id: 'tx_1',
    title: 'Grocery Shopping',
    amount: 54.50,
    transactionType: TransactionType.expense,
    categoryId: 'food',
    accountId: 'default',
    currencyCode: 'USD',
    transactionDate: now,
    createdAt: now,
    updatedAt: now,
  );

  group('Transaction Entity', () {
    test('supports value equality', () {
      final t2 = Transaction(
        id: 'tx_1',
        title: 'Grocery Shopping',
        amount: 54.50,
        transactionType: TransactionType.expense,
        categoryId: 'food',
        accountId: 'default',
        currencyCode: 'USD',
        transactionDate: now,
        createdAt: now,
        updatedAt: now,
      );

      expect(tTransaction, equals(t2));
    });

    test('copyWith updates properties correctly', () {
      final updated = tTransaction.copyWith(
        amount: 75.00,
        title: 'Supermarket',
      );

      expect(updated.amount, equals(75.00));
      expect(updated.title, equals('Supermarket'));
      expect(updated.id, equals('tx_1'));
    });
  });
}
