import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:finora/app/app.dart';
import 'package:finora/core/tutorial/presentation/cubit/tutorial_cubit.dart';
import 'package:finora/core/tutorial/presentation/cubit/tutorial_state.dart';
import 'package:finora/features/account/presentation/cubit/account_cubit.dart';
import 'package:finora/features/account/presentation/cubit/account_state.dart';
import 'package:finora/features/analytics/presentation/cubit/analytics_cubit.dart';
import 'package:finora/features/analytics/presentation/cubit/analytics_state.dart';
import 'package:finora/features/app_initialization/presentation/cubit/app_initialization_cubit.dart';
import 'package:finora/features/app_initialization/presentation/cubit/app_initialization_state.dart';
import 'package:finora/features/backup/presentation/cubit/backup_cubit.dart';
import 'package:finora/features/backup/presentation/cubit/backup_state.dart';
import 'package:finora/features/budget/presentation/cubit/budget_cubit.dart';
import 'package:finora/features/budget/presentation/cubit/budget_state.dart';
import 'package:finora/features/budget/presentation/cubit/savings_goal_cubit.dart';
import 'package:finora/features/budget/presentation/cubit/savings_goal_state.dart';
import 'package:finora/features/category/presentation/cubit/category_cubit.dart';
import 'package:finora/features/category/presentation/cubit/category_state.dart';
import 'package:finora/features/transaction/presentation/cubit/transaction_cubit.dart';
import 'package:finora/features/transaction/presentation/cubit/transaction_state.dart';
import 'package:finora/features/user/presentation/cubit/user_cubit.dart';
import 'package:finora/features/user/presentation/cubit/user_state.dart';

class MockAppInitializationCubit extends Mock
    implements AppInitializationCubit {}

class MockUserCubit extends Mock implements UserCubit {}

class MockTransactionCubit extends Mock implements TransactionCubit {}

class MockAnalyticsCubit extends Mock implements AnalyticsCubit {}

class MockBudgetCubit extends Mock implements BudgetCubit {}

class MockSavingsGoalCubit extends Mock implements SavingsGoalCubit {}

class MockAccountCubit extends Mock implements AccountCubit {}

class MockCategoryCubit extends Mock implements CategoryCubit {}

class MockBackupCubit extends Mock implements BackupCubit {}

class MockTutorialCubit extends Mock implements TutorialCubit {}

void main() {
  setUpAll(() {
    final getIt = GetIt.instance;

    final mockInitCubit = MockAppInitializationCubit();
    when(() => mockInitCubit.state).thenReturn(const AppInitializationInitial());
    when(() => mockInitCubit.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockInitCubit.initialize()).thenAnswer((_) async {});
    when(() => mockInitCubit.close()).thenAnswer((_) async {});
    getIt.registerSingleton<AppInitializationCubit>(mockInitCubit);

    final mockUserCubit = MockUserCubit();
    when(() => mockUserCubit.state).thenReturn(const UserInitial());
    when(() => mockUserCubit.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockUserCubit.loadUser()).thenAnswer((_) async {});
    when(() => mockUserCubit.close()).thenAnswer((_) async {});
    getIt.registerSingleton<UserCubit>(mockUserCubit);

    final mockTxCubit = MockTransactionCubit();
    when(() => mockTxCubit.state).thenReturn(const TransactionState());
    when(() => mockTxCubit.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockTxCubit.loadTransactions()).thenAnswer((_) async {});
    when(() => mockTxCubit.close()).thenAnswer((_) async {});
    getIt.registerSingleton<TransactionCubit>(mockTxCubit);

    final mockAnalyticsCubit = MockAnalyticsCubit();
    when(() => mockAnalyticsCubit.state).thenReturn(const AnalyticsState());
    when(() => mockAnalyticsCubit.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockAnalyticsCubit.close()).thenAnswer((_) async {});
    getIt.registerSingleton<AnalyticsCubit>(mockAnalyticsCubit);

    final mockBudgetCubit = MockBudgetCubit();
    when(() => mockBudgetCubit.state).thenReturn(const BudgetState());
    when(() => mockBudgetCubit.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockBudgetCubit.loadBudgets()).thenAnswer((_) async {});
    when(() => mockBudgetCubit.close()).thenAnswer((_) async {});
    getIt.registerSingleton<BudgetCubit>(mockBudgetCubit);

    final mockSavingsGoalCubit = MockSavingsGoalCubit();
    when(() => mockSavingsGoalCubit.state).thenReturn(const SavingsGoalState());
    when(() => mockSavingsGoalCubit.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockSavingsGoalCubit.loadGoals()).thenAnswer((_) async {});
    when(() => mockSavingsGoalCubit.close()).thenAnswer((_) async {});
    getIt.registerSingleton<SavingsGoalCubit>(mockSavingsGoalCubit);

    final mockAccountCubit = MockAccountCubit();
    when(() => mockAccountCubit.state).thenReturn(const AccountState());
    when(() => mockAccountCubit.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockAccountCubit.loadAccounts()).thenAnswer((_) async {});
    when(() => mockAccountCubit.close()).thenAnswer((_) async {});
    getIt.registerSingleton<AccountCubit>(mockAccountCubit);

    final mockCategoryCubit = MockCategoryCubit();
    when(() => mockCategoryCubit.state).thenReturn(const CategoryState());
    when(() => mockCategoryCubit.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockCategoryCubit.loadCategories()).thenAnswer((_) async {});
    when(() => mockCategoryCubit.close()).thenAnswer((_) async {});
    getIt.registerSingleton<CategoryCubit>(mockCategoryCubit);

    final mockBackupCubit = MockBackupCubit();
    when(() => mockBackupCubit.state).thenReturn(const BackupState());
    when(() => mockBackupCubit.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockBackupCubit.close()).thenAnswer((_) async {});
    getIt.registerSingleton<BackupCubit>(mockBackupCubit);

    final mockTutorialCubit = MockTutorialCubit();
    when(() => mockTutorialCubit.state).thenReturn(const TutorialState());
    when(() => mockTutorialCubit.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockTutorialCubit.close()).thenAnswer((_) async {});
    getIt.registerSingleton<TutorialCubit>(mockTutorialCubit);
  });

  testWidgets('App starts and renders splash screen branding successfully', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const FinoraApp());
    expect(find.text('Finora'), findsWidgets);
  });
}
