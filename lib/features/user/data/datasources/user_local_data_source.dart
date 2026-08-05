import 'package:hive/hive.dart';
import '../../../../core/storage/storage_service.dart';
import '../models/user_model.dart';

abstract class UserLocalDataSource {
  Future<UserModel?> getUser();
  Future<void> saveUser(UserModel user);
  Future<void> clear();
}

class UserLocalDataSourceImpl implements UserLocalDataSource {
  final StorageService _storageService;
  static const String _userKey = 'current_user';

  UserLocalDataSourceImpl(this._storageService);

  Future<Box<UserModel>> get _box async =>
      await _storageService.openEncryptedBox<UserModel>(HiveBoxNames.user);

  @override
  Future<UserModel?> getUser() async {
    final box = await _box;
    return box.get(_userKey);
  }

  @override
  Future<void> saveUser(UserModel user) async {
    final box = await _box;
    await box.put(_userKey, user);
  }

  @override
  Future<void> clear() async {
    final box = await _box;
    await box.clear();
  }
}
