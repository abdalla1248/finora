import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:finora/features/budget/domain/entities/budget.dart';
import 'package:finora/features/budget/domain/entities/savings_goal.dart';
import 'package:finora/features/notification/domain/entities/notification_settings.dart';
import 'notification_service.dart';

class NotificationSchedulerService {
  final NotificationService _notificationService;

  NotificationSchedulerService({NotificationService? notificationService})
      : _notificationService = notificationService ?? NotificationService();

  // Notification IDs
  static const int reminderNotificationId = 1001;
  static const int weeklySummaryId = 1002;
  static const int monthlySummaryId = 1003;
  static const int baseBudgetNotificationId = 2000;
  static const int baseGoalNotificationId = 3000;

  Future<void> syncNotifications({
    required NotificationSettings settings,
    required List<Budget> budgets,
    required List<SavingsGoal> goals,
    required String lang,
    Map<String, double> budgetSpentAmounts = const {},
  }) async {
    final isAr = lang.toLowerCase() == 'ar';

    if (settings.enableReminders) {
      await _scheduleReminders(settings, isAr);
    } else {
      await _notificationService.cancelNotification(reminderNotificationId);
    }

    if (settings.enableWeeklySummary) {
      await _scheduleWeeklySummary(settings, isAr);
    } else {
      await _notificationService.cancelNotification(weeklySummaryId);
    }

    if (settings.enableMonthlySummary) {
      await _scheduleMonthlySummary(settings, isAr);
    } else {
      await _notificationService.cancelNotification(monthlySummaryId);
    }

    if (settings.enableBudgetAlerts) {
      for (int i = 0; i < budgets.length; i++) {
        final budget = budgets[i];
        final spentAmount = budgetSpentAmounts[budget.id] ?? 0.0;
        _evaluateBudgetNotification(budget, spentAmount, baseBudgetNotificationId + i, isAr);
      }
    }

    if (settings.enableGoalAlerts) {
      for (int i = 0; i < goals.length; i++) {
        _evaluateGoalNotification(goals[i], baseGoalNotificationId + i, isAr);
      }
    }
  }

  Future<void> _scheduleReminders(NotificationSettings settings, bool isAr) async {
    final now = DateTime.now();
    var scheduledDate = DateTime(
      now.year,
      now.month,
      now.day,
      settings.reminderHour,
      settings.reminderMinute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    final title = isAr ? 'تذكير التسجيل اليومي' : 'Daily Expense Reminder';
    final body = isAr
        ? 'لا تنسَ تسجيل مصروفاتك اليومية للحفاظ على دقة ميزانيتك!'
        : 'Don\'t forget to log today\'s expenses to keep your budget accurate!';

    DateTimeComponents? matchComponents;
    switch (settings.reminderFrequency) {
      case ReminderFrequency.daily:
        matchComponents = DateTimeComponents.time;
        break;
      case ReminderFrequency.weekly:
      case ReminderFrequency.biWeekly:
        matchComponents = DateTimeComponents.dayOfWeekAndTime;
        break;
      case ReminderFrequency.monthly:
        matchComponents = DateTimeComponents.dayOfMonthAndTime;
        break;
    }

    await _notificationService.scheduleZonedNotification(
      id: reminderNotificationId,
      title: title,
      body: body,
      scheduledDate: scheduledDate,
      matchDateTimeComponents: matchComponents,
    );
  }

  Future<void> _scheduleWeeklySummary(NotificationSettings settings, bool isAr) async {
    final now = DateTime.now();
    var scheduledDate = DateTime(now.year, now.month, now.day, 20, 0);
    while (scheduledDate.weekday != DateTime.sunday || scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    final title = isAr ? 'الملخص الأسبوعي' : 'Weekly Summary';
    final body = isAr
        ? 'تفقد ملخص إنفاقك هذا الأسبوع واستعرض التقرير التفاعلي في فينورا.'
        : 'Check your weekly spending summary and interactive report in Finora.';

    await _notificationService.scheduleZonedNotification(
      id: weeklySummaryId,
      title: title,
      body: body,
      scheduledDate: scheduledDate,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );
  }

  Future<void> _scheduleMonthlySummary(NotificationSettings settings, bool isAr) async {
    final now = DateTime.now();
    var scheduledDate = DateTime(now.year, now.month, 1, 10, 0);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = DateTime(now.year, now.month + 1, 1, 10, 0);
    }

    final title = isAr ? 'الملخص الشهري' : 'Monthly Summary';
    final body = isAr
        ? 'تقرير الشهر جاهز! افتح التطبيق لمراجعة إجمالي الدخل والمصروفات.'
        : 'Your monthly report is ready! Tap to view your total income and expenses.';

    await _notificationService.scheduleZonedNotification(
      id: monthlySummaryId,
      title: title,
      body: body,
      scheduledDate: scheduledDate,
      matchDateTimeComponents: DateTimeComponents.dayOfMonthAndTime,
    );
  }

  void _evaluateBudgetNotification(Budget budget, double spentAmount, int id, bool isAr) {
    if (budget.amount <= 0) return;

    // Check if budget is exceeded or at 100%
    if (spentAmount >= budget.amount) {
      final title = isAr ? 'تجاوز الميزانية!' : 'Budget Exceeded!';
      final body = isAr
          ? 'لقد تجاوزت ميزانية ${budget.name}!'
          : 'You have exceeded your budget for ${budget.name}!';
      _notificationService.showNotification(id: id, title: title, body: body);
    }
  }

  void _evaluateGoalNotification(SavingsGoal goal, int id, bool isAr) {
    if (goal.isCompleted) {
      final title = isAr ? 'تهانينا! اكتمل الهدف 🎉' : 'Goal Completed! 🎉';
      final body = isAr
          ? 'لقد نجحت في تحقيق هدف التوفير: ${goal.title}'
          : 'You successfully achieved your savings goal: ${goal.title}';
      _notificationService.showNotification(id: id, title: title, body: body);
    } else if (goal.isExpired) {
      final title = isAr ? 'انتهت مهلة الهدف' : 'Goal Expired';
      final body = isAr
          ? 'انتهى الموعد النهائي لهدف التوفير: ${goal.title}'
          : 'The deadline for savings goal ${goal.title} has passed.';
      _notificationService.showNotification(id: id, title: title, body: body);
    }
  }
}
