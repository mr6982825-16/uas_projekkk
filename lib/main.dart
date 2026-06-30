import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
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
import 'package:intl/date_symbol_data_local.dart';
import 'package:uas_projekk/core/notifications/prayer_notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  runApp(const InitialApp());
}

class InitialApp extends StatelessWidget {
  const InitialApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pilar Islam',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      // 1. Initialize Hive
      await Hive.initFlutter();

      // 2. Initialize Notifications
      final notificationService = PrayerNotificationService();
      await notificationService.init();

      // Artificial delay to let the user read the spiritual messages
      await Future.delayed(const Duration(milliseconds: 2500));

      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                MainApp(notificationService: notificationService),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      }
    } catch (e) {
      debugPrint("Error initializing app: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F4D3A), Color(0xFF1B4332)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFD4AF37).withOpacity(0.4),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF000000).withOpacity(0.15),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.mosque_outlined,
                          size: 55,
                          color: Color(0xFFD4AF37),
                        ),
                      ),
                    ),
                    const SizedBox(height: 35),
                    Text(
                      "Selamat Datang di Aplikasi Islam",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        "Aplikasi untuk mendukung aktifitas spiritual harian anda",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.7),
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 50,
                left: 0,
                right: 0,
                child: Center(
                  child: Column(
                    children: [
                      const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Color(0xFFD4AF37),
                          strokeWidth: 2.5,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "Menyiapkan aplikasi...",
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MainApp extends StatelessWidget {
  final PrayerNotificationService notificationService;
  const MainApp({super.key, required this.notificationService});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
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
            provider.init();
            return provider;
          },
        ),
        ChangeNotifierProvider(create: (_) => FaraidProvider()),
        ChangeNotifierProvider.value(value: notificationService),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settings, child) {
          return MaterialApp(
            title: 'Pilar Islam',
            debugShowCheckedModeBanner: false,
            theme: settings.isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme,
            home: const DashboardScreen(),
          );
        },
      ),
    );
  }
}
