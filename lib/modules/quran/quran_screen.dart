import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uas_projekk/modules/quran/quran_provider.dart';
import 'package:uas_projekk/modules/quran/surah_detail_screen.dart';

class QuranScreen extends StatefulWidget {
  const QuranScreen({super.key});

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<QuranProvider>().fetchSurahs());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Al-Quran",
          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1B4332),
      ),
      body: Consumer<QuranProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.surahs.isEmpty) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF0F4D3A)));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: provider.surahs.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final surah = provider.surahs[index];
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
                leading: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Icon(Icons.star_outline, color: Color(0xFF8B7355), size: 40),
                    Text(
                      surah.number.toString(),
                      style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                title: Text(
                  surah.englishName,
                  style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                subtitle: Text(
                  "${surah.revelationType.toUpperCase()} • ${surah.numberOfAyahs} AYAT",
                  style: GoogleFonts.inter(fontSize: 12, color: Colors.grey),
                ),
                trailing: Text(
                  surah.name,
                  style: GoogleFonts.amiri(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0F4D3A),
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SurahDetailScreen(surah: surah),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
