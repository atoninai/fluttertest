import 'package:flutter/material.dart';
import '../models/models.dart';
import '../utils/subject_data.dart';
import '../config/constants.dart';

class RoutineGenerator {
  /// Generates a smart study routine based on:
  /// - Remaining days until SSC
  /// - Incomplete chapters
  /// - Subject priority (heavy/moderate/light)
  /// - Time of day optimization
  
  static List<DailyRoutine> generateRoutine({
    required String sectionId,
    required List<String> completedChapterIds,
  }) {
    final subjects = SubjectData.getSubjectsForSection(sectionId);
    final now = DateTime.now();
    final daysRemaining = AppConstants.sscExamDate.difference(now).inDays;
    
    // Get all incomplete chapters organized by category
    final heavyChapters = <MapEntry<Subject, Chapter>>[];
    final moderateChapters = <MapEntry<Subject, Chapter>>[];
    final lightChapters = <MapEntry<Subject, Chapter>>[];
    
    for (final subject in subjects) {
      for (final chapter in subject.chapters) {
        if (!completedChapterIds.contains(chapter.id)) {
          final entry = MapEntry(subject, chapter);
          switch (subject.category) {
            case SubjectCategory.heavy:
              heavyChapters.add(entry);
              break;
            case SubjectCategory.moderate:
              moderateChapters.add(entry);
              break;
            case SubjectCategory.light:
              lightChapters.add(entry);
              break;
          }
        }
      }
    }
    
    // Shuffle for variety within categories
    heavyChapters.shuffle();
    moderateChapters.shuffle();
    lightChapters.shuffle();
    
    final totalChapters = heavyChapters.length + moderateChapters.length + lightChapters.length;
    
    if (totalChapters == 0 || daysRemaining <= 0) {
      return [];
    }
    
    // Calculate chapters per day (challenging mode when close to exam)
    int chaptersPerDay;
    if (daysRemaining <= 7) {
      chaptersPerDay = 6; // Intensive mode
    } else if (daysRemaining <= 14) {
      chaptersPerDay = 5; // Challenge mode
    } else if (daysRemaining <= 21) {
      chaptersPerDay = 4; // Normal mode
    } else {
      chaptersPerDay = 3; // Relaxed mode
    }
    
    // Generate daily routines
    final routines = <DailyRoutine>[];
    
    int heavyIdx = 0;
    int moderateIdx = 0;
    int lightIdx = 0;
    
    for (int day = 0; day < daysRemaining && (heavyIdx < heavyChapters.length || moderateIdx < moderateChapters.length || lightIdx < lightChapters.length); day++) {
      final date = now.add(Duration(days: day + 1));
      final sessions = <StudySession>[];
      int sessionCount = 0;
      int sessionId = 0;
      
      // Morning sessions - Heavy subjects (2 sessions)
      for (int i = 0; i < 2 && heavyIdx < heavyChapters.length && sessionCount < chaptersPerDay; i++) {
        final entry = heavyChapters[heavyIdx++];
        final startHour = AppConstants.morningStartHour + (i * 2);
        sessions.add(StudySession(
          id: '${date.toIso8601String()}_${sessionId++}',
          subject: entry.key,
          chapter: entry.value,
          date: date,
          startTime: TimeOfDay(hour: startHour, minute: 0),
          endTime: TimeOfDay(hour: startHour + 1, minute: 30),
          sessionType: 'morning',
        ));
        sessionCount++;
      }
      
      // Evening sessions - Moderate subjects (2 sessions)
      for (int i = 0; i < 2 && moderateIdx < moderateChapters.length && sessionCount < chaptersPerDay; i++) {
        final entry = moderateChapters[moderateIdx++];
        final startHour = AppConstants.eveningStartHour + (i * 2);
        sessions.add(StudySession(
          id: '${date.toIso8601String()}_${sessionId++}',
          subject: entry.key,
          chapter: entry.value,
          date: date,
          startTime: TimeOfDay(hour: startHour, minute: 0),
          endTime: TimeOfDay(hour: startHour + 1, minute: 0),
          sessionType: 'evening',
        ));
        sessionCount++;
      }
      
      // Night sessions - Light subjects (2 sessions)
      for (int i = 0; i < 2 && lightIdx < lightChapters.length && sessionCount < chaptersPerDay; i++) {
        final entry = lightChapters[lightIdx++];
        final startHour = AppConstants.nightStartHour + i;
        sessions.add(StudySession(
          id: '${date.toIso8601String()}_${sessionId++}',
          subject: entry.key,
          chapter: entry.value,
          date: date,
          startTime: TimeOfDay(hour: startHour, minute: 0),
          endTime: TimeOfDay(hour: startHour, minute: 45),
          sessionType: 'night',
        ));
        sessionCount++;
      }
      
      // If categories are depleted, fill with remaining chapters
      while (sessionCount < chaptersPerDay) {
        if (heavyIdx < heavyChapters.length) {
          final entry = heavyChapters[heavyIdx++];
          sessions.add(StudySession(
            id: '${date.toIso8601String()}_${sessionId++}',
            subject: entry.key,
            chapter: entry.value,
            date: date,
            startTime: TimeOfDay(hour: 10 + sessionCount, minute: 0),
            endTime: TimeOfDay(hour: 11 + sessionCount, minute: 30),
            sessionType: 'morning',
          ));
          sessionCount++;
        } else if (moderateIdx < moderateChapters.length) {
          final entry = moderateChapters[moderateIdx++];
          sessions.add(StudySession(
            id: '${date.toIso8601String()}_${sessionId++}',
            subject: entry.key,
            chapter: entry.value,
            date: date,
            startTime: TimeOfDay(hour: 14 + sessionCount, minute: 0),
            endTime: TimeOfDay(hour: 15 + sessionCount, minute: 0),
            sessionType: 'evening',
          ));
          sessionCount++;
        } else if (lightIdx < lightChapters.length) {
          final entry = lightChapters[lightIdx++];
          sessions.add(StudySession(
            id: '${date.toIso8601String()}_${sessionId++}',
            subject: entry.key,
            chapter: entry.value,
            date: date,
            startTime: TimeOfDay(hour: 21 + (sessionCount % 2), minute: 0),
            endTime: TimeOfDay(hour: 21 + (sessionCount % 2), minute: 45),
            sessionType: 'night',
          ));
          sessionCount++;
        } else {
          break;
        }
      }
      
      if (sessions.isNotEmpty) {
        routines.add(DailyRoutine(date: date, sessions: sessions));
      }
    }
    
    return routines;
  }
  
  /// Generate revision routine for students who completed syllabus
  static List<DailyRoutine> generateRevisionRoutine({
    required String sectionId,
  }) {
    final subjects = SubjectData.getSubjectsForSection(sectionId);
    final now = DateTime.now();
    final daysRemaining = AppConstants.sscExamDate.difference(now).inDays;
    
    if (daysRemaining <= 0) return [];
    
    final routines = <DailyRoutine>[];
    
    // Cycle through all subjects for revision
    final allChapters = <MapEntry<Subject, Chapter>>[];
    for (final subject in subjects) {
      for (final chapter in subject.chapters) {
        allChapters.add(MapEntry(subject, chapter));
      }
    }
    
    // Sort by subject priority
    allChapters.sort((a, b) {
      final priorityOrder = {
        SubjectCategory.heavy: 0,
        SubjectCategory.moderate: 1,
        SubjectCategory.light: 2,
      };
      return priorityOrder[a.key.category]!.compareTo(priorityOrder[b.key.category]!);
    });
    
    int chapterIdx = 0;
    int chaptersPerDay = 5; // More chapters for revision
    
    for (int day = 0; day < daysRemaining && chapterIdx < allChapters.length; day++) {
      final date = now.add(Duration(days: day + 1));
      final sessions = <StudySession>[];
      int sessionId = 0;
      
      for (int i = 0; i < chaptersPerDay && chapterIdx < allChapters.length; i++) {
        final entry = allChapters[chapterIdx % allChapters.length];
        chapterIdx++;
        
        String sessionType;
        int startHour;
        int durationMinutes;
        
        if (i < 2) {
          sessionType = 'morning';
          startHour = 6 + (i * 2);
          durationMinutes = 60;
        } else if (i < 4) {
          sessionType = 'evening';
          startHour = 15 + ((i - 2) * 2);
          durationMinutes = 45;
        } else {
          sessionType = 'night';
          startHour = 20 + (i - 4);
          durationMinutes = 30;
        }
        
        sessions.add(StudySession(
          id: '${date.toIso8601String()}_${sessionId++}',
          subject: entry.key,
          chapter: entry.value,
          date: date,
          startTime: TimeOfDay(hour: startHour, minute: 0),
          endTime: TimeOfDay(
            hour: startHour + (durationMinutes ~/ 60),
            minute: durationMinutes % 60,
          ),
          sessionType: sessionType,
        ));
      }
      
      // Wrap around for continuous revision
      if (chapterIdx >= allChapters.length) {
        chapterIdx = 0;
      }
      
      if (sessions.isNotEmpty) {
        routines.add(DailyRoutine(date: date, sessions: sessions));
      }
    }
    
    return routines;
  }
  
  /// Get statistics about the routine
  static Map<String, dynamic> getRoutineStats(List<DailyRoutine> routines) {
    if (routines.isEmpty) {
      return {
        'totalDays': 0,
        'totalSessions': 0,
        'totalMinutes': 0,
        'avgSessionsPerDay': 0.0,
        'heavySessions': 0,
        'moderateSessions': 0,
        'lightSessions': 0,
      };
    }
    
    int totalSessions = 0;
    int totalMinutes = 0;
    int heavySessions = 0;
    int moderateSessions = 0;
    int lightSessions = 0;
    
    for (final routine in routines) {
      for (final session in routine.sessions) {
        totalSessions++;
        totalMinutes += session.durationMinutes;
        
        switch (session.subject.category) {
          case SubjectCategory.heavy:
            heavySessions++;
            break;
          case SubjectCategory.moderate:
            moderateSessions++;
            break;
          case SubjectCategory.light:
            lightSessions++;
            break;
        }
      }
    }
    
    return {
      'totalDays': routines.length,
      'totalSessions': totalSessions,
      'totalMinutes': totalMinutes,
      'avgSessionsPerDay': totalSessions / routines.length,
      'heavySessions': heavySessions,
      'moderateSessions': moderateSessions,
      'lightSessions': lightSessions,
    };
  }
}
