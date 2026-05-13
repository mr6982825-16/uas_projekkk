import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uas_projekk/modules/hadith/hadith_provider.dart';

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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Hadist", style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1B4332),
      ),
      body: Consumer<HadithProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.books.isEmpty) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF0F4D3A)));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: provider.books.length,
            itemBuilder: (context, index) {
              final book = provider.books[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FBFB),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.grey[100]!),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  leading: const Icon(Icons.library_books, color: Color(0xFF8B7355)),
                  title: Text(
                    book.name,
                    style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  subtitle: Text(
                    "${book.available} Hadist",
                    style: GoogleFonts.inter(fontSize: 12, color: Colors.grey),
                  ),
                  trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  onTap: () {
                    _showHadiths(context, book);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showHadiths(BuildContext context, HadithBook book) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HadithDetailListScreen(book: book),
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.book.name, style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1B4332),
      ),
      body: Consumer<HadithProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF0F4D3A)));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: provider.hadiths.length,
            itemBuilder: (context, index) {
              final hadith = provider.hadiths[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 25),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                  border: Border.all(color: Colors.grey[50]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0F4D3A),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            "Hadist No. ${hadith.number}",
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Spacer(),
                        const Icon(Icons.share_outlined, size: 20, color: Colors.grey),
                        const SizedBox(width: 15),
                        const Icon(Icons.bookmark_outline, size: 20, color: Colors.grey),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      hadith.contents,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.grey[800],
                        height: 1.6,
                      ),
                    ),
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
