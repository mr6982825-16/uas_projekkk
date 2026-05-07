import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:uas_projekk/core/theme.dart';
import 'package:uas_projekk/modules/doa/doa_provider.dart';

class DoaListScreen extends StatefulWidget {
  final String category;
  const DoaListScreen({super.key, required this.category});

  @override
  State<DoaListScreen> createState() => _DoaListScreenState();
}

class _DoaListScreenState extends State<DoaListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
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
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: Text(widget.category, style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Cari doa...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none
                ),
              ),
            ),
          ),
        ),
      ),
      body: Consumer<DoaProvider>(
        builder: (context, provider, child) {
          final allDoas = provider.getDoasByCategory(widget.category);
          final doas = allDoas.where((d) {
            final title = (d['judul'] ?? d['doa'] ?? "").toString().toLowerCase();
            return title.contains(_searchQuery);
          }).toList();

          if (doas.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.info_outline, size: 64, color: Colors.blueGrey),
                  const SizedBox(height: 16),
                  Text(
                    "Tidak ada doa ditemukan", 
                    style: GoogleFonts.inter(fontSize: 16, color: Colors.blueGrey, fontWeight: FontWeight.w500)
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: doas.length,
            itemBuilder: (context, index) {
              final doa = doas[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 20),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: Colors.black.withOpacity(0.05)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              doa['judul'] ?? doa['doa'] ?? "Tanpa Nama", 
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.bold, 
                                color: AppTheme.primaryColor,
                                fontSize: 18
                              )
                            ),
                          ),
                          const Icon(Icons.share_outlined, size: 20, color: Colors.grey),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text(
                        doa['arab'] ?? doa['ayat'] ?? "",
                        textAlign: TextAlign.right,
                        textDirection: TextDirection.rtl,
                        style: GoogleFonts.amiri(
                          fontSize: 26,
                          height: 2.2,
                          fontWeight: FontWeight.bold,
                          color: Colors.black.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (doa['latin'] != null && doa['latin'].toString().isNotEmpty) ...[
                        Text(
                          doa['latin'],
                          style: GoogleFonts.inter(
                            fontSize: 14, 
                            color: AppTheme.primaryColor.withOpacity(0.8), 
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w500
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                      Text(
                        doa['terjemahan'] ?? doa['artinya'] ?? doa['arti'] ?? "",
                        style: GoogleFonts.inter(
                          fontSize: 14, 
                          color: Colors.black54, 
                          height: 1.6
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
