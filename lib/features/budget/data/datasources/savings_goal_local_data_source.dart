import 'package:hive/hive.dart';
import '../../../../core/storage/storage_service.dart';
import '../models/savings_goal_model.dart';

abstract class SavingsGoalLocalDataSource {
  Future<List<SavingsGoalModel>> getGoals();
  Future<void> saveGoal(SavingsGoalModel model);
  Future<void> deleteGoal(String id);
  Future<void> clear();
}

class SavingsGoalLocalDataSourceImpl implements SavingsGoalLocalDataSource {
  final StorageService _storageService;

  SavingsGoalLocalDataSourceImpl(this._storageService);

  Future<Box<SavingsGoalModel>> get _box async =>
      await _storageService.openEncryptedBox<SavingsGoalModel>('goals_box');

  @override
  Future<List<SavingsGoalModel>> getGoals() async {
    final box = await _box;
    return box.values.toList();
  }

  @override
  Future<void> saveGoal(SavingsGoalModel model) async {
    final box = await _box;
    await box.put(model.id, model);
  }

  @override
  Future<void> deleteGoal(String id) async {
    final box = await _box;
    await box.delete(id);
  }

  @override
  Future<void> clear() async {
    final box = await _box;
    await box.clear();
  }
}
