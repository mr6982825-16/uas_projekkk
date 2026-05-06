import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:uas_projekk/core/theme.dart';
import 'package:uas_projekk/modules/doa/doa_list_screen.dart';
import 'package:uas_projekk/modules/doa/doa_provider.dart';

class DoaScreen extends StatefulWidget {
  const DoaScreen({super.key});

  @override
  State<DoaScreen> createState() => _DoaScreenState();
}

class _DoaScreenState extends State<DoaScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<DoaProvider>().fetchAllDoas());
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> categories = [
      {"name": "Semua Doa", "icon": Icons.list_alt, "color": Colors.blueGrey},
      {"name": "Pagi & Petang", "icon": Icons.wb_twilight, "color": Colors.orange},
      {"name": "Sholat & Ibadah", "icon": Icons.mosque, "color": Colors.teal},
      {"name": "Makanan & Minuman", "icon": Icons.restaurant, "color": Colors.brown},
      {"name": "Kebahagiaan & Kesulitan", "icon": Icons.sentiment_satisfied_alt, "color": Colors.indigo},
      {"name": "Sakit & Kematian", "icon": Icons.health_and_safety, "color": Colors.redAccent},
      {"name": "Perjalanan", "icon": Icons.directions_car, "color": Colors.blue},
      {"name": "Haji & Umrah", "icon": Icons.hiking, "color": Colors.amber},
      {"name": "Adab & Karakter", "icon": Icons.auto_awesome, "color": Colors.purple},
      {"name": "Umum", "icon": Icons.info_outline, "color": Colors.grey},
    ];

    return Scaffold(
      appBar: AppBar(title: Text("Kumpulan Doa", style: GoogleFonts.inter())),
      body: Consumer<DoaProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.allDoas.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.1,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final cat = categories[index];
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DoaListScreen(category: cat['name']),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: cat['color'].withOpacity(0.1)),
                    boxShadow: [
                      BoxShadow(
                        color: cat['color'].withOpacity(0.05),
                        blurRadius: 15,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: cat['color'].withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(cat['icon'] as IconData, color: cat['color'] as Color, size: 32),
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          cat['name'], 
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600, 
                            fontSize: 13,
                            color: Colors.black87
                          )
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
