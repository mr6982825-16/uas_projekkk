import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uas_projekk/modules/quran/quran_provider.dart';
import 'package:uas_projekk/modules/profile/settings_provider.dart';

class SurahDetailScreen extends StatefulWidget {
  final Surah surah;
  const SurahDetailScreen({super.key, required this.surah});

  @override
  State<SurahDetailScreen> createState() => _SurahDetailScreenState();
}

class _SurahDetailScreenState extends State<SurahDetailScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<QuranProvider>().fetchAyahs(widget.surah.number));
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(widget.surah.englishName, style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
      ),
      body: Consumer<QuranProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(child: CircularProgressIndicator(color: theme.primaryColor));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: provider.ayahs.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return _buildHeader(settings);
              }
              final ayah = provider.ayahs[index - 1];
              return _buildAyahItem(ayah, settings, theme);
            },
          );
        },
      ),
    );
  }

  Widget _buildHeader(SettingsProvider settings) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(30),
      margin: const EdgeInsets.only(bottom: 30),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F4D3A), Color(0xFF1B4332)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        children: [
          Text(
            widget.surah.englishName,
            style: GoogleFonts.inter(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 5),
          Text(
            widget.surah.englishNameTranslation,
            style: GoogleFonts.inter(fontSize: 16, color: Colors.white70),
          ),
          const Divider(color: Colors.white30, height: 40),
          Text(
            "${widget.surah.revelationType.toUpperCase()} • ${widget.surah.numberOfAyahs} AYAT",
            style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 20),
          Text(
            "بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ",
            style: GoogleFonts.amiri(fontSize: settings.arabicFontSize, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildAyahItem(Ayah ayah, SettingsProvider settings, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(
            color: settings.isDarkMode ? Colors.white10 : const Color(0xFFF8FBFB),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: const Color(0xFF0F4D3A),
                child: Text(
                  ayah.number.toString(),
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
              const Spacer(),
              const Icon(Icons.share_outlined, size: 20, color: Color(0xFF0F4D3A)),
              const SizedBox(width: 20),
              const Icon(Icons.play_arrow_outlined, size: 24, color: Color(0xFF0F4D3A)),
              const SizedBox(width: 20),
              const Icon(Icons.bookmark_outline, size: 20, color: Color(0xFF0F4D3A)),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            ayah.text,
            textAlign: TextAlign.right,
            style: GoogleFonts.amiri(
              fontSize: settings.arabicFontSize,
              height: 2.2,
              fontWeight: FontWeight.bold,
              color: settings.isDarkMode ? const Color(0xFF4DB6AC) : const Color(0xFF1B4332),
            ),
          ),
        ),
        if (settings.showTranslation) ...[
          const SizedBox(height: 15),
          Text(
            ayah.transliteration,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontStyle: FontStyle.italic,
              color: const Color(0xFF8B7355),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            ayah.translation,
            style: GoogleFonts.inter(
              fontSize: 14, 
              color: settings.isDarkMode ? Colors.white70 : Colors.grey[700], 
              height: 1.5
            ),
          ),
        ],
        const SizedBox(height: 40),
      ],
    );
  }
}
