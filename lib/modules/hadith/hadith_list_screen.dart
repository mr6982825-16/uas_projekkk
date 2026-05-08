import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:uas_projekk/modules/hadith/hadith_provider.dart';
import 'package:uas_projekk/core/theme.dart';

class HadithListScreen extends StatefulWidget {
  final String title;
  final String slug;
  const HadithListScreen({super.key, required this.title, required this.slug});

  @override
  State<HadithListScreen> createState() => _HadithListScreenState();
}

class _HadithListScreenState extends State<HadithListScreen> {
  String _searchQuery = "";
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<HadithProvider>().fetchHadiths(widget.slug));
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      context.read<HadithProvider>().fetchMoreHadiths(widget.slug);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) => setState(() => _searchQuery = value.toLowerCase()),
              decoration: InputDecoration(
                hintText: "Search hadith...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
              ),
            ),
          ),
        ),
      ),
      body: Consumer<HadithProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final filteredHadiths = provider.hadiths.where((h) {
            final arabText = (h['arab'] ?? h['arabicText'] ?? "").toString().toLowerCase();
            final translation = (h['id'] ?? h['translation'] ?? "").toString().toLowerCase();
            return arabText.contains(_searchQuery) || translation.contains(_searchQuery);
          }).toList();

          if (filteredHadiths.isEmpty) {
            return const Center(child: Text("No hadiths found"));
          }

          return ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: filteredHadiths.length + (provider.hasMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == filteredHadiths.length) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              final hadith = filteredHadiths[index];
              final arabic = hadith['arab'] ?? hadith['arabicText'] ?? "";
              final translation = (hadith['id'] is String) ? hadith['id'] : (hadith['translation'] ?? "");

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              "Nomor ${hadith['number']}", 
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.bold, 
                                color: AppTheme.primaryColor
                              )
                            ),
                          ),
                          const Icon(Icons.share_outlined, size: 20, color: Colors.grey),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        arabic,
                        textAlign: TextAlign.right,
                        textDirection: TextDirection.rtl,
                        style: GoogleFonts.amiri(
                          fontSize: 22, 
                          fontWeight: FontWeight.bold, 
                          height: 2.2
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        translation,
                        style: GoogleFonts.inter(
                          fontSize: 14, 
                          color: Colors.black54,
                          height: 1.5
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
