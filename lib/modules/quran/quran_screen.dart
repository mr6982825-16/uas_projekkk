import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uas_projekk/modules/profile/settings_provider.dart';
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
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          "Al-Quran",
          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
      ),
      body: Consumer<QuranProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.surahs.isEmpty) {
            return Center(child: CircularProgressIndicator(color: theme.primaryColor));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: provider.surahs.length,
            separatorBuilder: (context, index) => Divider(height: 1, color: theme.dividerColor),
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
                      style: GoogleFonts.inter(
                        fontSize: 12, 
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface
                      ),
                    ),
                  ],
                ),
                title: Text(
                  surah.englishName,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold, 
                    fontSize: 16,
                    color: theme.colorScheme.onSurface
                  ),
                ),
                subtitle: Text(
                  "${surah.revelationType.toUpperCase()} • ${surah.numberOfAyahs} AYAT",
                  style: GoogleFonts.inter(fontSize: 12, color: Colors.grey),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      surah.name,
                      style: GoogleFonts.amiri(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: theme.primaryColor,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Icon(Icons.play_circle_outline, color: theme.primaryColor.withOpacity(0.5), size: 24),
                  ],
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
