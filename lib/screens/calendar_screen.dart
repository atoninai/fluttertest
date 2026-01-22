import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:animate_do/animate_do.dart';
import '../config/themes.dart';
import '../config/constants.dart';
import '../providers/app_provider.dart';
import '../models/models.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        final daysRemaining = provider.daysRemaining;

        return SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                FadeInDown(
                  child: _buildHeader(daysRemaining),
                ),
                
                // Calendar
                FadeInUp(
                  delay: const Duration(milliseconds: 100),
                  child: _buildCalendar(provider),
                ),
                
                // Legend
                FadeInUp(
                  delay: const Duration(milliseconds: 200),
                  child: _buildLegend(),
                ),
                
                // Selected Day Details
                if (_selectedDay != null)
                  FadeInUp(
                    delay: const Duration(milliseconds: 300),
                    child: _buildDayDetails(provider),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(int daysRemaining) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Activity Calendar',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.calendar_today_rounded,
                size: 16,
                color: AppTheme.warningColor,
              ),
              const SizedBox(width: 8),
              Text(
                '$daysRemaining days left until SSC',
                style: const TextStyle(
                  color: AppTheme.warningColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar(AppProvider provider) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TableCalendar(
        firstDay: DateTime(2024, 1, 1),
        lastDay: AppConstants.sscExamDate.add(const Duration(days: 30)),
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
        },
        onFormatChanged: (format) {
          setState(() {
            _calendarFormat = format;
          });
        },
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
        },
        calendarStyle: CalendarStyle(
          outsideDaysVisible: true,
          defaultTextStyle: const TextStyle(color: Colors.white),
          weekendTextStyle: const TextStyle(color: Colors.white70),
          outsideTextStyle: TextStyle(color: AppTheme.textMuted),
          todayDecoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.3),
            shape: BoxShape.circle,
            border: Border.all(color: AppTheme.primaryColor, width: 2),
          ),
          todayTextStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          selectedDecoration: const BoxDecoration(
            color: AppTheme.primaryColor,
            shape: BoxShape.circle,
          ),
          selectedTextStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          markerDecoration: const BoxDecoration(
            color: AppTheme.successColor,
            shape: BoxShape.circle,
          ),
        ),
        headerStyle: HeaderStyle(
          titleCentered: true,
          formatButtonVisible: true,
          formatButtonDecoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          formatButtonTextStyle: const TextStyle(color: AppTheme.primaryColor),
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          leftChevronIcon: const Icon(
            Icons.chevron_left_rounded,
            color: Colors.white,
          ),
          rightChevronIcon: const Icon(
            Icons.chevron_right_rounded,
            color: Colors.white,
          ),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: TextStyle(color: AppTheme.textSecondary),
          weekendStyle: TextStyle(color: AppTheme.textSecondary),
        ),
        calendarBuilders: CalendarBuilders(
          markerBuilder: (context, day, events) {
            final progress = provider.getProgressForDate(day);
            if (progress != null) {
              return Positioned(
                bottom: 1,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _getProgressColor(progress.status),
                    shape: BoxShape.circle,
                  ),
                ),
              );
            }
            
            // Check if this day has scheduled sessions
            final routine = _getRoutineForDay(provider, day);
            if (routine != null && routine.sessions.isNotEmpty) {
              return Positioned(
                bottom: 1,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppTheme.scheduledColor,
                    shape: BoxShape.circle,
                  ),
                ),
              );
            }
            return null;
          },
          defaultBuilder: (context, day, focusedDay) {
            // Highlight SSC exam day
            if (isSameDay(day, AppConstants.sscExamDate)) {
              return Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  gradient: AppTheme.accentGradient,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  '${day.day}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }
            
            final progress = provider.getProgressForDate(day);
            if (progress != null && progress.status == ProgressStatus.completed) {
              return Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppTheme.successColor.withOpacity(0.3),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.successColor,
                    width: 1,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  '${day.day}',
                  style: const TextStyle(color: Colors.white),
                ),
              );
            }
            
            if (progress != null && progress.status == ProgressStatus.partial) {
              return Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppTheme.warningColor.withOpacity(0.3),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.warningColor,
                    width: 1,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  '${day.day}',
                  style: const TextStyle(color: Colors.white),
                ),
              );
            }
            
            return null;
          },
        ),
      ),
    );
  }

  Color _getProgressColor(ProgressStatus status) {
    switch (status) {
      case ProgressStatus.completed:
        return AppTheme.successColor;
      case ProgressStatus.partial:
        return AppTheme.warningColor;
      case ProgressStatus.none:
        return AppTheme.scheduledColor;
    }
  }

  DailyRoutine? _getRoutineForDay(AppProvider provider, DateTime day) {
    try {
      return provider.routines.firstWhere(
        (r) => isSameDay(r.date, day),
      );
    } catch (e) {
      return null;
    }
  }

  Widget _buildLegend() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _LegendItem(
            color: AppTheme.successColor,
            label: 'Completed',
          ),
          const SizedBox(width: 16),
          _LegendItem(
            color: AppTheme.warningColor,
            label: 'Partial',
          ),
          const SizedBox(width: 16),
          _LegendItem(
            color: AppTheme.scheduledColor,
            label: 'Scheduled',
          ),
        ],
      ),
    );
  }

  Widget _buildDayDetails(AppProvider provider) {
    final routine = _getRoutineForDay(provider, _selectedDay!);
    final progress = provider.getProgressForDate(_selectedDay!);
    final isToday = isSameDay(_selectedDay!, DateTime.now());
    final isExamDay = isSameDay(_selectedDay!, AppConstants.sscExamDate);

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isExamDay 
                      ? AppTheme.accentColor.withOpacity(0.2)
                      : AppTheme.primaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isExamDay ? Icons.star_rounded : Icons.calendar_today_rounded,
                  color: isExamDay ? AppTheme.accentColor : AppTheme.primaryColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _formatDate(_selectedDay!),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    if (isToday)
                      const Text(
                        'Today',
                        style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    if (isExamDay)
                      const Text(
                        '🎯 SSC Exam Day!',
                        style: TextStyle(
                          color: AppTheme.accentColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),
              ),
              if (progress != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getProgressColor(progress.status).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${progress.completedSessions}/${progress.totalSessions}',
                    style: TextStyle(
                      color: _getProgressColor(progress.status),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          
          if (routine != null && routine.sessions.isNotEmpty) ...[
            const SizedBox(height: 20),
            const Text(
              'Sessions',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            ...routine.sessions.take(3).map((session) {
              final isCompleted = provider.isSessionCompleted(
                session.id,
                session.date,
              );
              return _MiniSessionCard(session: session, isCompleted: isCompleted);
            }),
            if (routine.sessions.length > 3)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  '+${routine.sessions.length - 3} more sessions',
                  style: TextStyle(color: AppTheme.textSecondary),
                ),
              ),
          ] else if (!isExamDay) ...[
            const SizedBox(height: 20),
            Center(
              child: Text(
                'No sessions scheduled',
                style: TextStyle(color: AppTheme.textSecondary),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    final days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return '${days[date.weekday % 7]}, ${months[date.month - 1]} ${date.day}';
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _MiniSessionCard extends StatelessWidget {
  final StudySession session;
  final bool isCompleted;

  const _MiniSessionCard({
    required this.session,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(
            isCompleted 
                ? Icons.check_circle_rounded 
                : Icons.circle_outlined,
            color: isCompleted ? AppTheme.successColor : AppTheme.textMuted,
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  session.subject.name,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isCompleted ? AppTheme.textSecondary : Colors.white,
                  ),
                ),
                Text(
                  session.chapter.name,
                  style: TextStyle(
                    fontSize: 11,
                    color: AppTheme.textMuted,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Text(
            session.startTime.format(context),
            style: TextStyle(
              fontSize: 11,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
