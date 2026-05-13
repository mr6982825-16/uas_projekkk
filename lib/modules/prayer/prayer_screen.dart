import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:uas_projekk/modules/prayer/prayer_provider.dart';
import 'dart:math' as math;

class PrayerTimesScreen extends StatefulWidget {
  const PrayerTimesScreen({super.key});

  @override
  State<PrayerTimesScreen> createState() => _PrayerTimesScreenState();
}

class _PrayerTimesScreenState extends State<PrayerTimesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    Future.microtask(() => context.read<PrayerProvider>().fetchPrayerTimes());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Waktu Shalat",
          style: GoogleFonts.inter(
            color: const Color(0xFF1B4332),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF1B4332),
          labelColor: const Color(0xFF1B4332),
          unselectedLabelColor: Colors.grey,
          indicatorWeight: 3,
          tabs: [
            Tab(
              icon: const Icon(Icons.access_time),
              text: "Jadwal",
            ),
            Tab(
              icon: const Icon(Icons.explore),
              text: "Kiblat",
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildJadwalTab(),
          _buildKiblatTab(),
        ],
      ),
    );
  }

  Widget _buildJadwalTab() {
    return Consumer<PrayerProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF0F4D3A)));
        }

        final times = provider.prayerTimes;
        if (times == null) {
          return const Center(child: Text("Gagal memuat jadwal. Pastikan GPS aktif."));
        }

        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _buildPrayerTile("Subuh", times.fajr),
            _buildPrayerTile("Dzuhur", times.dhuhr),
            _buildPrayerTile("Ashar", times.asr),
            _buildPrayerTile("Maghrib", times.maghrib),
            _buildPrayerTile("Isya", times.isha),
          ],
        );
      },
    );
  }

  Widget _buildPrayerTile(String name, String time) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FBFB),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16)),
          Text(time, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 18, color: const Color(0xFF0F4D3A))),
        ],
      ),
    );
  }

  Widget _buildKiblatTab() {
    return SingleChildScrollView( // Fixes the bottom overflow
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
        child: Column(
          children: [
            Text(
              "Arah Kiblat",
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1B4332),
              ),
            ),
            const SizedBox(height: 50),
            StreamBuilder(
              stream: FlutterQiblah.qiblahStream,
              builder: (context, AsyncSnapshot<QiblahDirection> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Color(0xFF0F4D3A)));
                }

                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }

                final qiblahDirection = snapshot.data;
                if (qiblahDirection == null) {
                  return const Center(child: Text("Data tidak tersedia."));
                }

                return Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outer decorative circle
                    Container(
                      width: 300,
                      height: 300,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFD4E5E1), width: 10),
                      ),
                    ),
                    // Inner compass circle
                    Container(
                      width: 240,
                      height: 240,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey[300]!, width: 15),
                      ),
                    ),
                    // Moving needle
                    Transform.rotate(
                      angle: (qiblahDirection.qiblah * (math.pi / 180) * -1),
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage("https://cdn-icons-png.flaticon.com/512/114/114822.png"), // Placeholder for a compass needle
                            fit: BoxFit.contain,
                          ),
                        ),
                        child: Center(
                          child: Transform.rotate(
                            angle: 0,
                            child: const Icon(
                              Icons.navigation,
                              size: 100,
                              color: Color(0xFF0F4D3A),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 50),
            Text(
              "Hadapkan ponsel Anda ke arah yang benar untuk menemukan kiblat.",
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 10),
            Text(
              "Gerakkan ponsel membentuk angka '8' untuk kalibrasi.",
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: const Color(0xFF0F4D3A),
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
