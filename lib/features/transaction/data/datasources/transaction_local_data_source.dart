import 'package:hive/hive.dart';
import '../../../../core/storage/storage_service.dart';
import '../models/transaction_model.dart';

abstract class TransactionLocalDataSource {
  Future<List<TransactionModel>> getTransactions();
  Future<void> saveTransaction(TransactionModel transaction);
  Future<void> deleteTransaction(String id);
  Future<void> clear();
}

class TransactionLocalDataSourceImpl implements TransactionLocalDataSource {
  final StorageService _storageService;

  TransactionLocalDataSourceImpl(this._storageService);

  Future<Box<TransactionModel>> get _box async => await _storageService
      .openEncryptedBox<TransactionModel>(HiveBoxNames.transactions);

  @override
  Future<List<TransactionModel>> getTransactions() async {
    final box = await _box;
    return box.values.where((tx) => !tx.isDeleted).toList();
  }

  @override
  Future<void> saveTransaction(TransactionModel transaction) async {
    final box = await _box;
    await box.put(transaction.id, transaction);
  }

  @override
  Future<void> deleteTransaction(String id) async {
    final box = await _box;
    final existing = box.get(id);
    if (existing != null) {
      final softDeleted = TransactionModel(
        id: existing.id,
        title: existing.title,
        description: existing.description,
        amount: existing.amount,
        transactionType: existing.transactionType,
        categoryId: existing.categoryId,
        accountId: existing.accountId,
        currencyCode: existing.currencyCode,
        transactionDate: existing.transactionDate,
        createdAt: existing.createdAt,
        updatedAt: DateTime.now(),
        tags: existing.tags,
        note: existing.note,
        attachmentPath: existing.attachmentPath,
        isRecurring: existing.isRecurring,
        recurrenceRule: existing.recurrenceRule,
        location: existing.location,
        isDeleted: true,
      );
      await box.put(id, softDeleted);
    }
  }

  @override
  Future<void> clear() async {
    final box = await _box;
    await box.clear();
  }
}
