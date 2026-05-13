import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uas_projekk/core/theme.dart';
import 'package:uas_projekk/modules/dashboard/dashboard_screen.dart';
import 'package:uas_projekk/modules/doa/doa_provider.dart';
import 'package:uas_projekk/modules/quran/quran_provider.dart';
import 'package:uas_projekk/modules/hadith/hadith_provider.dart';
import 'package:uas_projekk/modules/prayer/prayer_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DoaProvider()),
        ChangeNotifierProvider(create: (_) => QuranProvider()),
        ChangeNotifierProvider(create: (_) => HadithProvider()),
        ChangeNotifierProvider(create: (_) => PrayerProvider()),
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
    return MaterialApp(
      title: 'Muslim Companion',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const DashboardScreen(),
    );
  }
}
