class AppConstants {
  // SSC Exam Date - April 21, 2026 (based on official routine)
  static final DateTime sscExamDate = DateTime(2026, 4, 21);
  
  // App Info
  static const String appName = 'SSC26 Study Planner';
  static const String appVersion = '1.0.0';
  
  // Study Session Times
  static const int morningStartHour = 6;
  static const int morningEndHour = 12;
  static const int eveningStartHour = 15;
  static const int eveningEndHour = 19;
  static const int nightStartHour = 20;
  static const int nightEndHour = 23;
  
  // Session Durations (in minutes)
  static const int heavySubjectDuration = 90;
  static const int moderateSubjectDuration = 60;
  static const int lightSubjectDuration = 45;
  
  // Break Durations (in minutes)
  static const int shortBreak = 10;
  static const int longBreak = 30;
  
  // Notification IDs
  static const int morningNotificationId = 1;
  static const int eveningNotificationId = 2;
  static const int nightNotificationId = 3;
  static const int wakeUpAlarmId = 100;
  static const int sleepAlarmId = 101;
  
  // SharedPreferences Keys
  static const String keySelectedSection = 'selected_section';
  static const String keyCompletedChapters = 'completed_chapters';
  static const String keyProgress = 'progress';
  static const String keyRoutine = 'routine';
  static const String keyWakeUpTime = 'wake_up_time';
  static const String keySleepTime = 'sleep_time';
  static const String keyNotificationsEnabled = 'notifications_enabled';
  static const String keyFirstLaunch = 'first_launch';
  static const String keySyllabusComplete = 'syllabus_complete';
  static const String keyDailyProgress = 'daily_progress';
  
  // Widget Constants
  static const String widgetName = 'SSCCountdownWidget';
  static const String widgetGroupId = 'ssc26_widget_group';
  
  // Subject Categories
  static const String categoryHeavy = 'heavy';
  static const String categoryModerate = 'moderate';
  static const String categoryLight = 'light';
}

class Section {
  final String id;
  final String name;
  final String icon;
  final String description;

  const Section({
    required this.id,
    required this.name,
    required this.icon,
    required this.description,
  });

  static const List<Section> sections = [
    Section(
      id: 'science',
      name: 'Science',
      icon: '🔬',
      description: 'Physics, Chemistry, Biology, Higher Math',
    ),
    Section(
      id: 'humanities',
      name: 'Humanities',
      icon: '📚',
      description: 'BGS, Economics, Civics, Geography',
    ),
    Section(
      id: 'commerce',
      name: 'Commerce',
      icon: '💼',
      description: 'Accounting, Finance, Business Studies',
    ),
  ];
}
