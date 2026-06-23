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
    Future.microtask(() {
      final provider = context.read<HadithProvider>();
      provider.fetchBooks();
      provider.initFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final settings = Provider.of<SettingsProvider>(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(
            "Pustaka Hadist",
            style: GoogleFonts.inter(fontWeight: FontWeight.bold),
          ),
          elevation: 0,
          backgroundColor: theme.appBarTheme.backgroundColor,
          foregroundColor: theme.appBarTheme.foregroundColor,
          bottom: TabBar(
            labelColor: const Color(0xFF0F4D3A),
            unselectedLabelColor: Colors.grey,
            indicatorColor: const Color(0xFF0F4D3A),
            indicatorWeight: 3,
            labelStyle: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13),
            unselectedLabelStyle: GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 13),
            tabs: const [
              Tab(text: "Semua Kitab"),
              Tab(text: "Hadist Favorit"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildBooksTab(context, theme, settings),
            _buildFavoritesTab(context, theme, settings),
          ],
        ),
      ),
    );
  }

  Widget _buildBooksTab(BuildContext context, ThemeData theme, SettingsProvider settings) {
    return Consumer<HadithProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading && provider.books.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: theme.primaryColor),
                const SizedBox(height: 20),
                Text(
                  "Memuat data kitab...",
                  style: GoogleFonts.inter(color: Colors.grey),
                ),
              ],
            ),
          );
        }

        if (provider.error.isNotEmpty && provider.books.isEmpty) {
          return _buildErrorState(
            theme: theme,
            message: provider.error,
            onRetry: () => provider.fetchBooks(),
          );
        }

        final books = provider.books;
        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: books.length,
          itemBuilder: (context, index) {
            final book = books[index];
            return _buildBookCard(context, theme, settings, book);
          },
        );
      },
    );
  }


  Widget _buildFavoritesTab(BuildContext context, ThemeData theme, SettingsProvider settings) {
    return Consumer<HadithProvider>(
      builder: (context, provider, child) {
        final favorites = provider.favorites;

        if (favorites.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F7F5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.bookmark_outline,
                      size: 60,
                      color: Color(0xFF0F4D3A),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "Belum Ada Favorit",
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onBackground,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Hadist yang Anda tandai akan muncul di sini agar mudah dibaca kembali.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: favorites.length,
          itemBuilder: (context, index) {
            final fav = favorites[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(20),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F7F5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "${fav.bookName} No. ${fav.number}",
                          style: GoogleFonts.inter(
                            color: const Color(0xFF0F4D3A),
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.share_outlined, size: 20, color: Colors.grey),
                        onPressed: () {
                          String shareText = "${fav.arab}\n\n"
                              "Artinya: ${fav.contents}\n\n"
                              "(${fav.bookName}, No. ${fav.number})";
                          Share.share(shareText);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.bookmark, size: 20, color: Color(0xFFD4AF37)),
                        onPressed: () {
                          // Simple dummy HadithItem to match signature
                          final tempItem = HadithItem(
                            number: fav.number,
                            arab: fav.arab,
                            contents: fav.contents,
                          );
                          provider.toggleFavorite(fav.bookId, fav.bookName, tempItem);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      fav.arab,
                      textAlign: TextAlign.right,
                      style: GoogleFonts.amiri(
                        fontSize: settings.arabicFontSize - 4,
                        height: 1.8,
                        color: settings.isDarkMode ? const Color(0xFF4DB6AC) : const Color(0xFF1B4332),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (settings.showTranslation) ...[
                    const SizedBox(height: 15),
                    const Divider(),
                    const SizedBox(height: 10),
                    Text(
                      fav.contents,
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
    );
  }

  Widget _buildBookCard(BuildContext context, ThemeData theme, SettingsProvider settings, HadithBook book) {
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
          child: const Icon(
            Icons.book_outlined,
            color: Color(0xFF1B4332),
            size: 20,
          ),
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
  }

  Widget _buildErrorState({
    required ThemeData theme,
    required String message,
    required VoidCallback onRetry,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off_rounded, size: 60, color: Colors.grey),
            const SizedBox(height: 20),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(color: Colors.grey[700]),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: onRetry,
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
}

class HadithDetailListScreen extends StatefulWidget {
  final HadithBook book;
  const HadithDetailListScreen({super.key, required this.book});

  @override
  State<HadithDetailListScreen> createState() => _HadithDetailListScreenState();
}

class _HadithDetailListScreenState extends State<HadithDetailListScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final provider = context.read<HadithProvider>();
      provider.fetchHadiths(widget.book.id);
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        final provider = context.read<HadithProvider>();
        if (!provider.isFetchingMore && !provider.hasReachedMax && provider.searchedHadith == null) {
          provider.fetchHadiths(widget.book.id, loadMore: true);
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
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
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _searchController.clear();
              context.read<HadithProvider>().fetchHadiths(widget.book.id);
            },
          )
        ],
      ),
      body: Column(
        children: [
          // Jump to Hadith Number input
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            color: theme.colorScheme.surface,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    keyboardType: TextInputType.number,
                    style: GoogleFonts.inter(fontSize: 14),
                    decoration: InputDecoration(
                      hintText: "Lompat ke nomor hadist (1 - ${widget.book.available})...",
                      prefixIcon: const Icon(Icons.search, color: Color(0xFF0F4D3A), size: 20),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, size: 18),
                              onPressed: () {
                                _searchController.clear();
                                context.read<HadithProvider>().clearSearchedHadith();
                                FocusScope.of(context).unfocus();
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: settings.isDarkMode ? Colors.white10 : Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                    ),
                    onChanged: (val) {
                      setState(() {});
                    },
                    onSubmitted: (value) {
                      final number = int.tryParse(value);
                      if (number != null && number > 0) {
                        context.read<HadithProvider>().fetchSingleHadith(widget.book.id, number);
                      } else if (value.trim().isEmpty) {
                        context.read<HadithProvider>().clearSearchedHadith();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Masukkan nomor hadist yang valid")),
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    final number = int.tryParse(_searchController.text);
                    if (number != null && number > 0) {
                      context.read<HadithProvider>().fetchSingleHadith(widget.book.id, number);
                      FocusScope.of(context).unfocus();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Masukkan nomor hadist")),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F4D3A),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                  ),
                  child: Text("Cari", style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13)),
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<HadithProvider>(
              builder: (context, provider, child) {
                // If searching single Hadith
                if (provider.isSearchingSingle) {
                  return Center(
                    child: CircularProgressIndicator(color: theme.primaryColor),
                  );
                }

                // If searched Hadith error
                if (provider.searchError.isNotEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.search_off, size: 50, color: Colors.grey),
                          const SizedBox(height: 15),
                          Text(
                            provider.searchError,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(color: Colors.grey[700]),
                          ),
                          const SizedBox(height: 20),
                          TextButton(
                            onPressed: () {
                              _searchController.clear();
                              provider.clearSearchedHadith();
                            },
                            child: const Text("Tampilkan Semua", style: TextStyle(color: Color(0xFF0F4D3A), fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                // If a single Hadith is successfully searched and displayed
                if (provider.searchedHadith != null) {
                  final hadith = provider.searchedHadith!;
                  return ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Hasil Pencarian:",
                              style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.grey[600]),
                            ),
                            TextButton(
                              onPressed: () {
                                _searchController.clear();
                                provider.clearSearchedHadith();
                              },
                              child: const Text("Tampilkan Semua", style: TextStyle(color: Color(0xFF0F4D3A), fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ),
                      _buildHadithCard(context, provider, settings, theme, hadith),
                    ],
                  );
                }

                // Default List View
                if (provider.isLoading && provider.hadiths.isEmpty) {
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
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0F4D3A),
                              foregroundColor: Colors.white,
                            ),
                            child: const Text("Muat Ulang"),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(20),
                  itemCount: provider.hadiths.length + (provider.isFetchingMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == provider.hadiths.length) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: CircularProgressIndicator(color: Color(0xFF0F4D3A)),
                        ),
                      );
                    }

                    final hadith = provider.hadiths[index];
                    return _buildHadithCard(context, provider, settings, theme, hadith);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHadithCard(BuildContext context, HadithProvider provider, SettingsProvider settings, ThemeData theme, HadithItem hadith) {
    final isFav = provider.isFavorite(widget.book.id, hadith.number);
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
                  isFav ? Icons.bookmark : Icons.bookmark_outline,
                  size: 20,
                  color: isFav ? const Color(0xFFD4AF37) : Colors.grey,
                ),
                onPressed: () => provider.toggleFavorite(widget.book.id, widget.book.name, hadith),
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
                fontSize: settings.arabicFontSize - 4,
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
  }
}
