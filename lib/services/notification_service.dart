// Notification service for study reminders and alarms
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import '../models/models.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications = 
      FlutterLocalNotificationsPlugin();
  
  static bool _isInitialized = false;
  
  static Future<void> init() async {
    if (_isInitialized) return;
    
    tz.initializeTimeZones();
    
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    
    const initSettings = InitializationSettings(
      android: androidSettings,
    );
    
    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
    
    // Create notification channels
    await _createNotificationChannels();
    
    _isInitialized = true;
  }
  
  static Future<void> _createNotificationChannels() async {
    final androidPlugin = _notifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    
    if (androidPlugin != null) {
      // Study Reminder Channel
      await androidPlugin.createNotificationChannel(
        const AndroidNotificationChannel(
          'study_reminders',
          'Study Reminders',
          description: 'Reminders for study sessions',
          importance: Importance.high,
          playSound: true,
        ),
      );
      
      // Alarm Channel
      await androidPlugin.createNotificationChannel(
        const AndroidNotificationChannel(
          'alarms',
          'Alarms',
          description: 'Wake up and sleep alarms',
          importance: Importance.max,
          playSound: true,
          sound: RawResourceAndroidNotificationSound('alarm_sound'),
        ),
      );
      
      // Progress Channel
      await androidPlugin.createNotificationChannel(
        const AndroidNotificationChannel(
          'progress',
          'Progress Updates',
          description: 'Daily progress notifications',
          importance: Importance.defaultImportance,
        ),
      );
    }
  }
  
  static void _onNotificationTapped(NotificationResponse response) {
    // Handle notification tap - navigate to relevant screen
    debugPrint('Notification tapped: ${response.payload}');
  }
  
  // Request notification permissions
  static Future<bool> requestPermissions() async {
    final androidPlugin = _notifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    
    if (androidPlugin != null) {
      final granted = await androidPlugin.requestNotificationsPermission();
      return granted ?? false;
    }
    return false;
  }
  
  // Schedule a study reminder
  static Future<void> scheduleStudyReminder({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    await _notifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'study_reminders',
          'Study Reminders',
          channelDescription: 'Reminders for study sessions',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          color: Color(0xFF6366F1),
          category: AndroidNotificationCategory.reminder,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      payload: 'study_reminder_$id',
    );
  }
  
  // Schedule daily routine notifications
  static Future<void> scheduleDailyRoutineNotifications(
    List<DailyRoutine> routines,
  ) async {
    // Cancel existing notifications
    await cancelAllNotifications();
    
    int notificationId = 1000;
    
    for (final routine in routines) {
      // Skip past dates
      if (routine.date.isBefore(DateTime.now())) continue;
      
      // Morning reminder (5 minutes before first session)
      final morningSessions = routine.sessions
          .where((s) => s.sessionType == 'morning')
          .toList();
      
      if (morningSessions.isNotEmpty) {
        final firstSession = morningSessions.first;
        final reminderTime = DateTime(
          routine.date.year,
          routine.date.month,
          routine.date.day,
          firstSession.startTime.hour,
          firstSession.startTime.minute - 5,
        );
        
        if (reminderTime.isAfter(DateTime.now())) {
          await scheduleStudyReminder(
            id: notificationId++,
            title: '🌅 Morning Study Session',
            body: 'Time to study ${firstSession.subject.name} - ${firstSession.chapter.name}',
            scheduledTime: reminderTime,
          );
        }
      }
      
      // Evening reminder
      final eveningSessions = routine.sessions
          .where((s) => s.sessionType == 'evening')
          .toList();
      
      if (eveningSessions.isNotEmpty) {
        final firstSession = eveningSessions.first;
        final reminderTime = DateTime(
          routine.date.year,
          routine.date.month,
          routine.date.day,
          firstSession.startTime.hour,
          firstSession.startTime.minute - 5,
        );
        
        if (reminderTime.isAfter(DateTime.now())) {
          await scheduleStudyReminder(
            id: notificationId++,
            title: '🌆 Evening Study Session',
            body: 'Time to study ${firstSession.subject.name} - ${firstSession.chapter.name}',
            scheduledTime: reminderTime,
          );
        }
      }
      
      // Night reminder
      final nightSessions = routine.sessions
          .where((s) => s.sessionType == 'night')
          .toList();
      
      if (nightSessions.isNotEmpty) {
        final firstSession = nightSessions.first;
        final reminderTime = DateTime(
          routine.date.year,
          routine.date.month,
          routine.date.day,
          firstSession.startTime.hour,
          firstSession.startTime.minute - 5,
        );
        
        if (reminderTime.isAfter(DateTime.now())) {
          await scheduleStudyReminder(
            id: notificationId++,
            title: '🌙 Night Study Session',
            body: 'Time to study ${firstSession.subject.name} - ${firstSession.chapter.name}',
            scheduledTime: reminderTime,
          );
        }
      }
    }
  }
  
  // Schedule alarm
  static Future<void> scheduleAlarm(AlarmData alarm) async {
    if (!alarm.isEnabled) return;
    
    final now = DateTime.now();
    
    // Find next occurrence
    DateTime nextAlarm = DateTime(
      now.year,
      now.month,
      now.day,
      alarm.time.hour,
      alarm.time.minute,
    );
    
    if (nextAlarm.isBefore(now)) {
      nextAlarm = nextAlarm.add(const Duration(days: 1));
    }
    
    // If repeat days specified, find next valid day
    if (alarm.repeatDays.isNotEmpty) {
      while (!alarm.repeatDays.contains(nextAlarm.weekday % 7)) {
        nextAlarm = nextAlarm.add(const Duration(days: 1));
      }
    }
    
    String title;
    String body;
    
    switch (alarm.type) {
      case AlarmType.wakeUp:
        title = '⏰ Wake Up!';
        body = alarm.label.isEmpty ? 'Time to start your day!' : alarm.label;
        break;
      case AlarmType.sleep:
        title = '😴 Sleep Reminder';
        body = alarm.label.isEmpty ? 'Time to get some rest!' : alarm.label;
        break;
      case AlarmType.studyReminder:
        title = '📚 Study Time';
        body = alarm.label.isEmpty ? 'Don\'t forget to study!' : alarm.label;
        break;
    }
    
    await _notifications.zonedSchedule(
      alarm.id,
      title,
      body,
      tz.TZDateTime.from(nextAlarm, tz.local),
      NotificationDetails(
        android: AndroidNotificationDetails(
          'alarms',
          'Alarms',
          channelDescription: 'Wake up and sleep alarms',
          importance: Importance.max,
          priority: Priority.max,
          icon: '@mipmap/ic_launcher',
          color: const Color(0xFF6366F1),
          category: AndroidNotificationCategory.alarm,
          fullScreenIntent: true,
          ongoing: alarm.type == AlarmType.wakeUp,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.alarmClock,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      payload: 'alarm_${alarm.id}',
    );
  }
  
  // Cancel specific notification
  static Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }
  
  // Cancel all notifications
  static Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }
  
  // Show immediate notification
  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    await _notifications.show(
      id,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'progress',
          'Progress Updates',
          channelDescription: 'Daily progress notifications',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          icon: '@mipmap/ic_launcher',
          color: Color(0xFF6366F1),
        ),
      ),
      payload: payload,
    );
  }
  
  // Show countdown notification
  static Future<void> showCountdownNotification(int daysRemaining) async {
    await showNotification(
      id: 9999,
      title: '📅 SSC 2026 Countdown',
      body: daysRemaining == 1 
          ? 'Only 1 day left until SSC exam!' 
          : '$daysRemaining days remaining until SSC exam!',
      payload: 'countdown',
    );
  }
}
