import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import '../l10n/app_localizations.dart';
import '../core/design_system/color_schemes.dart';
import '../core/design_system/tokens.dart';
import '../core/design_system/typography.dart';
import '../core/di/injection.dart';
import '../core/router/app_router.dart';
import '../features/account/presentation/cubit/account_cubit.dart';
import '../features/analytics/presentation/cubit/analytics_cubit.dart';
import '../features/app_initialization/presentation/cubit/app_initialization_cubit.dart';
import '../features/backup/presentation/cubit/backup_cubit.dart';
import '../features/budget/presentation/cubit/budget_cubit.dart';
import '../features/budget/presentation/cubit/savings_goal_cubit.dart';
import '../features/category/presentation/cubit/category_cubit.dart';
import '../features/transaction/presentation/cubit/transaction_cubit.dart';
import '../features/transaction/presentation/cubit/transaction_state.dart';
import '../features/user/presentation/cubit/user_cubit.dart';
import '../features/user/presentation/cubit/user_state.dart';

import '../core/tutorial/presentation/cubit/tutorial_cubit.dart';
import '../core/tutorial/presentation/widgets/tutorial_overlay.dart';

class FinoraApp extends StatelessWidget {
  const FinoraApp({super.key});

  Locale? _mapLocale(UserState state) {
    if (state is UserLoaded && state.user != null) {
      final lang = state.user!.preferredLanguage.toLowerCase();
      if (lang.isNotEmpty) {
        return Locale(lang);
      }
    }
    return null;
  }

  ThemeMode _mapThemeMode(UserState state) {
    if (state is UserLoaded && state.user != null) {
      switch (state.user!.themeMode.toLowerCase()) {
        case 'light':
          return ThemeMode.light;
        case 'dark':
          return ThemeMode.dark;
        case 'system':
        default:
          return ThemeMode.system;
      }
    }
    return ThemeMode.system;
  }

  ThemeData _buildTheme(ColorScheme colorScheme, AppSemanticColors semanticColors) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: FinoraTypography.textTheme,
      extensions: [semanticColors],
      scaffoldBackgroundColor: colorScheme.surface,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 1.0,
      ),
      cardTheme: CardThemeData(
        elevation: 1.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(FinoraTokens.borderRadiusMedium),
        ),
        clipBehavior: Clip.antiAlias,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(FinoraTokens.borderRadiusMedium),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(FinoraTokens.borderRadiusMedium),
          borderSide: BorderSide(color: colorScheme.outline.withValues(alpha: 0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(FinoraTokens.borderRadiusMedium),
          borderSide: BorderSide(color: colorScheme.primary, width: 2.0),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 1.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(FinoraTokens.borderRadiusMedium),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(FinoraTokens.borderRadiusMedium),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(FinoraTokens.borderRadiusSmall),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        ),
      ),
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(FinoraTokens.borderRadiusLarge),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(FinoraTokens.borderRadiusLarge),
          ),
        ),
        clipBehavior: Clip.antiAlias,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(FinoraTokens.borderRadiusSmall),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        indicatorColor: colorScheme.primaryContainer,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppInitializationCubit>(
          create: (context) => getIt<AppInitializationCubit>(),
        ),
        BlocProvider<UserCubit>(
          create: (context) => getIt<UserCubit>()..loadUser(),
        ),
        BlocProvider<TransactionCubit>(
          create: (context) => getIt<TransactionCubit>()..loadTransactions(),
        ),
        BlocProvider<AnalyticsCubit>(
          create: (context) => getIt<AnalyticsCubit>(),
        ),
        BlocProvider<BudgetCubit>(
          create: (context) => getIt<BudgetCubit>()..loadBudgets(),
        ),
        BlocProvider<SavingsGoalCubit>(
          create: (context) => getIt<SavingsGoalCubit>()..loadGoals(),
        ),
        BlocProvider<AccountCubit>(
          create: (context) => getIt<AccountCubit>()..loadAccounts(),
        ),
        BlocProvider<CategoryCubit>(
          create: (context) => getIt<CategoryCubit>()..loadCategories(),
        ),
        BlocProvider<BackupCubit>(create: (context) => getIt<BackupCubit>()),
        BlocProvider<TutorialCubit>(create: (context) => getIt<TutorialCubit>()),
      ],
      child: BlocBuilder<UserCubit, UserState>(
        builder: (context, userState) {
          final currency = (userState is UserLoaded && userState.user != null)
              ? userState.user!.preferredCurrencyCode
              : 'USD';

          return ScreenUtilPlusInit(
            designSize: const Size(360, 690),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (context, child) {
              return BlocListener<TransactionCubit, TransactionState>(
                listenWhen: (previous, current) {
                  return previous.allTransactions != current.allTransactions;
                },
                listener: (context, state) {
                  context.read<AccountCubit>().loadAccounts();
                  context.read<BudgetCubit>().loadBudgets();
                  context.read<SavingsGoalCubit>().loadGoals();
                  context.read<AnalyticsCubit>().computeAnalytics(
                    state.allTransactions,
                    currencyCode: currency,
                  );
                },
                child: MaterialApp.router(
                  title: 'Finora',
                  debugShowCheckedModeBanner: false,
                  routerConfig: AppRouter.router,
                  builder: (context, child) {
                    return TutorialOverlay(child: child ?? const SizedBox.shrink());
                  },

                  // Theme settings
                  theme: _buildTheme(FinoraColorSchemes.light, AppSemanticColors.light),
                  darkTheme: _buildTheme(FinoraColorSchemes.dark, AppSemanticColors.dark),
                  themeMode: _mapThemeMode(userState),
                  locale: _mapLocale(userState),

                  // Localization delegates
                  localizationsDelegates: const [
                    AppLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  supportedLocales: AppLocalizations.supportedLocales,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
