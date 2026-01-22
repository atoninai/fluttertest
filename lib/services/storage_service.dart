import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';

class StorageService {
  static SharedPreferences? _prefs;
  
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }
  
  static SharedPreferences get prefs {
    if (_prefs == null) {
      throw Exception('StorageService not initialized. Call init() first.');
    }
    return _prefs!;
  }

  // Section & Progress
  static Future<void> saveSelectedSection(String sectionId) async {
    await prefs.setString('selected_section', sectionId);
  }

  static String? getSelectedSection() {
    return prefs.getString('selected_section');
  }

  static Future<void> saveCompletedChapters(List<String> chapterIds) async {
    await prefs.setStringList('completed_chapters', chapterIds);
  }

  static List<String> getCompletedChapters() {
    return prefs.getStringList('completed_chapters') ?? [];
  }

  static Future<void> markChapterCompleted(String chapterId) async {
    final completed = getCompletedChapters();
    if (!completed.contains(chapterId)) {
      completed.add(chapterId);
      await saveCompletedChapters(completed);
    }
  }

  static Future<void> markChapterIncomplete(String chapterId) async {
    final completed = getCompletedChapters();
    completed.remove(chapterId);
    await saveCompletedChapters(completed);
  }

  // Daily Progress
  static Future<void> saveDayProgress(DayProgress progress) async {
    final key = 'day_progress_${progress.date.toIso8601String().split('T')[0]}';
    await prefs.setString(key, jsonEncode(progress.toJson()));
  }

  static DayProgress? getDayProgress(DateTime date) {
    final key = 'day_progress_${date.toIso8601String().split('T')[0]}';
    final data = prefs.getString(key);
    if (data != null) {
      return DayProgress.fromJson(jsonDecode(data));
    }
    return null;
  }

  static Future<Map<DateTime, DayProgress>> getAllDayProgress() async {
    final Map<DateTime, DayProgress> progressMap = {};
    final keys = prefs.getKeys().where((k) => k.startsWith('day_progress_'));
    
    for (final key in keys) {
      final data = prefs.getString(key);
      if (data != null) {
        final progress = DayProgress.fromJson(jsonDecode(data));
        final dateKey = DateTime(
          progress.date.year,
          progress.date.month,
          progress.date.day,
        );
        progressMap[dateKey] = progress;
      }
    }
    return progressMap;
  }

  // Alarms
  static Future<void> saveAlarms(List<AlarmData> alarms) async {
    final jsonList = alarms.map((a) => jsonEncode(a.toJson())).toList();
    await prefs.setStringList('alarms', jsonList);
  }

  static List<AlarmData> getAlarms() {
    final jsonList = prefs.getStringList('alarms') ?? [];
    return jsonList.map((j) => AlarmData.fromJson(jsonDecode(j))).toList();
  }

  static Future<void> addAlarm(AlarmData alarm) async {
    final alarms = getAlarms();
    alarms.add(alarm);
    await saveAlarms(alarms);
  }

  static Future<void> updateAlarm(AlarmData alarm) async {
    final alarms = getAlarms();
    final index = alarms.indexWhere((a) => a.id == alarm.id);
    if (index != -1) {
      alarms[index] = alarm;
      await saveAlarms(alarms);
    }
  }

  static Future<void> deleteAlarm(int alarmId) async {
    final alarms = getAlarms();
    alarms.removeWhere((a) => a.id == alarmId);
    await saveAlarms(alarms);
  }

  // Settings
  static Future<void> setNotificationsEnabled(bool enabled) async {
    await prefs.setBool('notifications_enabled', enabled);
  }

  static bool getNotificationsEnabled() {
    return prefs.getBool('notifications_enabled') ?? true;
  }

  static Future<void> setFirstLaunch(bool isFirst) async {
    await prefs.setBool('first_launch', isFirst);
  }

  static bool isFirstLaunch() {
    return prefs.getBool('first_launch') ?? true;
  }

  static Future<void> setSyllabusComplete(bool complete) async {
    await prefs.setBool('syllabus_complete', complete);
  }

  static bool isSyllabusComplete() {
    return prefs.getBool('syllabus_complete') ?? false;
  }

  // Wake & Sleep Times
  static Future<void> saveWakeUpTime(int hour, int minute) async {
    await prefs.setInt('wake_up_hour', hour);
    await prefs.setInt('wake_up_minute', minute);
  }

  static Map<String, int>? getWakeUpTime() {
    final hour = prefs.getInt('wake_up_hour');
    final minute = prefs.getInt('wake_up_minute');
    if (hour != null && minute != null) {
      return {'hour': hour, 'minute': minute};
    }
    return null;
  }

  static Future<void> saveSleepTime(int hour, int minute) async {
    await prefs.setInt('sleep_hour', hour);
    await prefs.setInt('sleep_minute', minute);
  }

  static Map<String, int>? getSleepTime() {
    final hour = prefs.getInt('sleep_hour');
    final minute = prefs.getInt('sleep_minute');
    if (hour != null && minute != null) {
      return {'hour': hour, 'minute': minute};
    }
    return null;
  }

  // Session Completion
  static Future<void> markSessionCompleted(String sessionId, DateTime date) async {
    final key = 'session_${date.toIso8601String().split('T')[0]}';
    final sessions = prefs.getStringList(key) ?? [];
    if (!sessions.contains(sessionId)) {
      sessions.add(sessionId);
      await prefs.setStringList(key, sessions);
    }
  }

  static List<String> getCompletedSessions(DateTime date) {
    final key = 'session_${date.toIso8601String().split('T')[0]}';
    return prefs.getStringList(key) ?? [];
  }

  // Clear All Data
  static Future<void> clearAllData() async {
    await prefs.clear();
  }
}
