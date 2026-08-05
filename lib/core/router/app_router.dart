import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../features/account/presentation/cubit/account_cubit.dart';
import '../../features/account/presentation/screens/account_management_screen.dart';
import '../../features/account/presentation/screens/add_edit_account_screen.dart';
import '../../features/analytics/presentation/screens/analytics_screen.dart';
import '../../features/app_initialization/presentation/screens/splash_screen.dart';
import '../../features/backup/presentation/screens/backup_export_screen.dart';
import '../../features/budget/presentation/cubit/budget_cubit.dart';
import '../../features/budget/presentation/cubit/savings_goal_cubit.dart';
import '../../features/budget/presentation/screens/add_edit_budget_screen.dart';
import '../../features/budget/presentation/screens/add_edit_goal_screen.dart';
import '../../features/budget/presentation/screens/budget_screen.dart';
import '../../features/category/presentation/cubit/category_cubit.dart';
import '../../features/category/presentation/screens/add_edit_category_screen.dart';
import '../../features/category/presentation/screens/category_management_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/shell/presentation/screens/home_shell.dart';
import '../../features/transaction/presentation/cubit/transaction_cubit.dart';
import '../../features/transaction/presentation/screens/add_edit_transaction_screen.dart';
import '../../features/transaction/presentation/screens/transaction_details_screen.dart';
import '../../features/transaction/presentation/screens/transaction_list_screen.dart';

class AppRouter {
  const AppRouter._();

  static const String root = '/';
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String budgets = '/budgets';
  static const String analytics = '/analytics';
  static const String settings = '/settings';
  static const String addTransaction = '/transactions/add';
  static const String editTransaction = '/transactions/edit/:id';
  static const String transactionDetails = '/transactions/details/:id';
  static const String addBudget = '/budgets/add';
  static const String editBudget = '/budgets/edit/:id';
  static const String addGoal = '/goals/add';
  static const String editGoal = '/goals/edit/:id';
  static const String accounts = '/accounts';
  static const String addAccount = '/accounts/add';
  static const String editAccount = '/accounts/edit/:id';
  static const String categories = '/categories';
  static const String addCategory = '/categories/add';
  static const String editCategory = '/categories/edit/:id';
  static const String backup = '/backup';
  static const String transactions = '/transactions';

  static CustomTransitionPage<void> _buildPageWithTransition({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 250),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curveAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOutCubic,
        );

        final slideAnimation = Tween<Offset>(
          begin: const Offset(0.12, 0.0),
          end: Offset.zero,
        ).animate(curveAnimation);

        final fadeAnimation = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(curveAnimation);

        return SlideTransition(
          position: slideAnimation,
          child: FadeTransition(
            opacity: fadeAnimation,
            child: child,
          ),
        );
      },
    );
  }

  static final GoRouter router = GoRouter(
    initialLocation: root,
    errorBuilder: (context, state) =>
        const Scaffold(body: Center(child: Text('Page Not Found'))),
    routes: [
      GoRoute(path: root, builder: (context, state) => const SplashScreen()),
      GoRoute(
        path: onboarding,
        pageBuilder: (context, state) => _buildPageWithTransition(
          context: context,
          state: state,
          child: const OnboardingScreen(),
        ),
      ),
      GoRoute(
        path: addTransaction,
        pageBuilder: (context, state) => _buildPageWithTransition(
          context: context,
          state: state,
          child: const AddEditTransactionScreen(),
        ),
      ),
      GoRoute(
        path: editTransaction,
        pageBuilder: (context, state) {
          final id = state.pathParameters['id']!;
          final txs = context.read<TransactionCubit>().state.allTransactions;
          final matches = txs.where((t) => t.id == id);
          return _buildPageWithTransition(
            context: context,
            state: state,
            child: AddEditTransactionScreen(
              initialTransaction: matches.isNotEmpty ? matches.first : null,
            ),
          );
        },
      ),
      GoRoute(
        path: transactionDetails,
        pageBuilder: (context, state) {
          final id = state.pathParameters['id']!;
          return _buildPageWithTransition(
            context: context,
            state: state,
            child: TransactionDetailsScreen(transactionId: id),
          );
        },
      ),
      GoRoute(
        path: addBudget,
        pageBuilder: (context, state) => _buildPageWithTransition(
          context: context,
          state: state,
          child: const AddEditBudgetScreen(),
        ),
      ),
      GoRoute(
        path: editBudget,
        pageBuilder: (context, state) {
          final id = state.pathParameters['id']!;
          final budgetList = context.read<BudgetCubit>().state.budgets;
          final matches = budgetList.where((b) => b.id == id);
          return _buildPageWithTransition(
            context: context,
            state: state,
            child: AddEditBudgetScreen(
              initialBudget: matches.isNotEmpty ? matches.first : null,
            ),
          );
        },
      ),
      GoRoute(
        path: addGoal,
        pageBuilder: (context, state) => _buildPageWithTransition(
          context: context,
          state: state,
          child: const AddEditGoalScreen(),
        ),
      ),
      GoRoute(
        path: editGoal,
        pageBuilder: (context, state) {
          final id = state.pathParameters['id']!;
          final goals = context.read<SavingsGoalCubit>().state.goals;
          final matches = goals.where((g) => g.id == id);
          return _buildPageWithTransition(
            context: context,
            state: state,
            child: AddEditGoalScreen(
              initialGoal: matches.isNotEmpty ? matches.first : null,
            ),
          );
        },
      ),
      GoRoute(
        path: accounts,
        pageBuilder: (context, state) => _buildPageWithTransition(
          context: context,
          state: state,
          child: const AccountManagementScreen(),
        ),
      ),
      GoRoute(
        path: addAccount,
        pageBuilder: (context, state) => _buildPageWithTransition(
          context: context,
          state: state,
          child: const AddEditAccountScreen(),
        ),
      ),
      GoRoute(
        path: editAccount,
        pageBuilder: (context, state) {
          final id = state.pathParameters['id']!;
          final accts = context.read<AccountCubit>().state.accounts;
          final matches = accts.where((a) => a.id == id);
          return _buildPageWithTransition(
            context: context,
            state: state,
            child: AddEditAccountScreen(
              initialAccount: matches.isNotEmpty ? matches.first : null,
            ),
          );
        },
      ),
      GoRoute(
        path: categories,
        pageBuilder: (context, state) => _buildPageWithTransition(
          context: context,
          state: state,
          child: const CategoryManagementScreen(),
        ),
      ),
      GoRoute(
        path: addCategory,
        pageBuilder: (context, state) => _buildPageWithTransition(
          context: context,
          state: state,
          child: const AddEditCategoryScreen(),
        ),
      ),
      GoRoute(
        path: editCategory,
        pageBuilder: (context, state) {
          final id = state.pathParameters['id']!;
          final cats = context.read<CategoryCubit>().state.categories;
          final matches = cats.where((c) => c.id == id);
          return _buildPageWithTransition(
            context: context,
            state: state,
            child: AddEditCategoryScreen(
              initialCategory: matches.isNotEmpty ? matches.first : null,
            ),
          );
        },
      ),
      GoRoute(
        path: backup,
        pageBuilder: (context, state) => _buildPageWithTransition(
          context: context,
          state: state,
          child: const BackupExportScreen(),
        ),
      ),
      GoRoute(
        path: transactions,
        pageBuilder: (context, state) => _buildPageWithTransition(
          context: context,
          state: state,
          child: const TransactionListScreen(),
        ),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return HomeShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: home,
                builder: (context, state) => const DashboardScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: budgets,
                builder: (context, state) => const BudgetScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: analytics,
                builder: (context, state) => const AnalyticsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: settings,
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
