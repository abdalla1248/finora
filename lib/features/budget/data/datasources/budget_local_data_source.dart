import 'package:hive/hive.dart';
import '../../../../core/storage/storage_service.dart';
import '../models/budget_model.dart';

abstract class BudgetLocalDataSource {
  Future<List<BudgetModel>> getBudgets();
  Future<void> saveBudget(BudgetModel model);
  Future<void> deleteBudget(String id);
  Future<void> clear();
}

class BudgetLocalDataSourceImpl implements BudgetLocalDataSource {
  final StorageService _storageService;

  BudgetLocalDataSourceImpl(this._storageService);

  Future<Box<BudgetModel>> get _box async =>
      await _storageService.openEncryptedBox<BudgetModel>(HiveBoxNames.budgets);

  @override
  Future<List<BudgetModel>> getBudgets() async {
    final box = await _box;
    return box.values.where((b) => !b.isArchived).toList();
  }

  @override
  Future<void> saveBudget(BudgetModel model) async {
    final box = await _box;
    await box.put(model.id, model);
  }

  @override
  Future<void> deleteBudget(String id) async {
    final box = await _box;
    final existing = box.get(id);
    if (existing != null) {
      final archived = BudgetModel(
        id: existing.id,
        name: existing.name,
        categoryId: existing.categoryId,
        budgetType: existing.budgetType,
        amount: existing.amount,
        currencyCode: existing.currencyCode,
        startDate: existing.startDate,
        endDate: existing.endDate,
        alertThreshold: existing.alertThreshold,
        colorHex: existing.colorHex,
        iconData: existing.iconData,
        createdAt: existing.createdAt,
        updatedAt: DateTime.now(),
        isArchived: true,
      );
      await box.put(id, archived);
    }
  }

  @override
  Future<void> clear() async {
    final box = await _box;
    await box.clear();
  }
}
