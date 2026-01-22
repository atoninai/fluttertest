import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/themes.dart';
import '../providers/app_provider.dart';
import '../models/models.dart';

class RoutineScreen extends StatefulWidget {
  const RoutineScreen({super.key});

  @override
  State<RoutineScreen> createState() => _RoutineScreenState();
}

class _RoutineScreenState extends State<RoutineScreen> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        return SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(provider),
              _buildDateSelector(provider),
              Expanded(child: _buildSessionsList(provider)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(AppProvider provider) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Study Routine',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
              if (provider.syllabusComplete)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.successColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text('Revision Mode',
                    style: TextStyle(fontSize: 12, color: AppTheme.successColor)),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(provider.syllabusComplete
            ? 'Your personalized revision schedule'
            : 'Smart schedule based on your progress',
            style: TextStyle(fontSize: 14, color: AppTheme.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildDateSelector(AppProvider provider) {
    final dates = List.generate(14, (i) => DateTime.now().add(Duration(days: i)));
    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: dates.length,
        itemBuilder: (context, index) {
          final date = dates[index];
          final isSelected = _isSameDay(date, _selectedDate);
          return GestureDetector(
            onTap: () => setState(() => _selectedDate = date),
            child: Container(
              width: 55, margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.primaryColor : AppTheme.cardBackground,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(['Mon','Tue','Wed','Thu','Fri','Sat','Sun'][date.weekday-1],
                    style: TextStyle(fontSize: 11, color: isSelected ? Colors.white70 : AppTheme.textSecondary)),
                  const SizedBox(height: 6),
                  Text('${date.day}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : Colors.white)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;

  DailyRoutine? _getRoutineForDay(AppProvider provider, DateTime day) {
    try { return provider.routines.firstWhere((r) => _isSameDay(r.date, day)); }
    catch (e) { return null; }
  }

  Widget _buildSessionsList(AppProvider provider) {
    final routine = _getRoutineForDay(provider, _selectedDate);
    if (routine == null || routine.sessions.isEmpty) {
      return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.event_available_rounded, size: 60, color: AppTheme.textMuted),
        const SizedBox(height: 12),
        Text('No sessions scheduled', style: TextStyle(color: AppTheme.textSecondary)),
      ]));
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: routine.sessions.map((session) {
        final isCompleted = provider.isSessionCompleted(session.id, session.date);
        return _SessionCard(session: session, isCompleted: isCompleted,
          onComplete: () => provider.completeSession(session.id, session.date));
      }).toList(),
    );
  }
}

class _SessionCard extends StatelessWidget {
  final StudySession session;
  final bool isCompleted;
  final VoidCallback onComplete;
  const _SessionCard({required this.session, required this.isCompleted, required this.onComplete});

  @override
  Widget build(BuildContext context) {
    final color = session.sessionType == 'morning' ? AppTheme.morningColor
        : session.sessionType == 'evening' ? AppTheme.eveningColor : AppTheme.nightColor;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground, borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(children: [
        Column(children: [
          Text(session.startTime.format(context), style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
          Container(width: 2, height: 16, margin: const EdgeInsets.symmetric(vertical: 4), color: color.withOpacity(0.3)),
          Text(session.endTime.format(context), style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
        ]),
        const SizedBox(width: 16),
        Container(width: 3, height: 50, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 16),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(session.subject.name, style: TextStyle(fontWeight: FontWeight.w600,
            color: isCompleted ? AppTheme.textSecondary : Colors.white)),
          const SizedBox(height: 4),
          Text(session.chapter.name, style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
            maxLines: 1, overflow: TextOverflow.ellipsis),
        ])),
        IconButton(
          onPressed: isCompleted ? null : onComplete,
          icon: Icon(isCompleted ? Icons.check_circle_rounded : Icons.circle_outlined,
            color: isCompleted ? AppTheme.successColor : AppTheme.textMuted, size: 28),
        ),
      ]),
    );
  }
}
