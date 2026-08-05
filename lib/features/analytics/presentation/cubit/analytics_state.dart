import 'package:equatable/equatable.dart';
import '../../domain/models/analytics_insight.dart';

enum AnalyticsPeriod {
  today,
  yesterday,
  thisWeek,
  thisMonth,
  lastMonth,
  thisYear,
  allTime,
}

class AnalyticsState extends Equatable {
  final AnalyticsPeriod period;
  final double totalIncome;
  final double totalExpense;
  final double netCashFlow;
  final double savingsRate;
  final Map<String, double> categoryExpenses;
  final List<AnalyticsInsight> insights;
  final bool isLoading;

  const AnalyticsState({
    this.period = AnalyticsPeriod.thisMonth,
    this.totalIncome = 0.0,
    this.totalExpense = 0.0,
    this.netCashFlow = 0.0,
    this.savingsRate = 0.0,
    this.categoryExpenses = const {},
    this.insights = const [],
    this.isLoading = false,
  });

  AnalyticsState copyWith({
    AnalyticsPeriod? period,
    double? totalIncome,
    double? totalExpense,
    double? netCashFlow,
    double? savingsRate,
    Map<String, double>? categoryExpenses,
    List<AnalyticsInsight>? insights,
    bool? isLoading,
  }) {
    return AnalyticsState(
      period: period ?? this.period,
      totalIncome: totalIncome ?? this.totalIncome,
      totalExpense: totalExpense ?? this.totalExpense,
      netCashFlow: netCashFlow ?? this.netCashFlow,
      savingsRate: savingsRate ?? this.savingsRate,
      categoryExpenses: categoryExpenses ?? this.categoryExpenses,
      insights: insights ?? this.insights,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [
    period,
    totalIncome,
    totalExpense,
    netCashFlow,
    savingsRate,
    categoryExpenses,
    insights,
    isLoading,
  ];
}
