import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

  @override
  void initState() {
    super.initState();
    _loadDetail();
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
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _detail == null
              ? const Center(child: Text("Error loading surah"))
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
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 24),
                            child: Center(
                              child: Text(
                                "بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ",
                                style: TextStyle(fontSize: 28, fontFamily: 'Amiri', fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 14,
                                backgroundColor: AppTheme.primaryColor,
                                child: Text("${ayah['numberInSurah']}", 
                                  style: const TextStyle(fontSize: 10, color: Colors.white)),
                              ),
                              const Spacer(),
                              const Icon(Icons.share, size: 20, color: AppTheme.primaryColor),
                              const SizedBox(width: 16),
                              const Icon(Icons.bookmark_border, size: 20, color: AppTheme.primaryColor),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          ayah['text'],
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            fontSize: 24,
                            fontFamily: 'Amiri',
                            height: 2,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          translation['text'],
                          textAlign: TextAlign.left,
                          style: const TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                        const Divider(height: 48),
                      ],
                    );
                  },
                ),
    );
  }
}
