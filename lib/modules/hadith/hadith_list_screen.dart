import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uas_projekk/modules/hadith/hadith_provider.dart';
import 'package:uas_projekk/modules/profile/settings_provider.dart';

class HadithListScreen extends StatefulWidget {
  const HadithListScreen({super.key});

  @override
  State<HadithListScreen> createState() => _HadithListScreenState();
}

class _HadithListScreenState extends State<HadithListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<HadithProvider>().fetchBooks());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final settings = Provider.of<SettingsProvider>(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text("Pustaka Hadist", style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
      ),
      body: Consumer<HadithProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.books.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: theme.primaryColor),
                  const SizedBox(height: 20),
                  Text("Menghubungkan ke Pustaka Hadist...", style: GoogleFonts.inter(color: Colors.grey)),
                ],
              ),
            );
          }

          if (provider.error.isNotEmpty && provider.books.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.wifi_off_rounded, size: 60, color: Colors.grey),
                    const SizedBox(height: 20),
                    Text(
                      provider.error,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton.icon(
                      onPressed: () => provider.fetchBooks(),
                      icon: const Icon(Icons.refresh),
                      label: const Text("Coba Lagi"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0F4D3A),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: provider.books.length,
            itemBuilder: (context, index) {
              final book = provider.books[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(settings.isDarkMode ? 0.2 : 0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                  border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F7F5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.auto_stories, color: Color(0xFF1B4332), size: 20),
                  ),
                  title: Text(
                    book.name,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold, 
                      fontSize: 16,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  subtitle: Text(
                    "${book.available} Riwayat",
                    style: GoogleFonts.inter(fontSize: 12, color: Colors.grey),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HadithDetailListScreen(book: book)),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class HadithDetailListScreen extends StatefulWidget {
  final HadithBook book;
  const HadithDetailListScreen({super.key, required this.book});

  @override
  State<HadithDetailListScreen> createState() => _HadithDetailListScreenState();
}

class _HadithDetailListScreenState extends State<HadithDetailListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<HadithProvider>().fetchHadiths(widget.book.id));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final settings = Provider.of<SettingsProvider>(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(widget.book.name, style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
      ),
      body: Consumer<HadithProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: theme.primaryColor),
                  const SizedBox(height: 15),
                  Text("Memuat Hadist...", style: GoogleFonts.inter(color: Colors.grey)),
                ],
              ),
            );
          }

          if (provider.error.isNotEmpty && provider.hadiths.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 50, color: Colors.grey),
                    const SizedBox(height: 15),
                    Text(
                      provider.error,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 25),
                    ElevatedButton(
                      onPressed: () => provider.fetchHadiths(widget.book.id),
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F4D3A), foregroundColor: Colors.white),
                      child: const Text("Muat Ulang"),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: provider.hadiths.length,
            itemBuilder: (context, index) {
              final hadith = provider.hadiths[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 25),
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
                  border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0F4D3A),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "Hadist No. ${hadith.number}",
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.share_outlined, size: 20, color: Colors.grey),
                          onPressed: () {
                            String shareText = "${hadith.arab}\n\n"
                                "Artinya: ${hadith.contents}\n\n"
                                "(${widget.book.name}, No. ${hadith.number})";
                            Share.share(shareText);
                          },
                          tooltip: "Bagikan Hadist",
                        ),
                        IconButton(
                          icon: Icon(
                            settings.favoriteHadithKeys.contains("${widget.book.id}:${hadith.number}")
                                ? Icons.bookmark
                                : Icons.bookmark_outline,
                            size: 20,
                            color: settings.favoriteHadithKeys.contains("${widget.book.id}:${hadith.number}")
                                ? const Color(0xFFD4AF37)
                                : Colors.grey,
                          ),
                          onPressed: () => settings.toggleHadithFavorite(widget.book.id, hadith.number),
                          tooltip: "Simpan Hadist",
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        hadith.arab,
                        textAlign: TextAlign.right,
                        style: GoogleFonts.amiri(
                          fontSize: settings.arabicFontSize - 4, // Hadith text usually smaller than Quran
                          height: 1.8,
                          color: settings.isDarkMode ? const Color(0xFF4DB6AC) : const Color(0xFF1B4332),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    if (settings.showTranslation) ...[
                      const Divider(),
                      const SizedBox(height: 15),
                      Text(
                        "Terjemahan:",
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        hadith.contents,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                          height: 1.6,
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
