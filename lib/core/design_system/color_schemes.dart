import 'package:flutter/material.dart';

class FinoraColorSchemes {
  const FinoraColorSchemes._();

  static Color parseHexColor(String hexColor) {
    String hex = hexColor.replaceAll('#', '');
    if (hex.startsWith('0x') || hex.startsWith('0X')) {
      hex = hex.substring(2);
    }
    if (hex.length == 6) {
      hex = 'FF$hex';
    }
    return Color(int.parse(hex, radix: 16));
  }

  static const Color primaryBlue = Color(0xFF1A5F7A);
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color backgroundDark = Color(0xFF0F172A);
  static const Color surfaceDark = Color(0xFF1E293B);

  static const Color incomeGreen = Color(0xFF10B981);
  static const Color expenseRed = Color(0xFFEF4444);
  static const Color warningAmber = Color(0xFFF59E0B);

  static const ColorScheme light = ColorScheme(
    brightness: Brightness.light,
    primary: primaryBlue,
    onPrimary: Colors.white,
    primaryContainer: Color(0xFFE2F1F8),
    onPrimaryContainer: Color(0xFF0A2532),
    secondary: Color(0xFF475569),
    onSecondary: Colors.white,
    secondaryContainer: Color(0xFFF1F5F9),
    onSecondaryContainer: Color(0xFF0F172A),
    error: expenseRed,
    onError: Colors.white,
    errorContainer: Color(0xFFFEE2E2),
    onErrorContainer: Color(0xFF7F1D1D),
    card: backgroundLight,
    surface: backgroundLight,
    onSurface: Color(0xFF0F172A),
    surfaceContainer: Colors.white,
    surfaceContainerHighest: Color.fromARGB(255, 226, 241, 248),
    onSurfaceVariant: Color(0xFF475569),
    outline: Color(0xFF94A3B8),
  );

  static const ColorScheme dark = ColorScheme(
    brightness: Brightness.dark,

    // Brand Colors
    primary: Color(0xFF4FC3F7),
    onPrimary: Color(0xFF082032),
    primaryContainer: Color(0xFF0B4A6F),
    onPrimaryContainer: Color(0xFFE0F7FA),

    secondary: Color(0xFFA5B4C3),
    onSecondary: Color(0xFF111827),
    secondaryContainer: Color(0xFF2E3E52),
    onSecondaryContainer: Color(0xFFE2E8F0),

    // Error
    error: Color(0xFFFF6B6B),
    onError: Color(0xFF2B0B0B),
    errorContainer: Color(0xFF5E1717),
    onErrorContainer: Color(0xFFFFD8D8),

    // Background & Surface
    surface: Color(0xFF151A21), // بدل الأسود
    onSurface: Color(0xFFF8FAFC),

    surfaceContainer: Color(0xFF1E2630), // الكروت
    surfaceContainerHighest: Color(0xFF2A3441),

    onSurfaceVariant: Color(0xFFCBD5E1),

    outline: Color(0xFF64748B),

    // لو عندك Extension للكارد
    card: Color(0xFF1E2630),
  );
}

class AppSemanticColors extends ThemeExtension<AppSemanticColors> {
  // General
  final Color success;
  final Color warning;
  final Color danger;
  final Color info;

  // Finance
  final Color income;
  final Color expense;
  final Color transfer;
  final Color savings;
  final Color budget;
  final Color investment;

  // Charts
  final Color chartIncome;
  final Color chartExpense;
  final Color chartSavings;
  final Color chartBudget;
  final Color chartTransfer;

  // Status
  final Color active;
  final Color inactive;
  final Color completed;
  final Color pending;
  final Color expired;

  // Cards
  final Color dashboardCard;
  final Color accountCard;
  final Color analyticsCard;
  final Color budgetCard;
  final Color goalCard;

  // Interactive
  final Color selected;
  final Color unselected;
  final Color highlighted;

  // Progress
  final Color progressGood;
  final Color progressWarning;
  final Color progressDanger;

  // Badges
  final Color positiveBadge;
  final Color negativeBadge;
  final Color neutralBadge;

  // Account Types
  final Color cashAccount;
  final Color bankAccount;
  final Color cardAccount;
  final Color savingsAccount;
  final Color digitalWalletAccount;
  final Color businessAccount;

  // Navigation
  final Color navSelected;
  final Color navUnselected;

  const AppSemanticColors({
    required this.success,
    required this.warning,
    required this.danger,
    required this.info,
    required this.income,
    required this.expense,
    required this.transfer,
    required this.savings,
    required this.budget,
    required this.investment,
    required this.chartIncome,
    required this.chartExpense,
    required this.chartSavings,
    required this.chartBudget,
    required this.chartTransfer,
    required this.active,
    required this.inactive,
    required this.completed,
    required this.pending,
    required this.expired,
    required this.dashboardCard,
    required this.accountCard,
    required this.analyticsCard,
    required this.budgetCard,
    required this.goalCard,
    required this.selected,
    required this.unselected,
    required this.highlighted,
    required this.progressGood,
    required this.progressWarning,
    required this.progressDanger,
    required this.positiveBadge,
    required this.negativeBadge,
    required this.neutralBadge,
    required this.cashAccount,
    required this.bankAccount,
    required this.cardAccount,
    required this.savingsAccount,
    required this.digitalWalletAccount,
    required this.businessAccount,
    required this.navSelected,
    required this.navUnselected,
  });

  @override
  ThemeExtension<AppSemanticColors> copyWith({
    Color? success,
    Color? warning,
    Color? danger,
    Color? info,
    Color? income,
    Color? expense,
    Color? transfer,
    Color? savings,
    Color? budget,
    Color? investment,
    Color? chartIncome,
    Color? chartExpense,
    Color? chartSavings,
    Color? chartBudget,
    Color? chartTransfer,
    Color? active,
    Color? inactive,
    Color? completed,
    Color? pending,
    Color? expired,
    Color? dashboardCard,
    Color? accountCard,
    Color? analyticsCard,
    Color? budgetCard,
    Color? goalCard,
    Color? selected,
    Color? unselected,
    Color? highlighted,
    Color? progressGood,
    Color? progressWarning,
    Color? progressDanger,
    Color? positiveBadge,
    Color? negativeBadge,
    Color? neutralBadge,
    Color? cashAccount,
    Color? bankAccount,
    Color? cardAccount,
    Color? savingsAccount,
    Color? digitalWalletAccount,
    Color? businessAccount,
    Color? navSelected,
    Color? navUnselected,
  }) {
    return AppSemanticColors(
      success: success ?? this.success,
      warning: warning ?? this.warning,
      danger: danger ?? this.danger,
      info: info ?? this.info,
      income: income ?? this.income,
      expense: expense ?? this.expense,
      transfer: transfer ?? this.transfer,
      savings: savings ?? this.savings,
      budget: budget ?? this.budget,
      investment: investment ?? this.investment,
      chartIncome: chartIncome ?? this.chartIncome,
      chartExpense: chartExpense ?? this.chartExpense,
      chartSavings: chartSavings ?? this.chartSavings,
      chartBudget: chartBudget ?? this.chartBudget,
      chartTransfer: chartTransfer ?? this.chartTransfer,
      active: active ?? this.active,
      inactive: inactive ?? this.inactive,
      completed: completed ?? this.completed,
      pending: pending ?? this.pending,
      expired: expired ?? this.expired,
      dashboardCard: dashboardCard ?? this.dashboardCard,
      accountCard: accountCard ?? this.accountCard,
      analyticsCard: analyticsCard ?? this.analyticsCard,
      budgetCard: budgetCard ?? this.budgetCard,
      goalCard: goalCard ?? this.goalCard,
      selected: selected ?? this.selected,
      unselected: unselected ?? this.unselected,
      highlighted: highlighted ?? this.highlighted,
      progressGood: progressGood ?? this.progressGood,
      progressWarning: progressWarning ?? this.progressWarning,
      progressDanger: progressDanger ?? this.progressDanger,
      positiveBadge: positiveBadge ?? this.positiveBadge,
      negativeBadge: negativeBadge ?? this.negativeBadge,
      neutralBadge: neutralBadge ?? this.neutralBadge,
      cashAccount: cashAccount ?? this.cashAccount,
      bankAccount: bankAccount ?? this.bankAccount,
      cardAccount: cardAccount ?? this.cardAccount,
      savingsAccount: savingsAccount ?? this.savingsAccount,
      digitalWalletAccount: digitalWalletAccount ?? this.digitalWalletAccount,
      businessAccount: businessAccount ?? this.businessAccount,
      navSelected: navSelected ?? this.navSelected,
      navUnselected: navUnselected ?? this.navUnselected,
    );
  }

  @override
  ThemeExtension<AppSemanticColors> lerp(
    covariant ThemeExtension<AppSemanticColors>? other,
    double t,
  ) {
    if (other is! AppSemanticColors) return this;
    return AppSemanticColors(
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      info: Color.lerp(info, other.info, t)!,
      income: Color.lerp(income, other.income, t)!,
      expense: Color.lerp(expense, other.expense, t)!,
      transfer: Color.lerp(transfer, other.transfer, t)!,
      savings: Color.lerp(savings, other.savings, t)!,
      budget: Color.lerp(budget, other.budget, t)!,
      investment: Color.lerp(investment, other.investment, t)!,
      chartIncome: Color.lerp(chartIncome, other.chartIncome, t)!,
      chartExpense: Color.lerp(chartExpense, other.chartExpense, t)!,
      chartSavings: Color.lerp(chartSavings, other.chartSavings, t)!,
      chartBudget: Color.lerp(chartBudget, other.chartBudget, t)!,
      chartTransfer: Color.lerp(chartTransfer, other.chartTransfer, t)!,
      active: Color.lerp(active, other.active, t)!,
      inactive: Color.lerp(inactive, other.inactive, t)!,
      completed: Color.lerp(completed, other.completed, t)!,
      pending: Color.lerp(pending, other.pending, t)!,
      expired: Color.lerp(expired, other.expired, t)!,
      dashboardCard: Color.lerp(dashboardCard, other.dashboardCard, t)!,
      accountCard: Color.lerp(accountCard, other.accountCard, t)!,
      analyticsCard: Color.lerp(analyticsCard, other.analyticsCard, t)!,
      budgetCard: Color.lerp(budgetCard, other.budgetCard, t)!,
      goalCard: Color.lerp(goalCard, other.goalCard, t)!,
      selected: Color.lerp(selected, other.selected, t)!,
      unselected: Color.lerp(unselected, other.unselected, t)!,
      highlighted: Color.lerp(highlighted, other.highlighted, t)!,
      progressGood: Color.lerp(progressGood, other.progressGood, t)!,
      progressWarning: Color.lerp(progressWarning, other.progressWarning, t)!,
      progressDanger: Color.lerp(progressDanger, other.progressDanger, t)!,
      positiveBadge: Color.lerp(positiveBadge, other.positiveBadge, t)!,
      negativeBadge: Color.lerp(negativeBadge, other.negativeBadge, t)!,
      neutralBadge: Color.lerp(neutralBadge, other.neutralBadge, t)!,
      cashAccount: Color.lerp(cashAccount, other.cashAccount, t)!,
      bankAccount: Color.lerp(bankAccount, other.bankAccount, t)!,
      cardAccount: Color.lerp(cardAccount, other.cardAccount, t)!,
      savingsAccount: Color.lerp(savingsAccount, other.savingsAccount, t)!,
      digitalWalletAccount: Color.lerp(
        digitalWalletAccount,
        other.digitalWalletAccount,
        t,
      )!,
      businessAccount: Color.lerp(businessAccount, other.businessAccount, t)!,
      navSelected: Color.lerp(navSelected, other.navSelected, t)!,
      navUnselected: Color.lerp(navUnselected, other.navUnselected, t)!,
    );
  }

  static const light = AppSemanticColors(
    success: Color(0xFF10B981),
    warning: Color(0xFFF59E0B),
    danger: Color(0xFFEF4444),
    info: Color(0xFF3B82F6),
    income: Color(0xFF10B981),
    expense: Color(0xFFEF4444),
    transfer: Color(0xFF6366F1),
    savings: Color(0xFFEC4899),
    budget: Color(0xFF8B5CF6),
    investment: Color(0xFF14B8A6),
    chartIncome: Color(0xFF34D399),
    chartExpense: Color(0xFFF87171),
    chartSavings: Color(0xFFF472B6),
    chartBudget: Color(0xFFA78BFA),
    chartTransfer: Color(0xFF818CF8),
    active: Color(0xFF10B981),
    inactive: Color(0xFF94A3B8),
    completed: Color(0xFF10B981),
    pending: Color(0xFFF59E0B),
    expired: Color(0xFFEF4444),
    dashboardCard: Color(0xFFFFFFFF),
    accountCard: Color(0xFFFFFFFF),
    analyticsCard: Color(0xFFFFFFFF),
    budgetCard: Color(0xFFFFFFFF),
    goalCard: Color(0xFFFFFFFF),
    selected: Color(0xFF1A5F7A),
    unselected: Color(0xFF64748B),
    highlighted: Color(0xFFE2E8F0),
    progressGood: Color(0xFF10B981),
    progressWarning: Color(0xFFF59E0B),
    progressDanger: Color(0xFFEF4444),
    positiveBadge: Color(0xFFD1FAE5),
    negativeBadge: Color(0xFFFEE2E2),
    neutralBadge: Color(0xFFF1F5F9),
    cashAccount: Color(0xFF10B981),
    bankAccount: Color(0xFF3B82F6),
    cardAccount: Color(0xFFEC4899),
    savingsAccount: Color(0xFF8B5CF6),
    digitalWalletAccount: Color(0xFFF59E0B),
    businessAccount: Color(0xFF6D4C41),
    navSelected: Color(0xFF1A5F7A),
    navUnselected: Color(0xFF64748B),
  );

  static const dark = AppSemanticColors(
    success: Color(0xFF34D399),
    warning: Color(0xFFFBBF24),
    danger: Color(0xFFF87171),
    info: Color(0xFF60A5FA),
    income: Color(0xFF34D399),
    expense: Color(0xFFF87171),
    transfer: Color(0xFF818CF8),
    savings: Color(0xFFF472B6),
    budget: Color(0xFFA78BFA),
    investment: Color(0xFF2DD4BF),
    chartIncome: Color(0xFF059669),
    chartExpense: Color(0xFFDC2626),
    chartSavings: Color(0xFFDB2777),
    chartBudget: Color(0xFF7C3AED),
    chartTransfer: Color(0xFF4F46E5),
    active: Color(0xFF34D399),
    inactive: Color(0xFF475569),
    completed: Color(0xFF34D399),
    pending: Color(0xFFFBBF24),
    expired: Color(0xFFF87171),
    dashboardCard: Color(0xFF1E293B),
    accountCard: Color(0xFF1E293B),
    analyticsCard: Color(0xFF1E293B),
    budgetCard: Color(0xFF1E293B),
    goalCard: Color(0xFF1E293B),
    selected: Color(0xFF38BDF8),
    unselected: Color(0xFF94A3B8),
    highlighted: Color(0xFF334155),
    progressGood: Color(0xFF34D399),
    progressWarning: Color(0xFFFBBF24),
    progressDanger: Color(0xFFF87171),
    positiveBadge: Color(0xFF064E3B),
    negativeBadge: Color(0xFF7F1D1D),
    neutralBadge: Color(0xFF1E293B),
    cashAccount: Color(0xFF34D399),
    bankAccount: Color(0xFF60A5FA),
    cardAccount: Color(0xFFF472B6),
    savingsAccount: Color(0xFFA78BFA),
    digitalWalletAccount: Color(0xFFFBBF24),
    businessAccount: Color(0xFF8D6E63),
    navSelected: Color(0xFF38BDF8),
    navUnselected: Color(0xFF94A3B8),
  );
}

extension SemanticTheme on BuildContext {
  AppSemanticColors get semanticColors =>
      Theme.of(this).extension<AppSemanticColors>()!;
}
