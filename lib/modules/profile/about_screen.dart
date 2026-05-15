import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text("Tentang Pilar Islam", style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F4D3A),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))
                      ],
                    ),
                    child: const Icon(Icons.auto_awesome, color: Colors.white, size: 50),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Pilar Islam",
                    style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold, color: const Color(0xFF0F4D3A)),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Versi 1.0.0",
                    style: GoogleFonts.inter(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            _buildSection(
              "Visi & Misi",
              "Pilar Islam hadir sebagai jembatan bagi umat Muslim untuk mengakses tuntunan ibadah dengan lebih mudah dan modern. Kami berkomitmen menyediakan data doa, dzikir, dan jadwal ibadah yang akurat guna mendukung aktivitas spiritual harian Anda.",
            ),
            const SizedBox(height: 25),
            _buildSection(
              "Tim Pengembang",
              "Aplikasi ini dikembangkan oleh M.rusdi mahasiswa universitas islam madura, alumni pondok pesantren miftahul ulum bettet pamekasan sebagai proyek tugas akhir (UAS) untuk mata kuliah Mobile Programming.",
            ),
            const SizedBox(height: 25),
            _buildSection(
              "Sumber Data",
              "Kami sangat menghargai kontribusi penyedia data pihak ketiga yang memungkinkan aplikasi ini berfungsi:\n\n• Al-Quran & Doa: api.myquran.com\n• Hadits: Hisnul Muslim & API Umum\n• Jadwal Sholat: Aladhan API\n• Gambar: Unsplash & Pravatar",
            ),
            const SizedBox(height: 50),
            Center(
              child: Text(
                "© 2026 Pilar Islam Project\nMade with ❤️ for the Ummah",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(fontSize: 12, color: Colors.grey, height: 1.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF1B4332)),
        ),
        const SizedBox(height: 10),
        Text(
          content,
          style: GoogleFonts.inter(fontSize: 14, color: Colors.grey[700], height: 1.6),
        ),
      ],
    );
  }
}
