import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasources/tutorial_local_data_source.dart';
import '../../domain/entities/tutorial_step.dart';
import 'tutorial_state.dart';

class TutorialCubit extends Cubit<TutorialState> {
  final TutorialLocalDataSource _localDataSource;

  TutorialCubit(this._localDataSource) : super(const TutorialState());

  Future<void> startTutorial({
    required String tutorialId,
    required List<TutorialStep> steps,
    bool forceReplay = false,
  }) async {
    if (!forceReplay) {
      final isCompleted = await _localDataSource.isTutorialCompleted(tutorialId);
      if (isCompleted) return;
    }

    if (steps.isEmpty) return;

    emit(
      TutorialState(
        isActive: true,
        activeTutorialId: tutorialId,
        steps: steps,
        currentStepIndex: 0,
      ),
    );
  }

  void nextStep() {
    if (!state.isActive) return;
    if (state.isLastStep) {
      finishTutorial();
    } else {
      emit(state.copyWith(currentStepIndex: state.currentStepIndex + 1));
    }
  }

  void previousStep() {
    if (!state.isActive) return;
    if (state.currentStepIndex > 0) {
      emit(state.copyWith(currentStepIndex: state.currentStepIndex - 1));
    }
  }

  Future<void> skipTutorial() async {
    if (state.activeTutorialId != null) {
      await _localDataSource.markTutorialCompleted(state.activeTutorialId!);
    }
    emit(const TutorialState(isActive: false));
  }

  Future<void> finishTutorial() async {
    if (state.activeTutorialId != null) {
      await _localDataSource.markTutorialCompleted(state.activeTutorialId!);
    }
    emit(const TutorialState(isActive: false));
  }

  Future<void> resetAllProgress() async {
    await _localDataSource.resetAllTutorials();
    emit(const TutorialState(isActive: false));
  }
}
