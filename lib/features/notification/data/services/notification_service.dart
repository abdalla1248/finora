import 'dart:developer' as dev;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  Future<void> init() async {
    if (_isInitialized) {
      dev.log('NotificationService: Already initialized', name: 'NotificationService');
      return;
    }

    dev.log('NotificationService: Initializing timezone and notifications...', name: 'NotificationService');
    tz.initializeTimeZones();
    try {
      final String timeZoneName = await FlutterTimezone.getLocalTimezone();
      final location = tz.getLocation(timeZoneName);
      tz.setLocalLocation(location);
      dev.log('NotificationService: Timezone set to $timeZoneName', name: 'NotificationService');
    } catch (e) {
      dev.log('NotificationService: Timezone setting failed ($e), falling back', name: 'NotificationService');
    }

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    try {
      final bool? result = await _notificationsPlugin.initialize(
        initSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          dev.log('NotificationService: Notification tapped! Payload: ${response.payload}', name: 'NotificationService');
        },
      );
      dev.log('NotificationService: local notifications plugin initialized, result = $result', name: 'NotificationService');
    } catch (e) {
      dev.log('NotificationService: Local notifications initialization failed: $e', name: 'NotificationService');
    }

    final androidImplementation =
        _notificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      const AndroidNotificationChannel generalChannel = AndroidNotificationChannel(
        'finora_general_channel',
        'General Notifications',
        description: 'Finora general transaction and account alerts',
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
      );

      const AndroidNotificationChannel scheduledChannel = AndroidNotificationChannel(
        'finora_scheduled_channel',
        'Scheduled Reminders',
        description: 'Scheduled reminders and financial reports',
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
      );

      try {
        await androidImplementation.createNotificationChannel(generalChannel);
        await androidImplementation.createNotificationChannel(scheduledChannel);
        dev.log('NotificationService: Android notification channels registered successfully', name: 'NotificationService');
      } catch (e) {
        dev.log('NotificationService: Failed to create Android notification channels: $e', name: 'NotificationService');
      }
    }

    _isInitialized = true;
    dev.log('NotificationService: init completed', name: 'NotificationService');
  }

  Future<bool> requestPermissions() async {
    dev.log('NotificationService: Requesting POST_NOTIFICATIONS permission...', name: 'NotificationService');
    final status = await Permission.notification.request();
    dev.log('NotificationService: POST_NOTIFICATIONS status result: $status', name: 'NotificationService');

    dev.log('NotificationService: Checking/Requesting SCHEDULE_EXACT_ALARM permission...', name: 'NotificationService');
    if (await Permission.scheduleExactAlarm.isDenied) {
      final alarmStatus = await Permission.scheduleExactAlarm.request();
      dev.log('NotificationService: SCHEDULE_EXACT_ALARM status result: $alarmStatus', name: 'NotificationService');
    } else {
      dev.log('NotificationService: SCHEDULE_EXACT_ALARM already granted/not denied', name: 'NotificationService');
    }

    return status.isGranted;
  }

  Future<bool> hasPermission() async {
    final status = await Permission.notification.status;
    dev.log('NotificationService: Checking permission, status: $status', name: 'NotificationService');
    return status.isGranted;
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    dev.log('NotificationService: showNotification called: ID=$id, Title=$title', name: 'NotificationService');
    await init();
    
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'finora_general_channel',
      'General Notifications',
      channelDescription: 'Finora general transaction and account alerts',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    try {
      await _notificationsPlugin.show(
        id,
        title,
        body,
        details,
        payload: payload,
      );
      dev.log('NotificationService: showNotification successfully sent notification ID=$id', name: 'NotificationService');
    } catch (e) {
      dev.log('NotificationService: Failed to show notification ID=$id: $e', name: 'NotificationService');
      rethrow;
    }
  }

  Future<void> scheduleZonedNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
    DateTimeComponents? matchDateTimeComponents,
  }) async {
    dev.log('NotificationService: scheduleZonedNotification called: ID=$id, Title=$title, ScheduledDate=$scheduledDate', name: 'NotificationService');
    await init();
    
    var tzDate = tz.TZDateTime.from(scheduledDate, tz.local);
    final now = tz.TZDateTime.now(tz.local);
    if (tzDate.isBefore(now)) {
      dev.log('NotificationService: Scheduled date is in the past ($tzDate). Adjusting to now + 1 second.', name: 'NotificationService');
      tzDate = now.add(const Duration(seconds: 1));
    }

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'finora_scheduled_channel',
      'Scheduled Reminders',
      channelDescription: 'Scheduled reminders and financial reports',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    try {
      dev.log('NotificationService: Attempting exact scheduled notification to run at $tzDate...', name: 'NotificationService');
      await _notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tzDate,
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: matchDateTimeComponents,
        payload: payload,
      );
      dev.log('NotificationService: Exact scheduled notification successfully set for ID=$id at $tzDate', name: 'NotificationService');
    } catch (e) {
      dev.log('NotificationService: Exact scheduling failed ($e). Falling back to inexact schedule...', name: 'NotificationService');
      try {
        await _notificationsPlugin.zonedSchedule(
          id,
          title,
          body,
          tzDate,
          details,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: matchDateTimeComponents,
          payload: payload,
        );
        dev.log('NotificationService: Inexact scheduled notification successfully set for ID=$id at $tzDate', name: 'NotificationService');
      } catch (err) {
        dev.log('NotificationService: Inexact scheduling failed completely: $err', name: 'NotificationService');
        rethrow;
      }
    }
  }

  Future<void> cancelNotification(int id) async {
    dev.log('NotificationService: Cancelling notification ID=$id', name: 'NotificationService');
    await _notificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    dev.log('NotificationService: Cancelling all notifications', name: 'NotificationService');
    await _notificationsPlugin.cancelAll();
  }

  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    final pending = await _notificationsPlugin.pendingNotificationRequests();
    dev.log('NotificationService: Fetched pending notifications count: ${pending.length}', name: 'NotificationService');
    return pending;
  }

  Future<Map<String, dynamic>> getDiagnostics() async {
    final status = await Permission.notification.status;
    final exactAlarmStatus = await Permission.scheduleExactAlarm.status;
    final pending = await getPendingNotifications();
    return {
      'initialized': _isInitialized,
      'notificationPermission': status.toString(),
      'exactAlarmPermission': exactAlarmStatus.toString(),
      'pendingCount': pending.length,
      'localTimezone': tz.local.name,
      'currentTime': tz.TZDateTime.now(tz.local).toString(),
    };
  }
}
