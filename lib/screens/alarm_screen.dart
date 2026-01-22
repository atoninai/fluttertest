import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../config/themes.dart';
import '../models/models.dart';
import '../services/storage_service.dart';
import '../services/notification_service.dart';

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({super.key});

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  List<AlarmData> _alarms = [];

  @override
  void initState() {
    super.initState();
    _loadAlarms();
  }

  void _loadAlarms() {
    setState(() => _alarms = StorageService.getAlarms());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          Expanded(child: _alarms.isEmpty ? _buildEmptyState() : _buildAlarmsList()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Alarms', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
            SizedBox(height: 4),
            Text('Wake up & sleep reminders', style: TextStyle(fontSize: 14, color: AppTheme.textSecondary)),
          ]),
          FloatingActionButton(
            mini: true,
            backgroundColor: AppTheme.primaryColor,
            onPressed: () => _showAddAlarmDialog(),
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(Icons.alarm_off_rounded, size: 64, color: AppTheme.textMuted),
      const SizedBox(height: 16),
      Text('No alarms set', style: TextStyle(fontSize: 18, color: AppTheme.textSecondary)),
      const SizedBox(height: 8),
      Text('Tap + to add wake up or sleep alarms', style: TextStyle(color: AppTheme.textMuted)),
    ]));
  }

  Widget _buildAlarmsList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _alarms.length,
      itemBuilder: (context, index) => FadeInUp(
        delay: Duration(milliseconds: 100 * index),
        child: _AlarmCard(
          alarm: _alarms[index],
          onToggle: (enabled) => _toggleAlarm(_alarms[index], enabled),
          onDelete: () => _deleteAlarm(_alarms[index]),
        ),
      ),
    );
  }

  void _showAddAlarmDialog() {
    TimeOfDay selectedTime = const TimeOfDay(hour: 6, minute: 0);
    AlarmType selectedType = AlarmType.wakeUp;
    String label = '';

    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.cardBackground,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(
              color: AppTheme.textMuted, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 20),
            const Text('Add Alarm', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 24),
            Row(children: [
              Expanded(child: _TypeButton(
                icon: Icons.wb_sunny_rounded, label: 'Wake Up',
                isSelected: selectedType == AlarmType.wakeUp,
                onTap: () => setModalState(() => selectedType = AlarmType.wakeUp),
              )),
              const SizedBox(width: 12),
              Expanded(child: _TypeButton(
                icon: Icons.bedtime_rounded, label: 'Sleep',
                isSelected: selectedType == AlarmType.sleep,
                onTap: () => setModalState(() => selectedType = AlarmType.sleep),
              )),
            ]),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () async {
                final time = await showTimePicker(context: context, initialTime: selectedTime);
                if (time != null) setModalState(() => selectedTime = time);
              },
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(16)),
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Icon(Icons.access_time_rounded, color: AppTheme.primaryColor),
                  const SizedBox(width: 12),
                  Text(selectedTime.format(context), style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                ]),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              onChanged: (v) => label = v,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Label (optional)', fillColor: Colors.white.withOpacity(0.05),
                filled: true, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(width: double.infinity, child: ElevatedButton(
              onPressed: () { _addAlarm(selectedTime, selectedType, label); Navigator.pop(context); },
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryColor, padding: const EdgeInsets.all(16)),
              child: const Text('Save Alarm'),
            )),
          ]),
        ),
      ),
    );
  }

  Future<void> _addAlarm(TimeOfDay time, AlarmType type, String label) async {
    final alarm = AlarmData(
      id: DateTime.now().millisecondsSinceEpoch,
      label: label, time: time, repeatDays: [1,2,3,4,5,6,0], type: type,
    );
    await StorageService.addAlarm(alarm);
    await NotificationService.scheduleAlarm(alarm);
    _loadAlarms();
  }

  Future<void> _toggleAlarm(AlarmData alarm, bool enabled) async {
    final updated = AlarmData(id: alarm.id, label: alarm.label, time: alarm.time,
      repeatDays: alarm.repeatDays, type: alarm.type, isEnabled: enabled);
    await StorageService.updateAlarm(updated);
    if (enabled) { await NotificationService.scheduleAlarm(updated); }
    else { await NotificationService.cancelNotification(alarm.id); }
    _loadAlarms();
  }

  Future<void> _deleteAlarm(AlarmData alarm) async {
    await StorageService.deleteAlarm(alarm.id);
    await NotificationService.cancelNotification(alarm.id);
    _loadAlarms();
  }
}

class _AlarmCard extends StatelessWidget {
  final AlarmData alarm;
  final Function(bool) onToggle;
  final VoidCallback onDelete;
  const _AlarmCard({required this.alarm, required this.onToggle, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final isWakeUp = alarm.type == AlarmType.wakeUp;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground, borderRadius: BorderRadius.circular(16),
        border: Border.all(color: (isWakeUp ? AppTheme.morningColor : AppTheme.nightColor).withOpacity(0.3)),
      ),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: (isWakeUp ? AppTheme.morningColor : AppTheme.nightColor).withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(isWakeUp ? Icons.wb_sunny_rounded : Icons.bedtime_rounded,
            color: isWakeUp ? AppTheme.morningColor : AppTheme.nightColor),
        ),
        const SizedBox(width: 16),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(alarm.time.format(context), style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,
            color: alarm.isEnabled ? Colors.white : AppTheme.textMuted)),
          Text(alarm.label.isEmpty ? (isWakeUp ? 'Wake Up' : 'Sleep') : alarm.label,
            style: TextStyle(color: AppTheme.textSecondary)),
        ])),
        Switch(value: alarm.isEnabled, onChanged: onToggle, activeColor: AppTheme.primaryColor),
        IconButton(icon: const Icon(Icons.delete_outline, color: AppTheme.errorColor), onPressed: onDelete),
      ]),
    );
  }
}

class _TypeButton extends StatelessWidget {
  final IconData icon; final String label; final bool isSelected; final VoidCallback onTap;
  const _TypeButton({required this.icon, required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor.withOpacity(0.2) : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: isSelected ? Border.all(color: AppTheme.primaryColor) : null,
        ),
        child: Column(children: [
          Icon(icon, color: isSelected ? AppTheme.primaryColor : AppTheme.textMuted),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(color: isSelected ? AppTheme.primaryColor : AppTheme.textSecondary)),
        ]),
      ),
    );
  }
}
