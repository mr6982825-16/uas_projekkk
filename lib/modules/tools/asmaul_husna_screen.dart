import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uas_projekk/core/theme.dart';

class AsmaulHusnaScreen extends StatefulWidget {
  const AsmaulHusnaScreen({super.key});

  @override
  State<AsmaulHusnaScreen> createState() => _AsmaulHusnaScreenState();
}

class _AsmaulHusnaScreenState extends State<AsmaulHusnaScreen> {
  List<dynamic> _names = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAsmaulHusna();
  }

  Future<void> _fetchAsmaulHusna() async {
    try {
      final response = await Dio().get("https://api.aladhan.com/v1/asmaAlHusna");
      if (response.statusCode == 200) {
        setState(() {
          _names = response.data['data'];
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetching Asmaul Husna: $e");
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Asmaul Husna")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.1,
              ),
              itemCount: _names.length,
              itemBuilder: (context, index) {
                final n = _names[index];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          n['name'],
                          style: GoogleFonts.amiri(
                            fontSize: 22, 
                            fontWeight: FontWeight.bold, 
                            height: 1.5
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          n['transliteration'],
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 12, 
                            fontWeight: FontWeight.bold, 
                            color: AppTheme.primaryColor
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          n['en']['meaning'],
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(fontSize: 10, color: Colors.black45),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
