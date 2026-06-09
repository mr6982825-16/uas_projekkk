import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:uas_projekk/modules/prayer/prayer_provider.dart';

class PrayerTimesScreen extends StatefulWidget {
  const PrayerTimesScreen({super.key});

  @override
  State<PrayerTimesScreen> createState() => _PrayerTimesScreenState();
}

class _PrayerTimesScreenState extends State<PrayerTimesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Stream<QiblahDirection>? _qiblahStream;
  bool _isQiblahLoading = true;
  String? _qiblahError;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    Future.microtask(() {
      context.read<PrayerProvider>().fetchPrayerTimes();
      _initializeQiblah();
    });
  }

  Future<void> _initializeQiblah() async {
    try {
      final locationStatus = await FlutterQiblah.checkLocationStatus();
      if (!locationStatus.enabled) {
        throw 'GPS tidak aktif. Nyalakan GPS lalu coba lagi.';
      }

      if (locationStatus.status == LocationPermission.denied) {
        final permission = await FlutterQiblah.requestPermissions();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          throw 'Izin lokasi ditolak. Aktifkan izin lokasi untuk melihat arah kiblat.';
        }
      }

      if (locationStatus.status == LocationPermission.deniedForever) {
        throw 'Izin lokasi permanen ditolak. Aktifkan izin lokasi di pengaturan perangkat.';
      }

      _qiblahStream = FlutterQiblah.qiblahStream;
      _qiblahError = null;
    } catch (e) {
      _qiblahError = e.toString();
    } finally {
      if (mounted) {
        setState(() {
          _isQiblahLoading = false;
        });
      }
    }
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
            Tab(icon: const Icon(Icons.access_time), text: "Jadwal"),
            Tab(icon: const Icon(Icons.explore), text: "Kiblat"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildJadwalTab(), _buildKiblatTab()],
      ),
    );
  }

  Widget _buildJadwalTab() {
    return Consumer<PrayerProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF0F4D3A)),
          );
        }

        final times = provider.prayerTimes;
        if (times == null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                provider.locationMessage.isNotEmpty
                    ? provider.locationMessage
                    : 'Gagal memuat jadwal. Pastikan GPS aktif.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(color: Colors.redAccent),
              ),
            ),
          );
        }

        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 15),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFEAF4F0),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Lokasi aktif',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: const Color(0xFF0F4D3A),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    provider.currentPosition != null
                        ? 'Lat: ${provider.currentPosition!.latitude.toStringAsFixed(4)} • Lon: ${provider.currentPosition!.longitude.toStringAsFixed(4)}'
                        : 'Menunggu lokasi...',
                    style: GoogleFonts.inter(fontSize: 13, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Arah kiblat terhitung: ${provider.qiblaBearing.toStringAsFixed(1)}° dari utara',
                    style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF0F4D3A)),
                  ),
                ],
              ),
            ),
            _buildPrayerTile('Subuh', times.fajr),
            _buildPrayerTile('Dzuhur', times.dhuhr),
            _buildPrayerTile('Ashar', times.asr),
            _buildPrayerTile('Maghrib', times.maghrib),
            _buildPrayerTile('Isya', times.isha),
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
          Text(
            name,
            style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text(
            time,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: const Color(0xFF0F4D3A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKiblatTab() {
    return SingleChildScrollView(
      // Fixes the bottom overflow
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
            const SizedBox(height: 20),
            Consumer<PrayerProvider>(
              builder: (context, provider, child) {
                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4FAF7),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    provider.hasLocation
                        ? 'Posisi Anda: ${provider.currentPosition!.latitude.toStringAsFixed(4)}, ${provider.currentPosition!.longitude.toStringAsFixed(4)}'
                        : 'Menunggu izin lokasi dan koordinat GPS...',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(color: const Color(0xFF0F4D3A), fontSize: 13),
                  ),
                );
              },
            ),
            const SizedBox(height: 30),
            if (_isQiblahLoading)
              const Center(
                child: CircularProgressIndicator(color: Color(0xFF0F4D3A)),
              )
            else if (_qiblahError != null)
              Center(
                child: Text(
                  _qiblahError!,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(color: Colors.red, fontSize: 14),
                ),
              )
            else if (_qiblahStream == null)
              const Center(child: Text("Tidak dapat memulai arah kiblat."))
            else
              StreamBuilder(
                stream: _qiblahStream,
                builder: (context, AsyncSnapshot<QiblahDirection> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF0F4D3A),
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  }

                  final qiblahDirection = snapshot.data;
                  if (qiblahDirection == null) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          'Menunggu pembacaan sensor kompas...\nGerakkan ponsel perlahan untuk mengaktifkan arah kiblat.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(color: Colors.grey[700], fontSize: 13),
                        ),
                      ),
                    );
                  }

                  return Column(
                    children: [
                      Consumer<PrayerProvider>(
                        builder: (context, provider, child) {
                          return Text(
                            'Sudut kiblat: ${provider.qiblaBearing.toStringAsFixed(1)}°',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF0F4D3A),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      Consumer<PrayerProvider>(
                        builder: (context, provider, child) {
                          final locationLabel = [
                            provider.city.isNotEmpty ? provider.city : null,
                            provider.province.isNotEmpty ? provider.province : null,
                            provider.country.isNotEmpty ? provider.country : null,
                          ].whereType<String>().where((value) => value.isNotEmpty).join(', ');

                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF4FAF7),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              locationLabel.isNotEmpty
                                  ? locationLabel
                                  : 'Menunggu lokasi saat ini...',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                color: const Color(0xFF0F4D3A),
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: 300,
                        height: 300,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 300,
                              height: 300,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFFD4E5E1),
                                  width: 10,
                                ),
                                color: const Color(0xFFF8FBFB),
                              ),
                            ),
                            Container(
                              width: 250,
                              height: 250,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.grey[300]!,
                                  width: 12,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 20,
                              child: Text('U', style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.redAccent)),
                            ),
                            Positioned(
                              bottom: 20,
                              child: Text('S', style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xFF0F4D3A))),
                            ),
                            Positioned(
                              left: 20,
                              child: Text('W', style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xFF0F4D3A))),
                            ),
                            Positioned(
                              right: 20,
                              child: Text('E', style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xFF0F4D3A))),
                            ),
                            Transform.rotate(
                              angle: (qiblahDirection.qiblah * (math.pi / 180) * -1),
                              child: SizedBox(
                                width: 200,
                                height: 200,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      width: 200,
                                      height: 200,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFEAF4F0),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    Positioned(
                                      top: 18,
                                      child: Container(
                                        width: 10,
                                        height: 70,
                                        decoration: const BoxDecoration(
                                          color: Color(0xFF0F4D3A),
                                          borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 18,
                                      child: Container(
                                        width: 10,
                                        height: 70,
                                        decoration: const BoxDecoration(
                                          color: Colors.orangeAccent,
                                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: 16,
                              height: 16,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
                              ),
                            ),
                          ],
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
