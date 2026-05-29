import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:uas_projekk/core/theme.dart';
import '../providers/scanner_provider.dart';
import '../widgets/result_bottom_sheet.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
    torchEnabled: false,
  );

  bool _isProcessing = false; // Mencegah double-scan

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) async {
    if (_isProcessing) return;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isNotEmpty) {
      final barcode = barcodes.first;
      if (barcode.rawValue != null) {
        setState(() {
          _isProcessing = true;
        });

        final String scannedCode = barcode.rawValue!;
        
        // Panggil provider untuk verifikasi API mock
        final provider = Provider.of<ScannerProvider>(context, listen: false);

        // 1. Cek apakah hasil scan merupakan URL resmi sertifikat halal BPJPH
        if (scannedCode.contains('bpjph.halal.go.id') && scannedCode.contains('NoSertifikat')) {
          String? noSertifikat;
          
          try {
            Uri uri = Uri.parse(scannedCode);
            noSertifikat = uri.queryParameters['filter[NoSertifikat]'];
          } catch (e) {
            // Abaikan jika gagal parse URI
          }

          // Fallback menggunakan Regex jika URI parse gagal
          if (noSertifikat == null || noSertifikat.isEmpty) {
            RegExp regExp = RegExp(r'NoSertifikat\]?=([A-Z0-9]+)');
            Match? match = regExp.firstMatch(scannedCode);
            if (match != null) {
              noSertifikat = match.group(1);
            }
          }

          if (noSertifikat != null && noSertifikat.isNotEmpty) {
            provider.scanCertificate(noSertifikat);
          } else {
            provider.scanBarcode(scannedCode);
          }
        } else {
          provider.scanBarcode(scannedCode);
        }

        // Munculkan Bottom Sheet
        if (mounted) {
          await showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => const ResultBottomSheet(),
          );
        }

        // Setelah Bottom Sheet ditutup, izinkan pemindaian lagi
        if (mounted) {
          // Beri sedikit jeda agar tidak langsung scan barcode yang sama saat ditutup
          await Future.delayed(const Duration(milliseconds: 500));
          setState(() {
            _isProcessing = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "Scanner Halal",
          style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            color: Colors.white,
            icon: ValueListenableBuilder<MobileScannerState>(
              valueListenable: _controller,
              builder: (context, state, child) {
                switch (state.torchState) {
                  case TorchState.off:
                    return const Icon(Icons.flash_off, color: Colors.grey);
                  case TorchState.on:
                    return const Icon(Icons.flash_on, color: Colors.yellow);
                  case TorchState.auto:
                  case TorchState.unavailable:
                    return const Icon(Icons.flash_off, color: Colors.grey);
                }
              },
            ),
            iconSize: 32.0,
            onPressed: () => _controller.toggleTorch(),
          ),
          IconButton(
            color: Colors.white,
            icon: ValueListenableBuilder<MobileScannerState>(
              valueListenable: _controller,
              builder: (context, state, child) {
                switch (state.cameraDirection) {
                  case CameraFacing.front:
                    return const Icon(Icons.camera_front);
                  case CameraFacing.back:
                    return const Icon(Icons.camera_rear);
                  default: // Menangani CameraFacing.external atau nilai baru lainnya
                    return const Icon(Icons.camera);
                }
              },
            ),
            iconSize: 32.0,
            onPressed: () => _controller.switchCamera(),
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: _onDetect,
            errorBuilder: (context, error) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.videocam_off, color: Colors.red, size: 60),
                      const SizedBox(height: 20),
                      Text(
                        "Kamera Tidak Tersedia",
                        style: GoogleFonts.inter(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Kamera sedang digunakan oleh aplikasi/tab lain (seperti Zoom, GMeet, atau tab Edge lainnya). Silakan tutup aplikasi tersebut lalu muat ulang halaman ini.",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          // Scanner Overlay
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: AppTheme.primaryColor, width: 3),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Stack(
                children: [
                  // Animasi scan line bisa ditambahkan di sini
                  if (_isProcessing)
                    const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    )
                ],
              ),
            ),
          ),
          // Instruksi
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Text(
                  _isProcessing ? "Memproses..." : "Arahkan barcode ke dalam kotak",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Barcode akan otomatis dipindai",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
