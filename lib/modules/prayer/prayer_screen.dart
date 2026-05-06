import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:uas_projekk/modules/prayer/prayer_provider.dart';
import 'package:uas_projekk/core/theme.dart';

class PrayerScreen extends StatefulWidget {
  const PrayerScreen({super.key});

  @override
  State<PrayerScreen> createState() => _PrayerScreenState();
}

class _PrayerScreenState extends State<PrayerScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<PrayerProvider>().fetchPrayerTimes());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Jadwal Sholat", style: GoogleFonts.inter())),
      body: Consumer<PrayerProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.prayerTimes == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Izin lokasi diperlukan", style: GoogleFonts.inter()),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.fetchPrayerTimes(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                    ),
                    child: Text("Coba Lagi", style: GoogleFonts.inter()),
                  )
                ],
              ),
            );
          }

          final pt = provider.prayerTimes!;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildTimeRow("Subuh", pt.fajr, provider),
              _buildTimeRow("Terbit", pt.sunrise, provider),
              _buildTimeRow("Dzuhur", pt.dhuhr, provider),
              _buildTimeRow("Ashar", pt.asr, provider),
              _buildTimeRow("Maghrib", pt.maghrib, provider),
              _buildTimeRow("Isya", pt.isha, provider),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTimeRow(String name, DateTime time, PrayerProvider provider) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(name, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600)),
            Text(
              provider.formatTime(time), 
              style: GoogleFonts.inter(
                fontSize: 18, 
                color: AppTheme.primaryColor, 
                fontWeight: FontWeight.bold
              )
            ),
          ],
        ),
      ),
    );
  }
}
