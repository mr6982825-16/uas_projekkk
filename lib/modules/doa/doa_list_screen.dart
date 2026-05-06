import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:uas_projekk/core/theme.dart';
import 'package:uas_projekk/modules/doa/doa_provider.dart';

class DoaListScreen extends StatelessWidget {
  final String category;
  const DoaListScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(title: Text(category, style: GoogleFonts.inter())),
      body: Consumer<DoaProvider>(
        builder: (context, provider, child) {
          final doas = provider.getDoasByCategory(category);

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
