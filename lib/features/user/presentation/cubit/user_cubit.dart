import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UserRepository _userRepository;

  UserCubit(this._userRepository) : super(const UserInitial());

  Future<void> loadUser() async {
    emit(const UserLoading());
    final result = await _userRepository.getUser();
    result.fold(
      (failure) => emit(UserError(failure.message)),
      (user) => emit(UserLoaded(user)),
    );
  }

  Future<void> createUser({
    required String name,
    required String preferredCurrencyCode,
    required String preferredLanguage,
    required String themeMode,
  }) async {
    emit(const UserLoading());
    final now = DateTime.now();
    final newUser = User(
      id: now.millisecondsSinceEpoch.toString(),
      name: name,
      preferredCurrencyCode: preferredCurrencyCode,
      preferredLanguage: preferredLanguage,
      themeMode: themeMode,
      onboardingCompleted: true,
      createdAt: now,
      lastOpenedAt: now,
    );

    final result = await _userRepository.saveUser(newUser);
    result.fold(
      (failure) => emit(UserError(failure.message)),
      (_) => emit(UserLoaded(newUser)),
    );
  }

  Future<void> updateUser(User user) async {
    emit(const UserLoading());
    final updatedUser = user.copyWith(lastOpenedAt: DateTime.now());
    final result = await _userRepository.saveUser(updatedUser);
    result.fold(
      (failure) => emit(UserError(failure.message)),
      (_) => emit(UserLoaded(updatedUser)),
    );
  }

  Future<void> updateProfilePhoto(String? path) async {
    if (state is UserLoaded && (state as UserLoaded).user != null) {
      final user = (state as UserLoaded).user!;
      final updated = path == null
          ? user.copyWith(clearProfileImage: true)
          : user.copyWith(profileImagePath: path);
      await updateUser(updated);
    }
  }

  Future<void> updateName(String name) async {
    if (state is UserLoaded && (state as UserLoaded).user != null) {
      final user = (state as UserLoaded).user!;
      await updateUser(user.copyWith(name: name));
    }
  }

  Future<void> updateCurrency(String code) async {
    if (state is UserLoaded && (state as UserLoaded).user != null) {
      final user = (state as UserLoaded).user!;
      await updateUser(user.copyWith(preferredCurrencyCode: code));
    }
  }

  Future<void> updateLanguage(String lang) async {
    if (state is UserLoaded && (state as UserLoaded).user != null) {
      final user = (state as UserLoaded).user!;
      await updateUser(user.copyWith(preferredLanguage: lang));
    }
  }

  Future<void> clearUser() async {
    emit(const UserLoading());
    final result = await _userRepository.clearUser();
    result.fold(
      (failure) => emit(UserError(failure.message)),
      (_) => emit(const UserLoaded(null)),
    );
  }
}
