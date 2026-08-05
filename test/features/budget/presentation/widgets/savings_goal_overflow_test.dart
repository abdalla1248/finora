import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:mocktail/mocktail.dart';
import 'package:finora/l10n/app_localizations.dart';
import 'package:finora/features/budget/domain/entities/savings_goal.dart';
import 'package:finora/features/budget/presentation/widgets/goal_progress_card.dart';
import 'package:finora/features/budget/presentation/cubit/savings_goal_cubit.dart';
import 'package:finora/features/budget/presentation/cubit/savings_goal_state.dart';

class MockSavingsGoalCubit extends Mock implements SavingsGoalCubit {}

void main() {
  late MockSavingsGoalCubit mockSavingsGoalCubit;

  setUp(() {
    mockSavingsGoalCubit = MockSavingsGoalCubit();
    when(() => mockSavingsGoalCubit.state).thenReturn(const SavingsGoalState());
    when(() => mockSavingsGoalCubit.stream).thenAnswer((_) => const Stream.empty());
  });

  Widget buildTestableWidget(SavingsGoal goal) {
    return BlocProvider<SavingsGoalCubit>.value(
      value: mockSavingsGoalCubit,
      child: ScreenUtilPlusInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: const Locale('en'),
            home: Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GoalProgressCard(
                  goal: goal,
                  currency: '\$',
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  testWidgets('renders GoalProgressCard on a narrow viewport without RenderFlex overflow', (WidgetTester tester) async {
    // Set extremely small phone resolution (e.g. 320x480)
    tester.view.physicalSize = const Size(320, 480);
    tester.view.devicePixelRatio = 1.0;

    final goal = SavingsGoal(
      id: 'test_goal_1',
      title: 'Extremely Long Goal Name That Might Take Multiple Lines Or Wrap',
      targetAmount: 1000000.0,
      currentAmount: 250000.0,
      deadline: DateTime.now().add(const Duration(days: 5)),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await tester.pumpWidget(buildTestableWidget(goal));
    await tester.pumpAndSettle();

    // Verify no exception was thrown during rendering (overflow errors print to console or cause failure)
    expect(tester.takeException(), isNull);
    expect(find.textContaining('Saved:'), findsOneWidget);
    expect(find.textContaining('Remaining:'), findsOneWidget);
    expect(find.textContaining('Target:'), findsOneWidget);

    // Reset view size
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  });
}
