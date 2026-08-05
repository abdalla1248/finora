import 'package:flutter_test/flutter_test.dart';
import 'package:finora/features/account/domain/entities/account.dart';
import 'package:finora/features/backup/domain/services/backup_service.dart';
import 'package:finora/features/transaction/domain/entities/transaction.dart';

void main() {
  const service = BackupService();
  final now = DateTime.utc(2026, 8, 3);

  final tTx = Transaction(
    id: 'tx_1',
    title: 'Groceries',
    amount: 50.0,
    transactionType: TransactionType.expense,
    categoryId: 'food',
    accountId: 'account_1',
    currencyCode: 'USD',
    transactionDate: now,
    createdAt: now,
    updatedAt: now,
    note: 'Weekly grocery run',
  );

  final tAccount = Account(
    id: 'account_1',
    name: 'Main Cash',
    type: AccountType.cash,
    balance: 500.0,
    currencyCode: 'USD',
    createdAt: now,
    updatedAt: now,
  );

  group('BackupService', () {
    test('exports to JSON correctly and validates imports', () {
      final jsonString = service.exportToJson(
        transactions: [tTx],
        budgets: [],
        goals: [],
        accounts: [tAccount],
      );

      expect(jsonString, contains('"transactions"'));
      expect(jsonString, contains('"accounts"'));

      final result = service.importFromJson(jsonString);
      expect(result['transactionsCount'], equals(1));
      expect(result['accountsCount'], equals(1));
    });

    test('exports transactions to CSV correctly', () {
      final csvString = service.exportToCsv([tTx]);
      expect(csvString, contains('Groceries,50.0,expense,food,account_1,USD'));
    });
  });
}
