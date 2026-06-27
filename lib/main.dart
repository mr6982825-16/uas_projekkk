import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uas_projekk/core/theme.dart';
import 'package:uas_projekk/modules/dashboard/dashboard_screen.dart';
import 'package:uas_projekk/modules/dzikir/doa_provider.dart';
import 'package:uas_projekk/modules/quran/quran_provider.dart';
import 'package:uas_projekk/modules/hadith/hadith_provider.dart';
import 'package:uas_projekk/modules/prayer/prayer_provider.dart';
import 'package:uas_projekk/modules/profile/settings_provider.dart';
import 'package:uas_projekk/modules/dzikir/doa_harian_provider.dart';
import 'package:uas_projekk/modules/dzikir/dzikir_provider.dart';
import 'package:uas_projekk/features/pilar_islam/logic/pilar_islam_provider.dart';

import 'package:uas_projekk/features/debt_tracker/presentation/providers/debt_provider.dart';
import 'package:uas_projekk/features/faraid_calculator/presentation/providers/faraid_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uas_projekk/core/notifications/prayer_notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Initialize Notifications
  final notificationService = PrayerNotificationService();
  notificationService.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DoaProvider()),
        ChangeNotifierProvider(create: (_) => QuranProvider()),
        ChangeNotifierProvider(create: (_) => HadithProvider()),
        ChangeNotifierProvider(create: (_) => PrayerProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => DoaHarianProvider()),
        ChangeNotifierProvider(create: (_) => DzikirProvider()),
        ChangeNotifierProvider(create: (_) => PilarIslamProvider()),
        ChangeNotifierProvider(
          create: (_) {
            var provider = DebtProvider();
            provider.init(); // Initialize Hive box loading
            return provider;
          },
        ),
        ChangeNotifierProvider(create: (_) => FaraidProvider()),
        ChangeNotifierProvider.value(value: notificationService),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, child) {
        return MaterialApp(
          title: 'Pilar Islam',
          debugShowCheckedModeBanner: false,
          theme: settings.isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme,
          home: const DashboardScreen(),
        );
      },
    );
  }
}
