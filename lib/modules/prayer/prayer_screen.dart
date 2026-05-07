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
    return Consumer<PrayerProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Jadwal Sholat", style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
            actions: [
              IconButton(
                onPressed: () => provider.toggleMute(),
                icon: Icon(
                  provider.isMuted ? Icons.notifications_off_outlined : Icons.notifications_active_outlined,
                  color: provider.isMuted ? Colors.grey : AppTheme.primaryColor,
                ),
              ),
            ],
          ),
          body: provider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : provider.prayerTimes == null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.location_off_outlined, size: 64, color: Colors.grey),
                          const SizedBox(height: 16),
                          Text("Izin lokasi diperlukan untuk jadwal akurat", style: GoogleFonts.inter(color: Colors.grey)),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () => provider.fetchPrayerTimes(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            ),
                            child: Text("Coba Lagi", style: GoogleFonts.inter()),
                          )
                        ],
                      ),
                    )
                    : ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          // Next Prayer Banner
                          Container(
                            margin: const EdgeInsets.only(bottom: 24),
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [AppTheme.primaryColor, AppTheme.primaryColor.withOpacity(0.8)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.primaryColor.withOpacity(0.3),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Sholat Berikutnya: ${provider.nextPrayerName}",
                                      style: GoogleFonts.inter(color: Colors.white70, fontSize: 14),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      provider.nextPrayerTime != null ? provider.formatTime(provider.nextPrayerTime!) : "--:--",
                                      style: GoogleFonts.inter(
                                        color: Colors.white,
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      provider.locationName,
                                      style: GoogleFonts.inter(color: Colors.white60, fontSize: 12),
                                    ),
                                  ],
                                ),
                                const Icon(Icons.wb_sunny_outlined, color: Colors.white, size: 48),
                              ],
                            ),
                          ),
                          _buildTimeRow("Subuh", provider.prayerTimes!.fajr, provider),
                          _buildTimeRow("Terbit", provider.prayerTimes!.sunrise, provider),
                          _buildTimeRow("Dzuhur", provider.prayerTimes!.dhuhr, provider),
                          _buildTimeRow("Ashar", provider.prayerTimes!.asr, provider),
                          _buildTimeRow("Maghrib", provider.prayerTimes!.maghrib, provider),
                          _buildTimeRow("Isya", provider.prayerTimes!.isha, provider),
                        ],
                      ),
          );
        },
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
