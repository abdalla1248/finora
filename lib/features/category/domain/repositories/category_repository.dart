import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/custom_category.dart';

abstract class CategoryRepository {
  Future<Either<Failure, List<CustomCategory>>> getCategories();
  Future<Either<Failure, void>> saveCategory(CustomCategory category);
  Future<Either<Failure, void>> deleteCategory(String id);
}
