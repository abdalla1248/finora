import 'package:flutter/material.dart';
import '../../../transaction/domain/entities/category.dart';
import '../../../transaction/domain/entities/transaction.dart';
import '../models/analytics_insight.dart';

class AnalyticsService {
  const AnalyticsService();

  double calculateTotalIncome(List<Transaction> transactions) {
    return transactions
        .where((t) => t.transactionType == TransactionType.income)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double calculateTotalExpense(List<Transaction> transactions) {
    return transactions
        .where((t) => t.transactionType == TransactionType.expense)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double calculateNetCashFlow(double income, double expense) {
    return income - expense;
  }

  double calculateSavingsRate(double income, double expense) {
    if (income <= 0) return 0.0;
    final savings = income - expense;
    if (savings <= 0) return 0.0;
    return (savings / income) * 100;
  }

  Map<String, double> getExpenseCategoryBreakdown(
    List<Transaction> transactions,
  ) {
    final expenses = transactions.where(
      (t) => t.transactionType == TransactionType.expense,
    );
    final breakdown = <String, double>{};
    for (final tx in expenses) {
      breakdown[tx.categoryId] = (breakdown[tx.categoryId] ?? 0.0) + tx.amount;
    }
    return breakdown;
  }

  List<AnalyticsInsight> generateInsights(
    List<Transaction> transactions,
    String currency,
  ) {
    if (transactions.isEmpty) return [];

    final insights = <AnalyticsInsight>[];

    final totalIncome = calculateTotalIncome(transactions);
    final totalExpense = calculateTotalExpense(transactions);
    final savingsRate = calculateSavingsRate(totalIncome, totalExpense);

    // 1. Highest Spending Category
    final categoryBreakdown = getExpenseCategoryBreakdown(transactions);
    if (categoryBreakdown.isNotEmpty) {
      final highestCategoryEntry = categoryBreakdown.entries.reduce(
        (a, b) => a.value > b.value ? a : b,
      );
      final cat = CategoryRegistry.getCategoryById(highestCategoryEntry.key);
      insights.add(
        AnalyticsInsight(
          id: 'highest_spending_category',
          titleKey: 'insightHighestCategoryTitle',
          value:
              '${cat.id} ($currency ${highestCategoryEntry.value.toStringAsFixed(2)})',
          descriptionKey: 'insightHighestCategoryDesc',
          icon: cat.icon,
          color: cat.color,
        ),
      );
    }

    // 2. Largest Expense Transaction
    final expenses = transactions.where(
      (t) => t.transactionType == TransactionType.expense,
    );
    if (expenses.isNotEmpty) {
      final maxExpense = expenses.reduce((a, b) => a.amount > b.amount ? a : b);
      insights.add(
        AnalyticsInsight(
          id: 'largest_expense',
          titleKey: 'insightLargestExpenseTitle',
          value:
              '${maxExpense.title} ($currency ${maxExpense.amount.toStringAsFixed(2)})',
          descriptionKey: 'insightLargestExpenseDesc',
          icon: Icons.arrow_downward,
          color: const Color(0xFFEF4444),
        ),
      );
    }

    // 3. Largest Income Transaction
    final incomes = transactions.where(
      (t) => t.transactionType == TransactionType.income,
    );
    if (incomes.isNotEmpty) {
      final maxIncome = incomes.reduce((a, b) => a.amount > b.amount ? a : b);
      insights.add(
        AnalyticsInsight(
          id: 'largest_income',
          titleKey: 'insightLargestIncomeTitle',
          value:
              '${maxIncome.title} ($currency ${maxIncome.amount.toStringAsFixed(2)})',
          descriptionKey: 'insightLargestIncomeDesc',
          icon: Icons.arrow_upward,
          color: const Color(0xFF10B981),
        ),
      );
    }

    // 4. Savings Rate Insight
    if (totalIncome > 0) {
      insights.add(
        AnalyticsInsight(
          id: 'savings_rate',
          titleKey: 'insightSavingsRateTitle',
          value: '${savingsRate.toStringAsFixed(1)}%',
          descriptionKey: 'insightSavingsRateDesc',
          icon: Icons.savings,
          color: const Color(0xFF3B82F6),
        ),
      );
    }

    // 5. Daily Average Spending
    if (expenses.isNotEmpty) {
      final dates = expenses
          .map(
            (e) => DateTime(
              e.transactionDate.year,
              e.transactionDate.month,
              e.transactionDate.day,
            ),
          )
          .toSet();
      final dayCount = dates.isEmpty ? 1 : dates.length;
      final avgDaily = totalExpense / dayCount;
      insights.add(
        AnalyticsInsight(
          id: 'avg_daily_spending',
          titleKey: 'insightAvgDailyTitle',
          value: '$currency ${avgDaily.toStringAsFixed(2)}',
          descriptionKey: 'insightAvgDailyDesc',
          icon: Icons.calendar_today,
          color: const Color(0xFF8B5CF6),
        ),
      );
    }

    return insights;
  }
}
