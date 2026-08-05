import 'package:equatable/equatable.dart';
import '../../domain/entities/tutorial_step.dart';

class TutorialState extends Equatable {
  final bool isActive;
  final String? activeTutorialId;
  final List<TutorialStep> steps;
  final int currentStepIndex;

  const TutorialState({
    this.isActive = false,
    this.activeTutorialId,
    this.steps = const [],
    this.currentStepIndex = 0,
  });

  TutorialStep? get currentStep =>
      steps.isNotEmpty && currentStepIndex < steps.length
          ? steps[currentStepIndex]
          : null;

  bool get isLastStep =>
      steps.isNotEmpty && currentStepIndex == steps.length - 1;

  TutorialState copyWith({
    bool? isActive,
    String? activeTutorialId,
    List<TutorialStep>? steps,
    int? currentStepIndex,
  }) {
    return TutorialState(
      isActive: isActive ?? this.isActive,
      activeTutorialId: activeTutorialId ?? this.activeTutorialId,
      steps: steps ?? this.steps,
      currentStepIndex: currentStepIndex ?? this.currentStepIndex,
    );
  }

  @override
  List<Object?> get props => [
        isActive,
        activeTutorialId,
        steps,
        currentStepIndex,
      ];
}
