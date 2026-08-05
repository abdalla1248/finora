import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class IncomeExpenseBarChart extends StatelessWidget {
  final double totalIncome;
  final double totalExpense;
  final String currency;

  const IncomeExpenseBarChart({
    super.key,
    required this.totalIncome,
    required this.totalExpense,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    final maxVal = (totalIncome > totalExpense ? totalIncome : totalExpense);
    final maxY = maxVal == 0 ? 100.0 : maxVal * 1.2;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(20.0.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Income vs. Expense',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 15.0.h),
            SizedBox(
              height: 160.h,
              child: BarChart(
                BarChartData(
                  maxY: maxY,
                  barTouchData: const BarTouchData(enabled: true),
                  titlesData: FlTitlesData(
                    show: true,
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          switch (value.toInt()) {
                            case 0:
                              return Padding(
                                padding: EdgeInsets.only(top: 3.0.h),
                                child: const Text(
                                  'Income',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              );
                            case 1:
                              return Padding(
                                padding: EdgeInsets.only(top: 3.0.h),
                                child: const Text(
                                  'Expense',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              );
                            default:
                              return const SizedBox.shrink();
                          }
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: const FlGridData(show: false),
                  barGroups: [
                    BarChartGroupData(
                      x: 0,
                      barRods: [
                        BarChartRodData(
                          toY: totalIncome,
                          color: const Color(0xFF10B981),
                          width: 32,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 1,
                      barRods: [
                        BarChartRodData(
                          toY: totalExpense,
                          color: Theme.of(context).colorScheme.error,
                          width: 26.w,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
