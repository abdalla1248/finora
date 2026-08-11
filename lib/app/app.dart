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
      tabBarTheme: TabBarThemeData(
        dividerColor: Colors.transparent,
        dividerHeight: 0.0,
        indicatorSize: TabBarIndicatorSize.label,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: colorScheme.primary, width: 3.0),
        ),
        labelColor: colorScheme.primary,
        unselectedLabelColor: colorScheme.onSurfaceVariant,
      ),
      cardTheme: CardThemeData(
        color: colorScheme.surfaceContainer,
        elevation: 2.0,
        shadowColor: colorScheme.shadow.withValues(alpha: 0.08),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(FinoraTokens.borderRadiusMedium),
          side: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.12),
            width: 1.0,
          ),
        ),
        clipBehavior: Clip.antiAlias,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.15),
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
        labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
        hintStyle: TextStyle(color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.surfaceContainerLow,
          foregroundColor: colorScheme.primary,
          elevation: 1.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(FinoraTokens.borderRadiusMedium),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(FinoraTokens.borderRadiusMedium),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          side: BorderSide(color: colorScheme.outline),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(FinoraTokens.borderRadiusMedium),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(FinoraTokens.borderRadiusSmall),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 3.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(FinoraTokens.borderRadiusMedium),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: colorScheme.primary,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        indicatorColor: colorScheme.primaryContainer,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: colorScheme.onPrimaryContainer);
          }
          return IconThemeData(color: colorScheme.onSurfaceVariant);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return TextStyle(
               color: colorScheme.onSurface,
               fontWeight: FontWeight.bold,
               fontSize: 12,
            );
          }
          return TextStyle(
            color: colorScheme.onSurfaceVariant,
            fontSize: 12,
          );
        }),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colorScheme.surfaceContainer,
        modalBackgroundColor: colorScheme.surfaceContainer,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(FinoraTokens.borderRadiusLarge),
          ),
        ),
        clipBehavior: Clip.antiAlias,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: colorScheme.surfaceContainer,
        elevation: 6.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(FinoraTokens.borderRadiusLarge),
        ),
        titleTextStyle: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        contentTextStyle: TextStyle(
          color: colorScheme.onSurfaceVariant,
          fontSize: 16,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(FinoraTokens.borderRadiusSmall),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.surfaceContainer,
        disabledColor: colorScheme.onSurface.withValues(alpha: 0.08),
        selectedColor: colorScheme.primaryContainer,
        secondarySelectedColor: colorScheme.primaryContainer,
        labelStyle: TextStyle(color: colorScheme.onSurface),
        secondaryLabelStyle: TextStyle(color: colorScheme.onPrimaryContainer),
        brightness: colorScheme.brightness,
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(FinoraTokens.borderRadiusSmall),
          side: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.2),
            width: 1.0,
          ),
        ),
      ),
      listTileTheme: ListTileThemeData(
        textColor: colorScheme.onSurface,
        iconColor: colorScheme.onSurfaceVariant,
        selectedColor: colorScheme.primary,
        selectedTileColor: colorScheme.primaryContainer.withValues(alpha: 0.15),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(FinoraTokens.borderRadiusMedium),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.onPrimary;
          }
          return colorScheme.outline;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return colorScheme.surfaceContainerHighest;
        }),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(colorScheme.onPrimary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return colorScheme.onSurfaceVariant;
        }),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: colorScheme.primary,
        inactiveTrackColor: colorScheme.primaryContainer.withValues(alpha: 0.24),
        thumbColor: colorScheme.primary,
        overlayColor: colorScheme.primary.withValues(alpha: 0.12),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colorScheme.primary,
        linearTrackColor: colorScheme.primaryContainer.withValues(alpha: 0.2),
        circularTrackColor: colorScheme.primaryContainer.withValues(alpha: 0.2),
      ),
      dividerTheme: DividerThemeData(
        color: colorScheme.outline.withValues(alpha: 0.2),
        space: 1.0,
        thickness: 1.0,
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
