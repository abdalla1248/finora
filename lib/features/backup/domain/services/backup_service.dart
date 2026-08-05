import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../../../../core/storage/storage_service.dart';
import '../../../account/data/models/account_model.dart';
import '../../../account/domain/entities/account.dart';
import '../../../budget/data/models/budget_model.dart';
import '../../../budget/data/models/savings_goal_model.dart';
import '../../../budget/domain/entities/budget.dart';
import '../../../budget/domain/entities/savings_goal.dart';
import '../../../transaction/data/models/transaction_model.dart';
import '../../../transaction/domain/entities/transaction.dart';

class BackupService {
  final StorageService? _storageService;

  const BackupService([this._storageService]);

  String exportToJson({
    required List<Transaction> transactions,
    required List<Budget> budgets,
    required List<SavingsGoal> goals,
    required List<Account> accounts,
  }) {
    final payload = {
      'version': '1.0.0',
      'timestamp': DateTime.now().toIso8601String(),
      'transactions': transactions
          .map(
            (t) => {
              'id': t.id,
              'title': t.title,
              'amount': t.amount,
              'type': t.transactionType.name,
              'categoryId': t.categoryId,
              'accountId': t.accountId,
              'currencyCode': t.currencyCode,
              'transactionDate': t.transactionDate.toIso8601String(),
              'createdAt': t.createdAt.toIso8601String(),
              'updatedAt': t.updatedAt.toIso8601String(),
              'note': t.note,
            },
          )
          .toList(),
      'budgets': budgets
          .map(
            (b) => {
              'id': b.id,
              'name': b.name,
              'amount': b.amount,
              'categoryId': b.categoryId,
              'budgetType': b.budgetType.name,
              'currencyCode': b.currencyCode,
              'startDate': b.startDate.toIso8601String(),
              'endDate': b.endDate.toIso8601String(),
              'createdAt': b.createdAt.toIso8601String(),
              'updatedAt': b.updatedAt.toIso8601String(),
            },
          )
          .toList(),
      'goals': goals
          .map(
            (g) => {
              'id': g.id,
              'title': g.title,
              'targetAmount': g.targetAmount,
              'currentAmount': g.currentAmount,
              'deadline': g.deadline.toIso8601String(),
              'notes': g.notes,
              'createdAt': g.createdAt.toIso8601String(),
              'updatedAt': g.updatedAt.toIso8601String(),
              'isCompleted': g.isCompleted,
            },
          )
          .toList(),
      'accounts': accounts
          .map(
            (a) => {
              'id': a.id,
              'name': a.name,
              'type': a.type.name,
              'balance': a.balance,
              'currencyCode': a.currencyCode,
              'createdAt': a.createdAt.toIso8601String(),
              'updatedAt': a.updatedAt.toIso8601String(),
              'isDefault': a.isDefault,
            },
          )
          .toList(),
    };

    return const JsonEncoder.withIndent('  ').convert(payload);
  }

  Future<File> writeExportFile(String filename, String content) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$filename');
    return await file.writeAsString(content);
  }

  String exportToCsv(List<Transaction> transactions) {
    final buffer = StringBuffer();
    buffer.writeln('ID,Title,Amount,Type,Category,Account,Currency,Date,Note');

    for (final t in transactions) {
      final title = t.title.replaceAll(',', ' ');
      final note = t.note.replaceAll(',', ' ');
      buffer.writeln(
        '${t.id},$title,${t.amount},${t.transactionType.name},${t.categoryId},${t.accountId},${t.currencyCode},${t.transactionDate.toIso8601String()},$note',
      );
    }

    return buffer.toString();
  }

  Map<String, dynamic> importFromJson(String jsonString) {
    final decoded = json.decode(jsonString) as Map<String, dynamic>;
    return {
      'version': decoded['version'] ?? '1.0.0',
      'transactionsCount': (decoded['transactions'] as List?)?.length ?? 0,
      'budgetsCount': (decoded['budgets'] as List?)?.length ?? 0,
      'goalsCount': (decoded['goals'] as List?)?.length ?? 0,
      'accountsCount': (decoded['accounts'] as List?)?.length ?? 0,
    };
  }

  Future<Map<String, dynamic>> importAndRestoreFromJson(String jsonString) async {
    final decoded = json.decode(jsonString) as Map<String, dynamic>;
    if (_storageService != null) {
      // 1. Transactions
      final txList = decoded['transactions'] as List? ?? [];
      final txBox = await _storageService.openEncryptedBox<TransactionModel>(HiveBoxNames.transactions);
      await txBox.clear();
      for (final item in txList) {
        final m = TransactionModel(
          id: item['id'],
          title: item['title'],
          description: item['description'] ?? '',
          amount: (item['amount'] as num).toDouble(),
          transactionType: item['type'] ?? TransactionType.expense.name,
          categoryId: item['categoryId'],
          accountId: item['accountId'] ?? 'default_cash_account',
          currencyCode: item['currencyCode'] ?? 'USD',
          transactionDate: DateTime.parse(item['transactionDate']),
          createdAt: DateTime.tryParse(item['createdAt'] ?? '') ?? DateTime.now(),
          updatedAt: DateTime.tryParse(item['updatedAt'] ?? '') ?? DateTime.now(),
          tags: (item['tags'] as List?)?.cast<String>() ?? const [],
          note: item['note'] ?? '',
          isRecurring: item['isRecurring'] ?? false,
          isDeleted: item['isDeleted'] ?? false,
        );
        await txBox.put(m.id, m);
      }

      // 2. Accounts
      final accountList = decoded['accounts'] as List? ?? [];
      final accountBox = await _storageService.openEncryptedBox<AccountModel>(HiveBoxNames.accounts);
      await accountBox.clear();
      for (final item in accountList) {
        final m = AccountModel(
          id: item['id'],
          name: item['name'],
          type: item['type'] ?? AccountType.cash.name,
          balance: (item['balance'] as num).toDouble(),
          currencyCode: item['currencyCode'] ?? 'USD',
          createdAt: DateTime.tryParse(item['createdAt'] ?? '') ?? DateTime.now(),
          updatedAt: DateTime.tryParse(item['updatedAt'] ?? '') ?? DateTime.now(),
          isArchived: item['isArchived'] ?? false,
          isDefault: item['isDefault'] ?? false,
        );
        await accountBox.put(m.id, m);
      }

      // 3. Budgets
      final budgetList = decoded['budgets'] as List? ?? [];
      final budgetBox = await _storageService.openEncryptedBox<BudgetModel>(HiveBoxNames.budgets);
      await budgetBox.clear();
      for (final item in budgetList) {
        final m = BudgetModel(
          id: item['id'],
          name: item['name'],
          amount: (item['amount'] as num).toDouble(),
          categoryId: item['categoryId'],
          budgetType: item['budgetType'] ?? BudgetType.monthly.name,
          currencyCode: item['currencyCode'] ?? 'USD',
          startDate: DateTime.tryParse(item['startDate'] ?? '') ?? DateTime.now(),
          endDate: DateTime.tryParse(item['endDate'] ?? '') ?? DateTime.now().add(const Duration(days: 30)),
          alertThreshold: (item['alertThreshold'] as num?)?.toDouble() ?? 80.0,
          createdAt: DateTime.tryParse(item['createdAt'] ?? '') ?? DateTime.now(),
          updatedAt: DateTime.tryParse(item['updatedAt'] ?? '') ?? DateTime.now(),
          isArchived: item['isArchived'] ?? false,
        );
        await budgetBox.put(m.id, m);
      }

      // 4. Goals
      final goalList = decoded['goals'] as List? ?? [];
      final goalBox = await _storageService.openEncryptedBox<SavingsGoalModel>(HiveBoxNames.goals);
      await goalBox.clear();
      for (final item in goalList) {
        final m = SavingsGoalModel(
          id: item['id'],
          title: item['title'],
          targetAmount: (item['targetAmount'] as num).toDouble(),
          currentAmount: (item['currentAmount'] as num).toDouble(),
          deadline: DateTime.parse(item['deadline']),
          notes: item['notes'] ?? '',
          createdAt: DateTime.tryParse(item['createdAt'] ?? '') ?? DateTime.now(),
          updatedAt: DateTime.tryParse(item['updatedAt'] ?? '') ?? DateTime.now(),
          isCompleted: item['isCompleted'] ?? false,
        );
        await goalBox.put(m.id, m);
      }
    }

    return {
      'version': decoded['version'] ?? '1.0.0',
      'transactionsCount': (decoded['transactions'] as List?)?.length ?? 0,
      'budgetsCount': (decoded['budgets'] as List?)?.length ?? 0,
      'goalsCount': (decoded['goals'] as List?)?.length ?? 0,
      'accountsCount': (decoded['accounts'] as List?)?.length ?? 0,
    };
  }

  Future<void> factoryReset() async {
    if (_storageService != null) {
      await _storageService.clearAllData();
    }
  }
}
