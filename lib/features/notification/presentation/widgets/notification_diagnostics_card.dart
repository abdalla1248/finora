import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class NotificationDiagnosticsCard extends StatelessWidget {
  final Map<String, dynamic> diagnostics;
  final VoidCallback onRefresh;

  const NotificationDiagnosticsCard({
    super.key,
    required this.diagnostics,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 1.0,
      color: theme.colorScheme.surfaceContainerLow,
      child: Padding(
        padding: EdgeInsets.all(16.0.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'System Diagnostics',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.secondary,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh, size: 20),
                  onPressed: onRefresh,
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            _DiagnosticRow(label: 'Initialized', value: diagnostics['initialized']?.toString() ?? 'false'),
            _DiagnosticRow(label: 'OS Permission', value: diagnostics['notificationPermission']?.toString() ?? 'unknown'),
            _DiagnosticRow(label: 'Exact Alarm', value: diagnostics['exactAlarmPermission']?.toString() ?? 'unknown'),
            _DiagnosticRow(label: 'Pending Reminders', value: diagnostics['pendingCount']?.toString() ?? '0'),
            _DiagnosticRow(label: 'App Timezone', value: diagnostics['localTimezone']?.toString() ?? 'unknown'),
            _DiagnosticRow(label: 'Current Time', value: diagnostics['currentTime']?.toString() ?? 'unknown'),
          ],
        ),
      ),
    );
  }
}

class _DiagnosticRow extends StatelessWidget {
  final String label;
  final String value;

  const _DiagnosticRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
        ],
      ),
    );
  }
}
