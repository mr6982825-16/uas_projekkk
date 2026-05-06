import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uas_projekk/modules/quran/quran_provider.dart';
import 'package:uas_projekk/core/theme.dart';

class SurahDetailScreen extends StatefulWidget {
  final Map<String, dynamic> surah;
  const SurahDetailScreen({super.key, required this.surah});

  @override
  State<SurahDetailScreen> createState() => _SurahDetailScreenState();
}

class _SurahDetailScreenState extends State<SurahDetailScreen> {
  List<dynamic>? _detail;
  bool _isLoading = true;
  double _arabicFontSize = 28.0;

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _loadDetail();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _arabicFontSize = prefs.getDouble('arabic_font_size') ?? 28.0;
    });
  }

  Future<void> _saveFontSize(double size) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('arabic_font_size', size);
  }

  Future<void> _loadDetail() async {
    final detail = await context.read<QuranProvider>().fetchSurahDetail(widget.surah['number']);
    if (mounted) {
      setState(() {
        _detail = detail;
        _isLoading = false;
      });
    }
  }

  void _showFontSizeDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(24),
              height: 200,
              child: Column(
                children: [
                  Text("Sesuaikan Ukuran Teks", style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Icon(Icons.text_fields, size: 16),
                      Expanded(
                        child: Slider(
                          value: _arabicFontSize,
                          min: 18,
                          max: 48,
                          activeColor: AppTheme.primaryColor,
                          onChanged: (value) {
                            setModalState(() => _arabicFontSize = value);
                            setState(() => _arabicFontSize = value);
                            _saveFontSize(value);
                          },
                        ),
                      ),
                      const Icon(Icons.text_fields, size: 32),
                    ],
                  ),
                  Text("${_arabicFontSize.toInt()} px"),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.surah['englishName']),
            Text(
              "${widget.surah['englishNameTranslation']} • ${widget.surah['numberOfAyahs']} Ayah", 
              style: const TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.format_size),
            onPressed: _showFontSizeDialog,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _detail == null
              ? const Center(child: Text("Gagal memuat surah"))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _detail![0]['ayahs'].length,
                  itemBuilder: (context, index) {
                    final ayah = _detail![0]['ayahs'][index];
                    final translation = _detail![1]['ayahs'][index];
                    
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (index == 0 && widget.surah['number'] != 1 && widget.surah['number'] != 9)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 24),
                            child: Center(
                              child: Text(
                                "بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.amiri(
                                  fontSize: _arabicFontSize + 4, 
                                  height: 2.2,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                          ),
                        Stack(
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: CircleAvatar(
                                radius: 16,
                                backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                                child: Text(
                                  "${ayah['numberInSurah']}", 
                                  style: GoogleFonts.inter(
                                    fontSize: 10, 
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.primaryColor
                                  )
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    ayah['text'],
                                    textAlign: TextAlign.right,
                                    textDirection: TextDirection.rtl,
                                    style: GoogleFonts.amiri(
                                      fontSize: _arabicFontSize,
                                      height: 2.2,
                                      color: Colors.black.withOpacity(0.85),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    translation['text'],
                                    textAlign: TextAlign.left,
                                    style: GoogleFonts.inter(
                                      fontSize: 14, 
                                      color: Colors.black54,
                                      height: 1.5
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.share_outlined, size: 20, color: Colors.grey),
                                        onPressed: () {},
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.bookmark_border, size: 20, color: Colors.grey),
                                        onPressed: () {},
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 40, thickness: 0.5),
                      ],
                    );
                  },
                ),
    );
  }
}
