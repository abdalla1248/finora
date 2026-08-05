import 'package:hive/hive.dart';
import '../../../../core/storage/storage_service.dart';
import '../models/account_model.dart';

abstract class AccountLocalDataSource {
  Future<List<AccountModel>> getAccounts();
  Future<void> saveAccount(AccountModel model);
  Future<void> deleteAccount(String id);
  Future<void> clear();
}

class AccountLocalDataSourceImpl implements AccountLocalDataSource {
  final StorageService _storageService;

  AccountLocalDataSourceImpl(this._storageService);

  Future<Box<AccountModel>> get _box async =>
      await _storageService.openEncryptedBox<AccountModel>('accounts_box');

  @override
  Future<List<AccountModel>> getAccounts() async {
    final box = await _box;
    return box.values.where((a) => !a.isArchived).toList();
  }

  @override
  Future<void> saveAccount(AccountModel model) async {
    final box = await _box;
    await box.put(model.id, model);
  }

  @override
  Future<void> deleteAccount(String id) async {
    final box = await _box;
    await box.delete(id);
  }

  @override
  Future<void> clear() async {
    final box = await _box;
    await box.clear();
  }
}
