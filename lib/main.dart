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

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DoaProvider()),
        ChangeNotifierProvider(create: (_) => QuranProvider()),
        ChangeNotifierProvider(create: (_) => HadithProvider()),
        ChangeNotifierProvider(create: (_) => PrayerProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => DoaHarianProvider()),
        // Add more providers here as modules are restored
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
