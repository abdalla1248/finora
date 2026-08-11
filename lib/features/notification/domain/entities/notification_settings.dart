import 'package:equatable/equatable.dart';

enum ReminderFrequency { daily, weekly, biWeekly, monthly }

class NotificationSettings extends Equatable {
  final bool enableBudgetAlerts;
  final bool enableGoalAlerts;
  final bool enableReminders;
  final bool enableWeeklySummary;
  final bool enableMonthlySummary;
  final ReminderFrequency reminderFrequency;
  final int reminderHour;
  final int reminderMinute;
  final int? reminderDayOfWeek; // 1 = Monday, 7 = Sunday
  final int? reminderDayOfMonth; // 1 - 31

  const NotificationSettings({
    this.enableBudgetAlerts = true,
    this.enableGoalAlerts = true,
    this.enableReminders = true,
    this.enableWeeklySummary = true,
    this.enableMonthlySummary = true,
    this.reminderFrequency = ReminderFrequency.daily,
    this.reminderHour = 20,
    this.reminderMinute = 0,
    this.reminderDayOfWeek = 5, // Friday by default
    this.reminderDayOfMonth = 1,
  });

  NotificationSettings copyWith({
    bool? enableBudgetAlerts,
    bool? enableGoalAlerts,
    bool? enableReminders,
    bool? enableWeeklySummary,
    bool? enableMonthlySummary,
    ReminderFrequency? reminderFrequency,
    int? reminderHour,
    int? reminderMinute,
    int? reminderDayOfWeek,
    int? reminderDayOfMonth,
  }) {
    return NotificationSettings(
      enableBudgetAlerts: enableBudgetAlerts ?? this.enableBudgetAlerts,
      enableGoalAlerts: enableGoalAlerts ?? this.enableGoalAlerts,
      enableReminders: enableReminders ?? this.enableReminders,
      enableWeeklySummary: enableWeeklySummary ?? this.enableWeeklySummary,
      enableMonthlySummary: enableMonthlySummary ?? this.enableMonthlySummary,
      reminderFrequency: reminderFrequency ?? this.reminderFrequency,
      reminderHour: reminderHour ?? this.reminderHour,
      reminderMinute: reminderMinute ?? this.reminderMinute,
      reminderDayOfWeek: reminderDayOfWeek ?? this.reminderDayOfWeek,
      reminderDayOfMonth: reminderDayOfMonth ?? this.reminderDayOfMonth,
    );
  }

  @override
  List<Object?> get props => [
        enableBudgetAlerts,
        enableGoalAlerts,
        enableReminders,
        enableWeeklySummary,
        enableMonthlySummary,
        reminderFrequency,
        reminderHour,
        reminderMinute,
        reminderDayOfWeek,
        reminderDayOfMonth,
      ];
}
