import 'package:flutter/material.dart';
import '../config/constants.dart';

enum SubjectCategory { heavy, moderate, light }

class Subject {
  final String id;
  final String name;
  final String section;
  final SubjectCategory category;
  final IconData icon;
  final Color color;
  final List<Chapter> chapters;

  const Subject({
    required this.id,
    required this.name,
    required this.section,
    required this.category,
    required this.icon,
    required this.color,
    required this.chapters,
  });

  int get totalChapters => chapters.length;
}

class Chapter {
  final String id;
  final String name;
  final String subjectId;
  final int order;
  final int estimatedMinutes;
  bool isCompleted;

  Chapter({
    required this.id,
    required this.name,
    required this.subjectId,
    required this.order,
    this.estimatedMinutes = 60,
    this.isCompleted = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'subjectId': subjectId,
    'order': order,
    'estimatedMinutes': estimatedMinutes,
    'isCompleted': isCompleted,
  };

  factory Chapter.fromJson(Map<String, dynamic> json) => Chapter(
    id: json['id'],
    name: json['name'],
    subjectId: json['subjectId'],
    order: json['order'],
    estimatedMinutes: json['estimatedMinutes'] ?? 60,
    isCompleted: json['isCompleted'] ?? false,
  );
}

class StudySession {
  final String id;
  final Subject subject;
  final Chapter chapter;
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final String sessionType; // morning, evening, night
  bool isCompleted;

  StudySession({
    required this.id,
    required this.subject,
    required this.chapter,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.sessionType,
    this.isCompleted = false,
  });

  int get durationMinutes {
    return (endTime.hour * 60 + endTime.minute) - 
           (startTime.hour * 60 + startTime.minute);
  }
}

class DailyRoutine {
  final DateTime date;
  final List<StudySession> sessions;
  bool isCompleted;

  DailyRoutine({
    required this.date,
    required this.sessions,
    this.isCompleted = false,
  });

  int get totalMinutes => sessions.fold(0, (sum, s) => sum + s.durationMinutes);
  
  int get completedSessions => sessions.where((s) => s.isCompleted).length;
  
  double get progressPercentage => 
      sessions.isEmpty ? 0 : (completedSessions / sessions.length) * 100;

  bool get isFullyCompleted => 
      sessions.isNotEmpty && sessions.every((s) => s.isCompleted);
      
  bool get isPartiallyCompleted => 
      sessions.any((s) => s.isCompleted) && !isFullyCompleted;
}

class DayProgress {
  final DateTime date;
  final int completedSessions;
  final int totalSessions;
  final ProgressStatus status;

  DayProgress({
    required this.date,
    required this.completedSessions,
    required this.totalSessions,
    required this.status,
  });

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'completedSessions': completedSessions,
    'totalSessions': totalSessions,
    'status': status.name,
  };

  factory DayProgress.fromJson(Map<String, dynamic> json) => DayProgress(
    date: DateTime.parse(json['date']),
    completedSessions: json['completedSessions'],
    totalSessions: json['totalSessions'],
    status: ProgressStatus.values.firstWhere(
      (e) => e.name == json['status'],
      orElse: () => ProgressStatus.none,
    ),
  );
}

enum ProgressStatus { completed, partial, none }

class AlarmData {
  final int id;
  final String label;
  final TimeOfDay time;
  final List<int> repeatDays; // 0 = Sunday, 1 = Monday, etc.
  bool isEnabled;
  final AlarmType type;

  AlarmData({
    required this.id,
    required this.label,
    required this.time,
    required this.repeatDays,
    this.isEnabled = true,
    required this.type,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'label': label,
    'hour': time.hour,
    'minute': time.minute,
    'repeatDays': repeatDays,
    'isEnabled': isEnabled,
    'type': type.name,
  };

  factory AlarmData.fromJson(Map<String, dynamic> json) => AlarmData(
    id: json['id'],
    label: json['label'],
    time: TimeOfDay(hour: json['hour'], minute: json['minute']),
    repeatDays: List<int>.from(json['repeatDays']),
    isEnabled: json['isEnabled'] ?? true,
    type: AlarmType.values.firstWhere(
      (e) => e.name == json['type'],
      orElse: () => AlarmType.wakeUp,
    ),
  );
}

enum AlarmType { wakeUp, sleep, studyReminder }
