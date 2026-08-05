import 'package:finora/features/account/domain/entities/account.dart';
import 'package:finora/features/backup/domain/services/backup_service.dart';
import 'package:finora/features/budget/domain/entities/budget.dart';
import 'package:finora/features/transaction/domain/entities/transaction.dart';
import 'package:finora/features/user/domain/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime.utc(2026, 8, 3);

  group('Finora End-to-End Core User Flow', () {
    test(
      'User onboarding to transaction logging and budget calculation flow',
      () {
        // 1. User Profile Setup
        final user = User(
          id: 'user_1',
          name: 'Abdalla',
          preferredCurrencyCode: 'USD',
          preferredLanguage: 'en',
          themeMode: 'system',
          onboardingCompleted: true,
          createdAt: now,
          lastOpenedAt: now,
        );
        expect(user.name, equals('Abdalla'));
        expect(user.preferredCurrencyCode, equals('USD'));

        // 2. Multi-Account Setup
        final account = Account(
          id: 'acc_1',
          name: 'Bank Account',
          type: AccountType.bank,
          balance: 2500.0,
          currencyCode: user.preferredCurrencyCode,
          createdAt: now,
          updatedAt: now,
        );
        expect(account.balance, equals(2500.0));

        // 3. Transaction Logging
        final transaction = Transaction(
          id: 'tx_1',
          title: 'Supermarket Purchase',
          amount: 150.0,
          transactionType: TransactionType.expense,
          categoryId: 'food',
          accountId: account.id,
          currencyCode: user.preferredCurrencyCode,
          transactionDate: now,
          createdAt: now,
          updatedAt: now,
        );
        expect(transaction.amount, equals(150.0));

        // 4. Budget Tracking & Alert Triggering
        final budget = Budget(
          id: 'b_1',
          name: 'Food Budget',
          categoryId: 'food',
          budgetType: BudgetType.monthly,
          amount: 200.0,
          currencyCode: user.preferredCurrencyCode,
          startDate: now,
          endDate: now.add(const Duration(days: 30)),
          createdAt: now,
          updatedAt: now,
        );

        final alertLevel = budget.getAlertLevel(transaction.amount);
        // 150 / 200 = 75% -> Yellow Alert Warning Level
        expect(alertLevel, equals(BudgetAlertLevel.yellow));

        // 5. Data Backup & Export Validation
        const backupService = BackupService();
        final jsonBackup = backupService.exportToJson(
          transactions: [transaction],
          budgets: [budget],
          goals: [],
          accounts: [account],
        );

        expect(jsonBackup, contains('Supermarket Purchase'));
        expect(jsonBackup, contains('Bank Account'));

        final importData = backupService.importFromJson(jsonBackup);
        expect(importData['transactionsCount'], equals(1));
        expect(importData['accountsCount'], equals(1));
        expect(importData['budgetsCount'], equals(1));
      },
    );
  });
}
