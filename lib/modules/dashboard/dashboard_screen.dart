import 'package:flutter/material.dart';
import 'package:uas_projekk/core/theme.dart';
import 'package:uas_projekk/modules/quran/quran_screen.dart';
import 'package:uas_projekk/modules/prayer/prayer_screen.dart';
import 'package:uas_projekk/modules/hadith/hadith_screen.dart';
import 'package:uas_projekk/modules/doa/doa_screen.dart';
import 'package:uas_projekk/modules/tools/asmaul_husna_screen.dart';
import 'package:uas_projekk/modules/prayer/prayer_provider.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.microtask(() => context.read<PrayerProvider>().fetchPrayerTimes());
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text("Muslim Companion", 
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppTheme.primaryColor, Color(0xFF004D40)],
                  ),
                ),
                child: Center(
                  child: Opacity(
                    opacity: 0.1,
                    child: Icon(Icons.mosque, size: 150, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPrayerTimeCard(),
                  const SizedBox(height: 24),
                  const Text(
                    "Fitur Utama",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    children: [
                      _buildMenuCard(context, "Al-Qur'an", Icons.menu_book, AppTheme.primaryColor, () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const QuranScreen()));
                      }),
                      _buildMenuCard(context, "Hadith", Icons.library_books, Colors.orange, () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const HadithScreen()));
                      }),
                      _buildMenuCard(context, "Doa", Icons.front_hand, Colors.blue, () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const DoaScreen()));
                      }),
                      _buildMenuCard(context, "Qibla", Icons.explore, Colors.red, () {}),
                      _buildMenuCard(context, "Jadwal Sholat", Icons.access_time, Colors.purple, () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const PrayerScreen()));
                      }),
                      _buildMenuCard(context, "Asmaul Husna", Icons.stars, Colors.amber, () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const AsmaulHusnaScreen()));
                      }),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrayerTimeCard() {
    return Consumer<PrayerProvider>(
      builder: (context, provider, child) {
        final pt = provider.prayerTimes;
        return Card(
          elevation: 4,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                colors: [AppTheme.secondaryColor, Color(0xFFA67C00)],
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Sholat Berikutnya: ${provider.nextPrayerName}", 
                          style: const TextStyle(color: Colors.white, fontSize: 16)),
                        Text(provider.nextPrayerTime != null ? provider.formatTime(provider.nextPrayerTime!) : "--:--", 
                          style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const Icon(Icons.wb_sunny, color: Colors.white, size: 48),
                  ],
                ),
                const Divider(color: Colors.white54),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(provider.locationName, style: const TextStyle(color: Colors.white)),
                    const Text("Hari Ini", style: TextStyle(color: Colors.white)),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMenuCard(BuildContext context, String title, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
