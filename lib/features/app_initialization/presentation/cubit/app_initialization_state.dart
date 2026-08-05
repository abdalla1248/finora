import 'package:equatable/equatable.dart';
import '../../../user/domain/entities/user.dart';

abstract class AppInitializationState extends Equatable {
  const AppInitializationState();

  @override
  List<Object?> get props => [];
}

class AppInitializationInitial extends AppInitializationState {
  const AppInitializationInitial();
}

class AppInitializationLoading extends AppInitializationState {
  const AppInitializationLoading();
}

class AppInitializationOnboardingRequired extends AppInitializationState {
  const AppInitializationOnboardingRequired();
}

class AppInitializationCompleted extends AppInitializationState {
  final User user;

  const AppInitializationCompleted(this.user);

  @override
  List<Object?> get props => [user];
}

class AppInitializationError extends AppInitializationState {
  final String message;

  const AppInitializationError(this.message);

  @override
  List<Object?> get props => [message];
}
