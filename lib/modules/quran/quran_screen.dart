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
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<QuranProvider>().fetchSurahs());
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Cari nama surah...",
                prefixIcon: const Icon(Icons.search, color: Color(0xFF8B7355)),
                filled: true,
                fillColor: theme.colorScheme.surface,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: Color(0xFF8B7355), width: 1),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Consumer<QuranProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.surahs.isEmpty) {
            return Center(child: CircularProgressIndicator(color: theme.primaryColor));
          }

          final filteredSurahs = provider.surahs.where((surah) {
            return surah.englishName.toLowerCase().contains(_searchQuery) ||
                   surah.name.toLowerCase().contains(_searchQuery) ||
                   surah.number.toString().contains(_searchQuery);
          }).toList();

          if (filteredSurahs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.search_off, size: 60, color: Colors.grey),
                  const SizedBox(height: 15),
                  Text("Surah tidak ditemukan", style: GoogleFonts.inter(color: Colors.grey)),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: filteredSurahs.length,
            separatorBuilder: (context, index) => Divider(height: 1, color: theme.dividerColor),
            itemBuilder: (context, index) {
              final surah = filteredSurahs[index];
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
