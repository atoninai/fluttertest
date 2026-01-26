import 'package:flutter/material.dart';
import '../config/constants.dart';
import '../models/models.dart';
import '../services/storage_service.dart';
import '../services/routine_generator.dart';
import '../services/notification_service.dart';
import '../utils/subject_data.dart';

class AppProvider extends ChangeNotifier {
  String? _selectedSection;
  List<Subject> _subjects = [];
  List<String> _completedChapterIds = [];
  List<DailyRoutine> _routines = [];
  bool _isLoading = false;
  bool _syllabusComplete = false;
  Map<DateTime, DayProgress> _dayProgress = {};

  // Getters
  String? get selectedSection => _selectedSection;
  List<Subject> get subjects => _subjects;
  List<String> get completedChapterIds => _completedChapterIds;
  List<DailyRoutine> get routines => _routines;
  bool get isLoading => _isLoading;
  bool get syllabusComplete => _syllabusComplete;
  Map<DateTime, DayProgress> get dayProgress => _dayProgress;

  // Computed properties
  int get totalChapters => _subjects.fold(0, (sum, s) => sum + s.chapters.length);
  int get completedChaptersCount => _completedChapterIds.length;
  double get progressPercentage => totalChapters == 0 
      ? 0 
      : (completedChaptersCount / totalChapters) * 100;
  
  int get daysRemaining {
    final now = DateTime.now();
    return AppConstants.sscExamDate.difference(now).inDays;
  }

  DailyRoutine? get todayRoutine {
    final today = DateTime.now();
    try {
      return _routines.firstWhere((r) =>
          r.date.year == today.year &&
          r.date.month == today.month &&
          r.date.day == today.day);
    } catch (e) {
      return null;
    }
  }

  // Initialize from storage
  Future<void> init() async {
    _isLoading = true;
    notifyListeners();

    _selectedSection = StorageService.getSelectedSection();
    _completedChapterIds = StorageService.getCompletedChapters();
    _syllabusComplete = StorageService.isSyllabusComplete();
    _dayProgress = await StorageService.getAllDayProgress();

    if (_selectedSection != null) {
      _subjects = SubjectData.getSubjectsForSection(_selectedSection!);
      _generateRoutine();
    }

    _isLoading = false;
    notifyListeners();
  }

  // Select section
  Future<void> selectSection(String sectionId) async {
    _selectedSection = sectionId;
    _subjects = SubjectData.getSubjectsForSection(sectionId);
    _completedChapterIds = [];
    
    await StorageService.saveSelectedSection(sectionId);
    await StorageService.saveCompletedChapters(_completedChapterIds);
    
    notifyListeners();
  }

  // Toggle chapter completion
  Future<void> toggleChapter(String chapterId) async {
    if (_completedChapterIds.contains(chapterId)) {
      _completedChapterIds.remove(chapterId);
      await StorageService.markChapterIncomplete(chapterId);
    } else {
      _completedChapterIds.add(chapterId);
      await StorageService.markChapterCompleted(chapterId);
    }
    
    // Check if syllabus is complete
    _syllabusComplete = completedChaptersCount >= totalChapters;
    await StorageService.setSyllabusComplete(_syllabusComplete);
    
    notifyListeners();
  }

  // Generate routine
  void _generateRoutine() {
    if (_syllabusComplete) {
      _routines = RoutineGenerator.generateRevisionRoutine(
        sectionId: _selectedSection!,
      );
    } else {
      _routines = RoutineGenerator.generateRoutine(
        sectionId: _selectedSection!,
        completedChapterIds: _completedChapterIds,
      );
    }
  }

  // Generate routine and schedule notifications
  Future<void> generateAndScheduleRoutine() async {
    _isLoading = true;
    notifyListeners();

    _generateRoutine();
    
    // Schedule notifications
    if (StorageService.getNotificationsEnabled()) {
      await NotificationService.scheduleDailyRoutineNotifications(_routines);
    }

    _isLoading = false;
    notifyListeners();
  }

  // Mark session as completed
  Future<void> completeSession(String sessionId, DateTime date) async {
    await StorageService.markSessionCompleted(sessionId, date);
    
    // Update day progress
    final completedSessions = StorageService.getCompletedSessions(date);
    final todayRoutine = _routines.firstWhere(
      (r) => r.date.year == date.year && 
             r.date.month == date.month && 
             r.date.day == date.day,
      orElse: () => DailyRoutine(date: date, sessions: []),
    );

    final totalSessions = todayRoutine.sessions.length;
    final completedCount = completedSessions.length;
    
    ProgressStatus status;
    if (completedCount >= totalSessions && totalSessions > 0) {
      status = ProgressStatus.completed;
    } else if (completedCount > 0) {
      status = ProgressStatus.partial;
    } else {
      status = ProgressStatus.none;
    }

    final progress = DayProgress(
      date: date,
      completedSessions: completedCount,
      totalSessions: totalSessions,
      status: status,
    );

    await StorageService.saveDayProgress(progress);
    _dayProgress[DateTime(date.year, date.month, date.day)] = progress;

    notifyListeners();
  }

  // Check if session is completed
  bool isSessionCompleted(String sessionId, DateTime date) {
    return StorageService.getCompletedSessions(date).contains(sessionId);
  }

  // Get progress for a specific date
  DayProgress? getProgressForDate(DateTime date) {
    final key = DateTime(date.year, date.month, date.day);
    return _dayProgress[key];
  }

  // Reset all data
  Future<void> resetData() async {
    await StorageService.clearAllData();
    _selectedSection = null;
    _subjects = [];
    _completedChapterIds = [];
    _routines = [];
    _syllabusComplete = false;
    _dayProgress = {};
    notifyListeners();
  }
}
