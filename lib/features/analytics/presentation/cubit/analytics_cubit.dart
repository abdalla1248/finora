import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../transaction/domain/entities/transaction.dart';
import '../../domain/services/analytics_service.dart';
import 'analytics_state.dart';

class AnalyticsCubit extends Cubit<AnalyticsState> {
  final AnalyticsService _analyticsService;

  AnalyticsCubit(this._analyticsService) : super(const AnalyticsState());

  void setPeriod(
    AnalyticsPeriod period,
    List<Transaction> transactions, {
    String currencyCode = 'USD',
  }) {
    emit(state.copyWith(period: period));
    computeAnalytics(transactions, currencyCode: currencyCode);
  }

  void computeAnalytics(
    List<Transaction> transactions, {
    String currencyCode = 'USD',
  }) {
    emit(state.copyWith(isLoading: true));

    final filtered = _filterTransactionsByPeriod(transactions, state.period);

    final totalIncome = _analyticsService.calculateTotalIncome(filtered);
    final totalExpense = _analyticsService.calculateTotalExpense(filtered);
    final netCashFlow = _analyticsService.calculateNetCashFlow(
      totalIncome,
      totalExpense,
    );
    final savingsRate = _analyticsService.calculateSavingsRate(
      totalIncome,
      totalExpense,
    );
    final categoryExpenses = _analyticsService.getExpenseCategoryBreakdown(
      filtered,
    );
    final insights = _analyticsService.generateInsights(filtered, currencyCode);

    emit(
      state.copyWith(
        totalIncome: totalIncome,
        totalExpense: totalExpense,
        netCashFlow: netCashFlow,
        savingsRate: savingsRate,
        categoryExpenses: categoryExpenses,
        insights: insights,
        isLoading: false,
      ),
    );
  }

  List<Transaction> _filterTransactionsByPeriod(
    List<Transaction> transactions,
    AnalyticsPeriod period,
  ) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    switch (period) {
      case AnalyticsPeriod.today:
        return transactions.where((t) {
          final d = t.transactionDate;
          return d.year == today.year &&
              d.month == today.month &&
              d.day == today.day;
        }).toList();

      case AnalyticsPeriod.yesterday:
        final yesterday = today.subtract(const Duration(days: 1));
        return transactions.where((t) {
          final d = t.transactionDate;
          return d.year == yesterday.year &&
              d.month == yesterday.month &&
              d.day == yesterday.day;
        }).toList();

      case AnalyticsPeriod.thisWeek:
        final firstDayOfWeek = today.subtract(
          Duration(days: today.weekday - 1),
        );
        return transactions.where((t) {
          return t.transactionDate.isAfter(
            firstDayOfWeek.subtract(const Duration(seconds: 1)),
          );
        }).toList();

      case AnalyticsPeriod.thisMonth:
        return transactions.where((t) {
          return t.transactionDate.year == now.year &&
              t.transactionDate.month == now.month;
        }).toList();

      case AnalyticsPeriod.lastMonth:
        final lastMonthDate = DateTime(now.year, now.month - 1, 1);
        return transactions.where((t) {
          return t.transactionDate.year == lastMonthDate.year &&
              t.transactionDate.month == lastMonthDate.month;
        }).toList();

      case AnalyticsPeriod.thisYear:
        return transactions
            .where((t) => t.transactionDate.year == now.year)
            .toList();

      case AnalyticsPeriod.allTime:
        return transactions;
    }
  }
}
