import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/foundation.dart' show kIsWeb;
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
  StreamSubscription<QiblahDirection>? _qiblahSubscription;
  bool _isQiblahLoading = true;
  String? _qiblahError;
  bool _hasSensorSupport = true;

  // Smoothing & anti-wrapping fields
  double _lastDirection = 0.0;
  double _continuousDirection = 0.0;
  double _smoothDirection = 0.0;
  double? _currentDirection;
  double? _currentQiblah;
  bool _isFirstEvent = true;

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
      if (kIsWeb) {
        throw 'Fitur kompas kiblat memerlukan sensor fisik yang hanya tersedia di aplikasi Android/iOS.';
      }

      // Check sensor support on Android
      if (Platform.isAndroid) {
        final support = await FlutterQiblah.androidDeviceSensorSupport();
        if (support == false) {
          setState(() {
            _hasSensorSupport = false;
          });
          throw 'Ponsel Anda tidak memiliki sensor magnetik (kompas) yang diperlukan untuk kompas kiblat.';
        }
      }

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

      _qiblahSubscription?.cancel();
      _qiblahSubscription = _qiblahStream?.listen(
        (qiblahDirection) {
          _onQiblahDirectionChanged(qiblahDirection);
        },
        onError: (error) {
          setState(() {
            _qiblahError = error.toString();
          });
        },
      );
    } catch (e) {
      if (e.toString().contains('MissingPluginException')) {
        _qiblahError = 'Fitur kompas kiblat hanya didukung pada perangkat fisik Android/iOS.';
      } else {
        _qiblahError = e.toString();
      }
    } finally {
      if (mounted) {
        setState(() {
          _isQiblahLoading = false;
        });
      }
    }
  }

  void _onQiblahDirectionChanged(QiblahDirection data) {
    if (!mounted) return;

    final newDirection = data.direction;

    if (_isFirstEvent) {
      _lastDirection = newDirection;
      _continuousDirection = newDirection;
      _smoothDirection = newDirection;
      _isFirstEvent = false;
    } else {
      double diff = newDirection - _lastDirection;
      if (diff < -180) {
        diff += 360;
      } else if (diff > 180) {
        diff -= 360;
      }
      _continuousDirection += diff;
      _lastDirection = newDirection;

      // Low pass filter: alpha = 0.15 for smooth but responsive movement
      _smoothDirection = _smoothDirection + 0.15 * (_continuousDirection - _smoothDirection);
    }

    final absoluteQiblah = (data.qiblah + data.direction) % 360;

    setState(() {
      _currentDirection = _smoothDirection;
      _currentQiblah = absoluteQiblah;
    });
  }

  void _showCalibrationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF141C19),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: const Color(0xFF52D395).withOpacity(0.2), width: 1.5),
          ),
          title: Row(
            children: [
              const Icon(Icons.compass_calibration, color: Color(0xFF52D395)),
              const SizedBox(width: 10),
              Text(
                "Kalibrasi Kompas",
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFF52D395).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.gesture,
                    size: 60,
                    color: Color(0xFF52D395),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Cara Menghilangkan Gangguan & Kalibrasi:",
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                "1. Pegang ponsel Anda dengan kokoh di tangan.\n"
                "2. Gerakkan/putar ponsel di udara membentuk lintasan angka '8' (infinity ♾️) secara berulang.\n"
                "3. Jauhkan ponsel dari benda logam, casing bermagnet, atau barang elektronik lain (laptop, speaker) agar arah lebih akurat.",
                style: GoogleFonts.inter(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                "Tutup",
                style: GoogleFonts.inter(
                  color: const Color(0xFF52D395),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _qiblahSubscription?.cancel();
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
          Expanded(
            child: Text(
              name,
              style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 10),
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
    return Container(
      color: const Color(0xFF141C19),
      constraints: const BoxConstraints.expand(),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
          child: Column(
            children: [
              Text(
                "Arah Kiblat",
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Consumer<PrayerProvider>(
                builder: (context, provider, child) {
                  return Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: Text(
                      provider.hasLocation
                          ? 'Posisi Anda: ${provider.currentPosition!.latitude.toStringAsFixed(4)}, ${provider.currentPosition!.longitude.toStringAsFixed(4)}'
                          : 'Menunggu izin lokasi dan koordinat GPS...',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(color: const Color(0xFF52D395), fontSize: 13),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              Consumer<PrayerProvider>(
                builder: (context, provider, child) {
                  if (!provider.hasLocation) return const SizedBox.shrink();
                  final locationLabel = [
                    provider.city.isNotEmpty ? provider.city : null,
                    provider.province.isNotEmpty ? provider.province : null,
                    provider.country.isNotEmpty ? provider.country : null,
                  ].whereType<String>().where((value) => value.isNotEmpty).join(', ');

                  return Column(
                    children: [
                      Text(
                        'Sudut kiblat: ${provider.qiblaBearing.toStringAsFixed(1)}°',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF52D395),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white.withOpacity(0.1)),
                        ),
                        child: Text(
                          locationLabel.isNotEmpty ? locationLabel : 'Menghitung lokasi...',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 25),
              if (_isQiblahLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: CircularProgressIndicator(color: Color(0xFF52D395)),
                  ),
                )
              else if (_qiblahError != null || _qiblahStream == null)
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.redAccent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.redAccent.withOpacity(0.3)),
                      ),
                      child: Text(
                        _qiblahError ?? "Sensor kompas tidak terdeteksi pada perangkat ini.",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(color: Colors.red[300], fontSize: 13),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Consumer<PrayerProvider>(
                      builder: (context, provider, child) {
                        final bearing = provider.hasLocation ? provider.qiblaBearing : 295.0;
                        return LayoutBuilder(
                          builder: (context, constraints) {
                            final compassSize = math.min(250.0, constraints.maxWidth);
                            final centerOffset = compassSize / 2;
                            final iconRadius = (compassSize / 2 - 12) - 18.0;
                            final iconSize = compassSize * 0.14;

                            return SizedBox(
                              width: compassSize,
                              height: compassSize,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  CustomPaint(
                                    size: Size(compassSize, compassSize),
                                    painter: KiblatCompassPainter(
                                      qiblaBearing: bearing,
                                    ),
                                  ),
                                  Positioned(
                                    left: centerOffset + iconRadius * math.cos((bearing - 90) * math.pi / 180) - (iconSize / 2),
                                    top: centerOffset + iconRadius * math.sin((bearing - 90) * math.pi / 180) - (iconSize / 2),
                                    child: Transform.rotate(
                                      angle: bearing * math.pi / 180,
                                      child: Image.asset(
                                        'assets/icon/kaaba.png',
                                        width: iconSize,
                                        height: iconSize,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Text(
                                            '🕋',
                                            style: TextStyle(fontSize: iconSize * 0.7),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                )
              else if (_currentDirection == null || _currentQiblah == null)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Column(
                      children: [
                        const CircularProgressIndicator(
                          color: Color(0xFF52D395),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          'Menunggu pembacaan sensor kompas...\nGerakkan ponsel perlahan untuk mengaktifkan arah kiblat.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(color: Colors.grey[400], fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                )
              else
                LayoutBuilder(
                  builder: (context, constraints) {
                    final compassSize = math.min(300.0, constraints.maxWidth);
                    final centerOffset = compassSize / 2;
                    final iconRadius = (compassSize / 2 - 12) - 18.0;
                    final iconSize = compassSize * 0.15;

                    return Transform.rotate(
                      angle: (-_currentDirection! * (math.pi / 180)),
                      child: SizedBox(
                        width: compassSize,
                        height: compassSize,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CustomPaint(
                              size: Size(compassSize, compassSize),
                              painter: KiblatCompassPainter(
                                qiblaBearing: _currentQiblah!,
                              ),
                            ),
                            Positioned(
                              left: centerOffset + iconRadius * math.cos((_currentQiblah! - 90) * math.pi / 180) - (iconSize / 2),
                              top: centerOffset + iconRadius * math.sin((_currentQiblah! - 90) * math.pi / 180) - (iconSize / 2),
                              child: Transform.rotate(
                                angle: _currentQiblah! * math.pi / 180,
                                child: Image.asset(
                                  'assets/icon/kaaba.png',
                                  width: iconSize,
                                  height: iconSize,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Text(
                                      '🕋',
                                      style: TextStyle(fontSize: iconSize * 0.7),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              const SizedBox(height: 50),
              Text(
                "Hadapkan ponsel Anda ke arah yang benar untuk menemukan kiblat.",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(color: Colors.grey[400], fontSize: 13),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () => _showCalibrationDialog(context),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF52D395).withOpacity(0.08),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFF52D395).withOpacity(0.2)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.info_outline,
                          size: 14,
                          color: Color(0xFF52D395),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "Gerakkan ponsel membentuk angka '8' untuk kalibrasi. (Klik untuk bantuan)",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            color: const Color(0xFF52D395),
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
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

class KiblatCompassPainter extends CustomPainter {
  final double qiblaBearing;

  KiblatCompassPainter({required this.qiblaBearing});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;

    // 1. Draw outer green ring
    final greenPaint = Paint()
      ..color = const Color(0xFF0F9B58)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, greenPaint);

    // 2. Draw white dial
    final whitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final whiteRadius = radius - 12;
    canvas.drawCircle(center, whiteRadius, whitePaint);

    // 3. Draw inner map circle (light green/teal)
    final innerRadius = whiteRadius - 28;
    final mapRadius = innerRadius - 10;
    
    canvas.save();
    final mapClipPath = Path()
      ..addOval(Rect.fromCircle(center: center, radius: mapRadius));
    canvas.clipPath(mapClipPath);

    // Fill map background
    final mapBgPaint = Paint()
      ..color = const Color(0xFFCBECE1)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, mapRadius, mapBgPaint);

    // Draw grid lines (street map style)
    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    final spacing = 25.0;
    final maxDist = mapRadius * 1.5;
    for (double i = -maxDist; i <= maxDist; i += spacing) {
      canvas.drawLine(
        Offset(center.dx + i - mapRadius, center.dy - mapRadius),
        Offset(center.dx + i + mapRadius, center.dy + mapRadius),
        gridPaint,
      );
      canvas.drawLine(
        Offset(center.dx + i + mapRadius, center.dy - mapRadius),
        Offset(center.dx + i - mapRadius, center.dy + mapRadius),
        gridPaint,
      );
    }
    canvas.restore();

    // 4. Draw ticks on the white dial
    final tickOuterRadius = whiteRadius - 5;
    final tickInnerShort = tickOuterRadius - 8;
    final tickInnerLong = tickOuterRadius - 14;

    final tickPaint = Paint()
      ..color = const Color(0xFF0F263E)
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < 72; i++) {
      final angleDegrees = i * 5.0;
      final angleRadians = (angleDegrees - 90) * math.pi / 180;
      
      final isLong = (i % 6 == 0);
      final innerR = isLong ? tickInnerLong : tickInnerShort;
      
      tickPaint.strokeWidth = isLong ? 2.0 : 1.0;
      
      final start = Offset(
        center.dx + tickOuterRadius * math.cos(angleRadians),
        center.dy + tickOuterRadius * math.sin(angleRadians),
      );
      final end = Offset(
        center.dx + innerR * math.cos(angleRadians),
        center.dy + innerR * math.sin(angleRadians),
      );
      canvas.drawLine(start, end, tickPaint);
    }

    // 5. Draw text directions (N, E, S, W)
    final textStyle = TextStyle(
      color: const Color(0xFF0F263E),
      fontWeight: FontWeight.bold,
      fontSize: 20,
      fontFamily: 'Inter',
    );

    final textDirections = {
      'N': 0.0,
      'E': 90.0,
      'S': 180.0,
      'W': 270.0,
    };

    final textDist = tickInnerLong - 16;

    textDirections.forEach((text, angleDegrees) {
      final angleRadians = (angleDegrees - 90) * math.pi / 180;
      final textPainter = TextPainter(
        text: TextSpan(text: text, style: textStyle),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      final textCenter = Offset(
        center.dx + textDist * math.cos(angleRadians),
        center.dy + textDist * math.sin(angleRadians),
      );

      canvas.save();
      canvas.translate(textCenter.dx, textCenter.dy);
      canvas.rotate(angleDegrees * math.pi / 180);

      textPainter.paint(
        canvas,
        Offset(-textPainter.width / 2, -textPainter.height / 2),
      );
      canvas.restore();
    });

    // 6. Draw dashed line towards Qiblah
    final qiblaAngleRad = (qiblaBearing - 90) * math.pi / 180;
    final linePaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    final startDist = 30.0;
    final endDist = tickOuterRadius - 8;
    
    final dashLength = 6.0;
    final gapLength = 6.0;
    double currentDist = startDist;
    while (currentDist < endDist) {
      final dStart = currentDist;
      final dEnd = math.min(currentDist + dashLength, endDist);
      
      final pStart = Offset(
        center.dx + dStart * math.cos(qiblaAngleRad),
        center.dy + dStart * math.sin(qiblaAngleRad),
      );
      final pEnd = Offset(
        center.dx + dEnd * math.cos(qiblaAngleRad),
        center.dy + dEnd * math.sin(qiblaAngleRad),
      );
      
      canvas.drawLine(pStart, pEnd, linePaint);
      currentDist += dashLength + gapLength;
    }

    // 7. Draw red arrow in the center (pointing to Qibla)
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(qiblaBearing * math.pi / 180);

    // Left half (light red):
    final leftPath = Path()
      ..moveTo(0, -42)
      ..lineTo(-16, 12)
      ..lineTo(0, 0)
      ..close();
    
    final leftPaint = Paint()
      ..color = const Color(0xFFFF4D4D)
      ..style = PaintingStyle.fill;
    canvas.drawPath(leftPath, leftPaint);

    // Right half (dark red):
    final rightPath = Path()
      ..moveTo(0, -42)
      ..lineTo(16, 12)
      ..lineTo(0, 0)
      ..close();
    
    final rightPaint = Paint()
      ..color = const Color(0xFFD6241D)
      ..style = PaintingStyle.fill;
    canvas.drawPath(rightPath, rightPaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant KiblatCompassPainter oldDelegate) {
    return oldDelegate.qiblaBearing != qiblaBearing;
  }
}


