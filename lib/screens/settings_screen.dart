import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/themes.dart';
import '../providers/app_provider.dart';
import '../services/storage_service.dart';
import '../services/notification_service.dart';
import 'section_select_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _notificationsEnabled = StorageService.getNotificationsEnabled();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: SafeArea(
          child: Column(children: [
            _buildHeader(context),
            Expanded(child: ListView(padding: const EdgeInsets.all(16), children: [
              _buildSection('Notifications', [
                _SettingsTile(
                  icon: Icons.notifications_rounded, title: 'Study Reminders',
                  subtitle: 'Get notified before study sessions',
                  trailing: Switch(value: _notificationsEnabled, onChanged: _toggleNotifications,
                    activeColor: AppTheme.primaryColor),
                ),
              ]),
              const SizedBox(height: 20),
              _buildSection('Study', [
                _SettingsTile(
                  icon: Icons.refresh_rounded, title: 'Change Section',
                  subtitle: 'Switch between Science, Humanities, Commerce',
                  onTap: () => _showChangeSectionDialog(context),
                ),
                _SettingsTile(
                  icon: Icons.auto_awesome_rounded, title: 'Regenerate Routine',
                  subtitle: 'Create a new study schedule',
                  onTap: () => _regenerateRoutine(context),
                ),
              ]),
              const SizedBox(height: 20),
              _buildSection('Data', [
                _SettingsTile(
                  icon: Icons.delete_forever_rounded, title: 'Reset All Data',
                  subtitle: 'Clear all progress and settings', titleColor: AppTheme.errorColor,
                  onTap: () => _showResetDialog(context),
                ),
              ]),
              const SizedBox(height: 20),
              _buildSection('About', [
                _SettingsTile(icon: Icons.info_outline_rounded, title: 'Version', subtitle: '1.0.0'),
                _SettingsTile(icon: Icons.school_rounded, title: 'SSC26 Study Planner',
                  subtitle: 'Made for SSC 2026 students'),
              ]),
            ])),
          ]),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_rounded),
          style: IconButton.styleFrom(backgroundColor: AppTheme.cardBackground, foregroundColor: Colors.white),
        ),
        const SizedBox(width: 16),
        const Text('Settings', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
      ]),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.only(left: 4, bottom: 12),
        child: Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textSecondary)),
      ),
      Container(
        decoration: BoxDecoration(color: AppTheme.cardBackground, borderRadius: BorderRadius.circular(16)),
        child: Column(children: children),
      ),
    ]);
  }

  Future<void> _toggleNotifications(bool enabled) async {
    await StorageService.setNotificationsEnabled(enabled);
    if (!enabled) await NotificationService.cancelAllNotifications();
    setState(() => _notificationsEnabled = enabled);
  }

  void _showChangeSectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardBackground,
        title: const Text('Change Section?', style: TextStyle(color: Colors.white)),
        content: const Text('This will reset your chapter progress.', style: TextStyle(color: AppTheme.textSecondary)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (_) => const SectionSelectScreen()), (route) => false);
            },
            child: const Text('Change'),
          ),
        ],
      ),
    );
  }

  Future<void> _regenerateRoutine(BuildContext context) async {
    final provider = context.read<AppProvider>();
    await provider.generateAndScheduleRoutine();
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Routine regenerated!'), backgroundColor: AppTheme.successColor));
    }
  }

  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardBackground,
        title: const Text('Reset All Data?', style: TextStyle(color: Colors.white)),
        content: const Text('This cannot be undone.', style: TextStyle(color: AppTheme.textSecondary)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.errorColor),
            onPressed: () async {
              await context.read<AppProvider>().resetData();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: (_) => const SectionSelectScreen()), (route) => false);
              }
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon; final String title; final String subtitle;
  final Widget? trailing; final VoidCallback? onTap; final Color? titleColor;
  const _SettingsTile({required this.icon, required this.title, required this.subtitle,
    this.trailing, this.onTap, this.titleColor});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: (titleColor ?? AppTheme.primaryColor).withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: titleColor ?? AppTheme.primaryColor, size: 22),
      ),
      title: Text(title, style: TextStyle(color: titleColor ?? Colors.white, fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle, style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
      trailing: trailing ?? (onTap != null ? Icon(Icons.chevron_right_rounded, color: AppTheme.textMuted) : null),
    );
  }
}
