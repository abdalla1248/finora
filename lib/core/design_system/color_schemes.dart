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
    secondary: Color(0xFF475569),
    onSecondary: Colors.white,
    error: expenseRed,
    onError: Colors.white,
    surface: backgroundLight,
    onSurface: Color(0xFF0F172A),
    surfaceContainer: Colors.white,
    surfaceContainerHighest: Color(0xFFE2E8F0),
    onSurfaceVariant: Color(0xFF475569),
    outline: Color(0xFF94A3B8),
  );

  static const ColorScheme dark = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF38BDF8),
    onPrimary: Color(0xFF0F172A),
    secondary: Color(0xFF94A3B8),
    onSecondary: Color(0xFF0F172A),
    error: Color(0xFFF87171),
    onError: Color(0xFF7F1D1D),
    surface: Colors.black,
    onSurface: Color(0xFFF8FAFC),
    surfaceContainer: backgroundDark,
    surfaceContainerHighest: surfaceDark,
    onSurfaceVariant: Color(0xFF94A3B8),
    outline: Color(0xFF475569),
  );
}

class TransactionColors extends ThemeExtension<TransactionColors> {
  final Color income;
  final Color expense;
  final Color warning;

  const TransactionColors({
    required this.income,
    required this.expense,
    required this.warning,
  });

  @override
  ThemeExtension<TransactionColors> copyWith({
    Color? income,
    Color? expense,
    Color? warning,
  }) {
    return TransactionColors(
      income: income ?? this.income,
      expense: expense ?? this.expense,
      warning: warning ?? this.warning,
    );
  }

  @override
  ThemeExtension<TransactionColors> lerp(
    covariant ThemeExtension<TransactionColors>? other,
    double t,
  ) {
    if (other is! TransactionColors) return this;
    return TransactionColors(
      income: Color.lerp(income, other.income, t)!,
      expense: Color.lerp(expense, other.expense, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
    );
  }

  static const light = TransactionColors(
    income: FinoraColorSchemes.incomeGreen,
    expense: FinoraColorSchemes.expenseRed,
    warning: FinoraColorSchemes.warningAmber,
  );

  static const dark = TransactionColors(
    income: Color(0xFF34D399),
    expense: Color(0xFFF87171),
    warning: Color(0xFFFBBF24),
  );
}
