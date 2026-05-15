import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uas_projekk/modules/dzikir/doa_harian_provider.dart';
import 'package:uas_projekk/modules/profile/settings_provider.dart';
import 'package:uas_projekk/core/theme.dart';

class DoaHarianScreen extends StatefulWidget {
  final bool showFavoritesOnly;
  const DoaHarianScreen({super.key, this.showFavoritesOnly = false});

  @override
  State<DoaHarianScreen> createState() => _DoaHarianScreenState();
}

class _DoaHarianScreenState extends State<DoaHarianScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<DoaHarianProvider>().fetchAllDoa());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final settings = Provider.of<SettingsProvider>(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(widget.showFavoritesOnly ? "Doa Favorit" : "Kumpulan Doa", style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
      ),
      body: Column(
        children: [
          if (!widget.showFavoritesOnly) _buildSearchField(theme, settings),
          Expanded(
            child: Consumer<DoaHarianProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return Center(child: CircularProgressIndicator(color: theme.primaryColor));
                }

                if (provider.error.isNotEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(provider.error, style: GoogleFonts.inter(color: Colors.red)),
                    ),
                  );
                }

                var list = provider.allDoa;
                if (widget.showFavoritesOnly) {
                  list = list.where((doa) => settings.favoriteDoaTitles.contains(doa.judul)).toList();
                }

                if (list.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.bookmark_border, size: 60, color: Colors.grey[300]),
                        const SizedBox(height: 10),
                        Text(
                          widget.showFavoritesOnly ? "Belum ada doa favorit" : "Tidak ada doa ditemukan", 
                          style: GoogleFonts.inter(color: Colors.grey)
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final doa = list[index];
                    return _buildDoaCard(doa, theme, settings);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField(ThemeData theme, SettingsProvider settings) {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(settings.isDarkMode ? 0.3 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (val) => context.read<DoaHarianProvider>().searchDoa(val),
        decoration: InputDecoration(
          hintText: "Cari doa...",
          hintStyle: GoogleFonts.inter(color: Colors.grey),
          prefixIcon: const Icon(Icons.search, color: Color(0xFF8B7355)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
    );
  }

  Widget _buildDoaCard(doa, ThemeData theme, SettingsProvider settings) {
    final isFavorite = settings.favoriteDoaTitles.contains(doa.judul);

    return GestureDetector(
      onTap: () {
        settings.incrementDoaRead();
        settings.setLastRead(doa.judul, "Kumpulan Doa");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Membaca: ${doa.judul}"), duration: const Duration(seconds: 1)),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(settings.isDarkMode ? 0.2 : 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    doa.judul,
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.share_outlined, size: 20, color: Color(0xFF8B7355)),
                  onPressed: () {
                    Share.share("${doa.judul}\n\n${doa.arab}\n\nArtinya: ${doa.artinya}\n\nShared from Pilar Islam");
                  },
                ),
                IconButton(
                  icon: Icon(
                    isFavorite ? Icons.bookmark : Icons.bookmark_outline, 
                    size: 24, 
                    color: isFavorite ? const Color(0xFFD4AF37) : const Color(0xFF8B7355)
                  ),
                  onPressed: () => settings.toggleFavorite(doa.judul),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              "SUMBER: ${doa.source.toUpperCase()}",
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 25),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                doa.arab,
                textAlign: TextAlign.right,
                style: GoogleFonts.amiri(
                  fontSize: settings.arabicFontSize,
                  height: 1.8,
                  color: settings.isDarkMode ? const Color(0xFF4DB6AC) : const Color(0xFF0F4D3A),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (settings.showTranslation) ...[
              const Divider(),
              const SizedBox(height: 15),
              Text(
                "Artinya:",
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "\"${doa.artinya}\"",
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                  height: 1.6,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
