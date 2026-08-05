import 'package:flutter/material.dart';
import '../../domain/models/analytics_insight.dart';

class FinancialInsightsCard extends StatelessWidget {
  final List<AnalyticsInsight> insights;

  const FinancialInsightsCard({super.key, required this.insights});

  @override
  Widget build(BuildContext context) {
    if (insights.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Financial Insights',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12.0),
        ...insights.map(
          (insight) => Card(
            margin: const EdgeInsets.only(bottom: 8.0),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: insight.color.withValues(alpha: 0.15),
                child: Icon(insight.icon, color: insight.color),
              ),
              title: Text(
                insight.id.replaceAll('_', ' ').toUpperCase(),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
              subtitle: Text(
                insight.value,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: insight.color,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
