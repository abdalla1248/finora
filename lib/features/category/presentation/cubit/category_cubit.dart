import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/custom_category.dart';
import '../../domain/repositories/category_repository.dart';
import 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final CategoryRepository _categoryRepository;

  CategoryCubit(this._categoryRepository) : super(const CategoryState());

  Future<void> loadCategories() async {
    emit(state.copyWith(isLoading: true));
    final result = await _categoryRepository.getCategories();
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (categories) =>
          emit(state.copyWith(categories: categories, isLoading: false)),
    );
  }

  Future<void> addCategory(CustomCategory category) async {
    emit(state.copyWith(isLoading: true));
    final result = await _categoryRepository.saveCategory(category);
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (_) => loadCategories(),
    );
  }

  Future<void> deleteCategory(String id) async {
    emit(state.copyWith(isLoading: true));
    final result = await _categoryRepository.deleteCategory(id);
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (_) => loadCategories(),
    );
  }
}
