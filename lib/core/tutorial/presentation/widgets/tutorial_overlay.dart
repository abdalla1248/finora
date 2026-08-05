import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/design_system/tokens.dart';
import '../cubit/tutorial_cubit.dart';
import '../cubit/tutorial_state.dart';

class TutorialOverlay extends StatelessWidget {
  final Widget child;

  const TutorialOverlay({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TutorialCubit, TutorialState>(
      builder: (context, state) {
        return Stack(
          children: [
            child,
            if (state.isActive && state.currentStep != null)
              _SpotlightOverlay(step: state.currentStep!),
          ],
        );
      },
    );
  }
}

class _SpotlightOverlay extends StatefulWidget {
  final dynamic step;

  const _SpotlightOverlay({required this.step});

  @override
  State<_SpotlightOverlay> createState() => _SpotlightOverlayState();
}

class _SpotlightOverlayState extends State<_SpotlightOverlay> {
  Rect? _targetRect;

  @override
  void initState() {
    super.initState();
    _calculateRect();
  }

  @override
  void didUpdateWidget(covariant _SpotlightOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    _calculateRect();
  }

  void _calculateRect() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final key = widget.step.targetKey as GlobalKey;
      final renderBox =
          key.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null && renderBox.hasSize) {
        final position = renderBox.localToGlobal(Offset.zero);
        final size = renderBox.size;
        setState(() {
          _targetRect = position & size;
        });
      } else {
        setState(() {
          _targetRect = null;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final cubit = context.read<TutorialCubit>();
    final state = cubit.state;

    final targetRect = _targetRect ??
        Rect.fromLTWH(
          MediaQuery.of(context).size.width / 4,
          MediaQuery.of(context).size.height / 3,
          MediaQuery.of(context).size.width / 2,
          100,
        );

    final showCardAbove = targetRect.bottom > MediaQuery.of(context).size.height * 0.6;

    return Directionality(
      textDirection: Localizations.localeOf(context).languageCode == 'ar'
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Stack(
        children: [
          // Background dimming painter
          CustomPaint(
            size: Size.infinite,
            painter: _SpotlightPainter(
              targetRect: targetRect,
              overlayColor: Colors.black.withValues(alpha: 0.75),
            ),
          ),

          // Interactive Card positioned around spotlight
          Positioned(
            left: 24.0,
            right: 24.0,
            top: showCardAbove ? (targetRect.top - 200.0).clamp(40.0, MediaQuery.of(context).size.height - 250.0) : (targetRect.bottom + 16.0),
            child: Card(
              elevation: 8.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(FinoraTokens.borderRadiusLarge),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${state.currentStepIndex + 1}/${state.steps.length}',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, size: 20.0),
                          onPressed: () => cubit.skipTutorial(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      widget.step.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      widget.step.description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (state.currentStepIndex > 0)
                          TextButton(
                            onPressed: () => cubit.previousStep(),
                            child: Text(l10n.tutorialPrev),
                          )
                        else
                          TextButton(
                            onPressed: () => cubit.skipTutorial(),
                            child: Text(l10n.tutorialSkip),
                          ),
                        ElevatedButton(
                          onPressed: () => cubit.nextStep(),
                          child: Text(state.isLastStep ? l10n.tutorialFinish : l10n.tutorialNext),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SpotlightPainter extends CustomPainter {
  final Rect targetRect;
  final Color overlayColor;

  _SpotlightPainter({
    required this.targetRect,
    required this.overlayColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    final inflatedRect = targetRect.inflate(8.0);
    final targetPath = Path()
      ..addRRect(RRect.fromRectAndRadius(inflatedRect, const Radius.circular(12.0)));

    final combinedPath = Path.combine(
      PathOperation.difference,
      backgroundPath,
      targetPath,
    );

    final paint = Paint()
      ..color = overlayColor
      ..style = PaintingStyle.fill;

    canvas.drawPath(combinedPath, paint);

    // Glowing border around target
    final borderPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawRRect(RRect.fromRectAndRadius(inflatedRect, const Radius.circular(12.0)), borderPaint);
  }

  @override
  bool shouldRepaint(covariant _SpotlightPainter oldDelegate) {
    return oldDelegate.targetRect != targetRect ||
        oldDelegate.overlayColor != overlayColor;
  }
}
