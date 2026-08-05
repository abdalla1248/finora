import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../user/domain/repositories/user_repository.dart';
import 'app_initialization_state.dart';

class AppInitializationCubit extends Cubit<AppInitializationState> {
  final UserRepository _userRepository;

  AppInitializationCubit(this._userRepository)
    : super(const AppInitializationInitial());

  Future<void> initialize() async {
    emit(const AppInitializationLoading());

    final result = await _userRepository.getUser();
    result.fold((failure) => emit(AppInitializationError(failure.message)), (
      user,
    ) async {
      if (user == null || !user.onboardingCompleted) {
        emit(const AppInitializationOnboardingRequired());
      } else {
        final updatedUser = user.copyWith(lastOpenedAt: DateTime.now());
        await _userRepository.saveUser(updatedUser);
        emit(AppInitializationCompleted(updatedUser));
      }
    });
  }
}
