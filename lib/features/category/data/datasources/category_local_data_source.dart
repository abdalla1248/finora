import 'package:hive/hive.dart';
import '../../../../core/storage/storage_service.dart';
import '../models/custom_category_model.dart';

abstract class CategoryLocalDataSource {
  Future<List<CustomCategoryModel>> getCategories();
  Future<void> saveCategory(CustomCategoryModel model);
  Future<void> deleteCategory(String id);
  Future<void> clear();
}

class CategoryLocalDataSourceImpl implements CategoryLocalDataSource {
  final StorageService _storageService;

  CategoryLocalDataSourceImpl(this._storageService);

  Future<Box<CustomCategoryModel>> get _box async => await _storageService
      .openEncryptedBox<CustomCategoryModel>('custom_categories_box');

  @override
  Future<List<CustomCategoryModel>> getCategories() async {
    final box = await _box;
    return box.values.where((c) => !c.isArchived).toList();
  }

  @override
  Future<void> saveCategory(CustomCategoryModel model) async {
    final box = await _box;
    await box.put(model.id, model);
  }

  @override
  Future<void> deleteCategory(String id) async {
    final box = await _box;
    await box.delete(id);
  }

  @override
  Future<void> clear() async {
    final box = await _box;
    await box.clear();
  }
}
