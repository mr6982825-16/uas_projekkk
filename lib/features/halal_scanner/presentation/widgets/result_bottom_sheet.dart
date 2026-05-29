import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/models/product_model.dart';
import '../providers/scanner_provider.dart';

class ResultBottomSheet extends StatelessWidget {
  const ResultBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ScannerProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const SizedBox(
            height: 250,
            child: Center(
              child: CircularProgressIndicator(color: Colors.green),
            ),
          );
        }

        // ==== TAMPILAN HASIL OCR (JIKA ADA) ====
        if (provider.ocrResult != null) {
          final ocr = provider.ocrResult!;
          return Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Container(width: 50, height: 5, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)))),
                const SizedBox(height: 20),
                
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: ocr.isSafe ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: ocr.isSafe ? Colors.green : Colors.red),
                  ),
                  child: Row(
                    children: [
                      Icon(ocr.isSafe ? Icons.check_circle : Icons.warning, color: ocr.isSafe ? Colors.green : Colors.red, size: 28),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Text(
                          ocr.isSafe ? "Bahan Kritis Tidak Ditemukan" : "Terdeteksi Bahan Kritis!",
                          style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: ocr.isSafe ? Colors.green : Colors.red, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 20),
                if (!ocr.isSafe) ...[
                  Text("Bahan yang perlu diwaspadai:", style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.red)),
                  const SizedBox(height: 5),
                  Wrap(
                    spacing: 8,
                    children: ocr.detectedCriticalIngredients.map((ing) => Chip(
                      backgroundColor: Colors.red[100],
                      label: Text(ing.toUpperCase(), style: GoogleFonts.inter(color: Colors.red[900], fontWeight: FontWeight.bold)),
                    )).toList(),
                  ),
                  const SizedBox(height: 15),
                ],
                
                Text("Teks Terbaca:", style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 5),
                Container(
                  height: 100,
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(10)),
                  child: SingleChildScrollView(
                    child: Text(ocr.rawText, style: GoogleFonts.inter(fontSize: 12, color: Colors.black87)),
                  ),
                ),
                
                const SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      provider.reset();
                      Navigator.pop(context);
                    },
                    child: Text("Tutup", style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          );
        }

        final product = provider.currentProduct;
        if (product == null) {
          return SizedBox(
            height: 200,
            child: Center(
              child: Text(
                provider.errorMessage.isNotEmpty ? provider.errorMessage : "Menunggu pindaian...",
                style: GoogleFonts.inter(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        Color statusColor;
        IconData statusIcon;
        String statusText;

        switch (product.status) {
          case HalalStatus.halal:
            statusColor = Colors.green;
            statusIcon = Icons.check_circle;
            statusText = "Sertifikasi Halal Aktif";
            break;
          case HalalStatus.syubhat:
            statusColor = Colors.orange;
            statusIcon = Icons.warning_amber_rounded;
            statusText = "Syubhat / Diragukan";
            break;
          case HalalStatus.haram:
            statusColor = Colors.red;
            statusIcon = Icons.cancel;
            statusText = "Tidak Halal (Haram)";
            break;
          case HalalStatus.notFound:
            statusColor = Colors.grey;
            statusIcon = Icons.help_outline;
            statusText = "Tidak Terdaftar";
            break;
        }

        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // Status Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: statusColor.withOpacity(0.5)),
                ),
                child: Row(
                  children: [
                    Icon(statusIcon, color: statusColor, size: 28),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Text(
                        statusText,
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 25),
              
              // Product Details
              Text("Detail Produk", style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 10),
              _buildDetailRow("Nama Produk", product.namaProduk),
              _buildDetailRow("Produsen", product.produsen),
              _buildDetailRow("Nomor Sertifikat", product.nomorSertifikat),
              _buildDetailRow("Barcode", product.barcode),
              
              if (product.keterangan != null) ...[
                const SizedBox(height: 10),
                Text("Keterangan Tambahan:", style: GoogleFonts.inter(fontSize: 12, color: Colors.grey)),
                Text(
                  product.keterangan!,
                  style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: statusColor),
                ),
              ],
              
              const SizedBox(height: 25),
              
              // Action Buttons
              if (product.status == HalalStatus.notFound) ...[
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      final XFile? image = await picker.pickImage(source: ImageSource.camera);
                      if (image != null) {
                        provider.analyzeIngredientsImage(image.path);
                      }
                    },
                    icon: const Icon(Icons.document_scanner_outlined, color: Colors.white),
                    label: Text("Scan Daftar Komposisi (AI OCR)", style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[700],
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
              
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context); // Tutup bottom sheet dan lanjut scan
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: Text("Tutup & Lanjut Scan", style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      }
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 2, child: Text(label, style: GoogleFonts.inter(color: Colors.grey, fontSize: 13))),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14),
              textAlign: TextAlign.right,
            )
          ),
        ],
      ),
    );
  }
}
