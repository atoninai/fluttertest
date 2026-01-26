import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'config/themes.dart';
import 'providers/app_provider.dart';
import 'services/storage_service.dart';
import 'services/notification_service.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: AppTheme.cardBackground,
    systemNavigationBarIconBrightness: Brightness.light,
  ));
  
  // Initialize services
  await StorageService.init();
  await NotificationService.init();
  
  // Request permissions
  await _requestPermissions();
  
  runApp(const SSC26App());
}

Future<void> _requestPermissions() async {
  // Request notification permission
  final notificationStatus = await Permission.notification.request();
  
  if (notificationStatus.isDenied) {
    debugPrint('Notification permission denied');
  }
  
  // Request alarm permission (Android 12+)
  final alarmStatus = await Permission.scheduleExactAlarm.request();
  
  if (alarmStatus.isDenied) {
    debugPrint('Alarm permission denied');
  }
  
  // Request notification permission via the notification service as well
  await NotificationService.requestPermissions();
}

class SSC26App extends StatelessWidget {
  const SSC26App({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppProvider()..init(),
      child: MaterialApp(
        title: 'SSC26 Study Planner',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const SplashScreen(),
      ),
    );
  }
}
