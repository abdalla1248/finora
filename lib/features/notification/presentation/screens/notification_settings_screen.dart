import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:finora/core/responsive/responsive_centered_view.dart';
import 'package:finora/l10n/app_localizations.dart';
import 'package:finora/features/notification/data/services/notification_service.dart';
import 'package:finora/features/notification/domain/entities/notification_settings.dart';
import 'package:finora/features/notification/presentation/widgets/notification_diagnostics_card.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  final NotificationService _notificationService = NotificationService();
  NotificationSettings _settings = const NotificationSettings();
  bool _hasPermission = false;
  Map<String, dynamic> _diagnostics = {};

  @override
  void initState() {
    super.initState();
    _checkPermission();
    _loadDiagnostics();
  }

  Future<void> _loadDiagnostics() async {
    final diag = await _notificationService.getDiagnostics();
    if (mounted) {
      setState(() {
        _diagnostics = diag;
      });
    }
  }

  Future<void> _checkPermission() async {
    final granted = await _notificationService.hasPermission();
    if (mounted) {
      setState(() {
        _hasPermission = granted;
      });
    }
    await _loadDiagnostics();
  }

  Future<void> _requestPermission() async {
    final granted = await _notificationService.requestPermissions();
    if (mounted) {
      setState(() {
        _hasPermission = granted;
      });
    }
    await _loadDiagnostics();
  }

  Future<void> _sendTestNotification(AppLocalizations l10n) async {
    try {
      await _notificationService.showNotification(
        id: 9998,
        title: 'Finora Notification Test',
        body: 'Notifications are working! A 10-second scheduled alert is active.',
      );

      final scheduledTime = DateTime.now().add(const Duration(seconds: 10));
      await _notificationService.scheduleZonedNotification(
        id: 9999,
        title: 'Finora Scheduled Test',
        body: 'Scheduled notification delivered 10 seconds after trigger!',
        scheduledDate: scheduledTime,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Instant notification sent & 10-second background alert scheduled!'),
            duration: Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Notification test error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
    await _loadDiagnostics();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.notificationsTitle),
      ),
      body: ResponsiveCenteredView(
        child: ListView(
          padding: EdgeInsets.all(16.0.r),
          children: [
            // Permission Banner
            Card(
              color: _hasPermission
                  ? theme.colorScheme.primaryContainer.withValues(alpha: 0.3)
                  : theme.colorScheme.errorContainer.withValues(alpha: 0.3),
              child: ListTile(
                leading: Icon(
                  _hasPermission ? Icons.check_circle : Icons.warning_amber_rounded,
                  color: _hasPermission
                      ? theme.colorScheme.primary
                      : theme.colorScheme.error,
                ),
                title: Text(l10n.permissionStatusTitle),
                subtitle: Text(
                  _hasPermission ? l10n.permissionGranted : l10n.permissionDenied,
                ),
                trailing: !_hasPermission
                    ? ElevatedButton(
                        onPressed: _requestPermission,
                        child: Text(l10n.requestPermissionButton),
                      )
                    : null,
              ),
            ),
            SizedBox(height: 16.0.h),

            // Toggles Card (modernized without Dividers)
            Card(
              elevation: 2.0,
              shadowColor: theme.colorScheme.shadow.withValues(alpha: 0.08),
              child: Column(
                children: [
                  SwitchListTile(
                    secondary: const Icon(Icons.pie_chart_outline),
                    title: Text(l10n.budgetNotificationsTitle),
                    subtitle: Text(l10n.budgetNotificationsDesc),
                    value: _settings.enableBudgetAlerts,
                    onChanged: (val) {
                      setState(() {
                        _settings = _settings.copyWith(enableBudgetAlerts: val);
                      });
                    },
                  ),
                  SwitchListTile(
                    secondary: const Icon(Icons.flag_outlined),
                    title: Text(l10n.goalNotificationsTitle),
                    subtitle: Text(l10n.goalNotificationsDesc),
                    value: _settings.enableGoalAlerts,
                    onChanged: (val) {
                      setState(() {
                        _settings = _settings.copyWith(enableGoalAlerts: val);
                      });
                    },
                  ),
                  SwitchListTile(
                    secondary: const Icon(Icons.alarm),
                    title: Text(l10n.reminderNotificationsTitle),
                    subtitle: Text(l10n.reminderNotificationsDesc),
                    value: _settings.enableReminders,
                    onChanged: (val) {
                      setState(() {
                        _settings = _settings.copyWith(enableReminders: val);
                      });
                    },
                  ),
                  SwitchListTile(
                    secondary: const Icon(Icons.calendar_view_week),
                    title: Text(l10n.weeklySummaryTitle),
                    subtitle: Text(l10n.weeklySummaryDesc),
                    value: _settings.enableWeeklySummary,
                    onChanged: (val) {
                      setState(() {
                        _settings = _settings.copyWith(enableWeeklySummary: val);
                      });
                    },
                  ),
                  SwitchListTile(
                    secondary: const Icon(Icons.calendar_month),
                    title: Text(l10n.monthlySummaryTitle),
                    subtitle: Text(l10n.monthlySummaryDesc),
                    value: _settings.enableMonthlySummary,
                    onChanged: (val) {
                      setState(() {
                        _settings = _settings.copyWith(enableMonthlySummary: val);
                      });
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.0.h),

            // Schedule Options Card
            if (_settings.enableReminders)
              Card(
                elevation: 2.0,
                shadowColor: theme.colorScheme.shadow.withValues(alpha: 0.08),
                child: Padding(
                  padding: EdgeInsets.all(16.0.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.reminderFrequencyTitle,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.0.h),
                      DropdownButtonFormField<ReminderFrequency>(
                        initialValue: _settings.reminderFrequency,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        items: [
                          DropdownMenuItem(
                            value: ReminderFrequency.daily,
                            child: Text(l10n.freqDaily),
                          ),
                          DropdownMenuItem(
                            value: ReminderFrequency.weekly,
                            child: Text(l10n.freqWeekly),
                          ),
                          DropdownMenuItem(
                            value: ReminderFrequency.biWeekly,
                            child: Text(l10n.freqBiWeekly),
                          ),
                          DropdownMenuItem(
                            value: ReminderFrequency.monthly,
                            child: Text(l10n.freqMonthly),
                          ),
                        ],
                        onChanged: (freq) {
                          if (freq != null) {
                            setState(() {
                              _settings = _settings.copyWith(reminderFrequency: freq);
                            });
                          }
                        },
                      ),
                      SizedBox(height: 16.0.h),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.access_time),
                        title: Text(l10n.reminderTimeTitle),
                        trailing: Text(
                          TimeOfDay(
                            hour: _settings.reminderHour,
                            minute: _settings.reminderMinute,
                          ).format(context),
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () async {
                          final picked = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay(
                              hour: _settings.reminderHour,
                              minute: _settings.reminderMinute,
                            ),
                          );
                          if (picked != null) {
                            setState(() {
                              _settings = _settings.copyWith(
                                reminderHour: picked.hour,
                                reminderMinute: picked.minute,
                              );
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),

            SizedBox(height: 24.0.h),

            // Test Notification Button
            ElevatedButton.icon(
              onPressed: () => _sendTestNotification(l10n),
              icon: const Icon(Icons.notifications_active),
              label: Text(l10n.testNotificationButton),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 14.0.h),
              ),
            ),
            SizedBox(height: 24.0.h),

            NotificationDiagnosticsCard(
              diagnostics: _diagnostics,
              onRefresh: _loadDiagnostics,
            ),
          ],
        ),
      ),
    );
  }
}
