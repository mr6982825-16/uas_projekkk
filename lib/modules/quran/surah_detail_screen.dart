import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uas_projekk/modules/quran/quran_provider.dart';
import 'package:uas_projekk/modules/profile/settings_provider.dart';

class SurahDetailScreen extends StatefulWidget {
  final Surah surah;
  const SurahDetailScreen({super.key, required this.surah});

  @override
  State<SurahDetailScreen> createState() => _SurahDetailScreenState();
}

class _SurahDetailScreenState extends State<SurahDetailScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  int? _playingAyahNumber;
  bool _isAutoPlay = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<QuranProvider>().fetchAyahs(widget.surah.number));
    
    _audioPlayer.onPlayerComplete.listen((event) {
      if (mounted) {
        if (_isAutoPlay && _playingAyahNumber != null) {
          _playNextAyah();
        } else {
          setState(() => _playingAyahNumber = null);
        }
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playNextAyah() {
    final provider = context.read<QuranProvider>();
    if (_playingAyahNumber == null) return;
    
    int nextAyahIndex = provider.ayahs.indexWhere((a) => a.number == _playingAyahNumber) + 1;
    if (nextAyahIndex < provider.ayahs.length) {
      _playAudio(provider.ayahs[nextAyahIndex], autoPlay: true);
    } else {
      setState(() {
        _playingAyahNumber = null;
        _isAutoPlay = false;
      });
    }
  }

  Future<void> _playAudio(Ayah ayah, {bool autoPlay = false}) async {
    if (!autoPlay && _playingAyahNumber == ayah.number) {
      await _audioPlayer.stop();
      setState(() {
        _playingAyahNumber = null;
        _isAutoPlay = false;
      });
      return;
    }

    try {
      await _audioPlayer.stop();
      
      String surahStr = widget.surah.number.toString().padLeft(3, '0');
      String ayatStr = ayah.number.toString().padLeft(3, '0');
      String url = "https://everyayah.com/data/Abdul_Basit_Murattal_192kbps/$surahStr$ayatStr.mp3";
      
      await _audioPlayer.play(UrlSource(url));
      setState(() {
        _playingAyahNumber = ayah.number;
        if (!autoPlay) _isAutoPlay = false; // Reset auto-play if manually playing an ayah
      });
    } catch (e) {
      debugPrint("Error playing audio: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Gagal memutar audio")),
        );
      }
    }
  }

  Future<void> _startFullSurah() async {
    final provider = context.read<QuranProvider>();
    if (provider.ayahs.isEmpty) return;
    
    setState(() => _isAutoPlay = true);
    _playAudio(provider.ayahs.first, autoPlay: true);
  }

  void _shareAyah(Ayah ayah) {
    String shareText = "${ayah.text}\n\n"
        "${ayah.transliteration}\n\n"
        "Artinya: ${ayah.translation}\n\n"
        "(QS. ${widget.surah.englishName}: ${ayah.number})";
    Share.share(shareText);
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(widget.surah.englishName, style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        actions: [
          IconButton(
            onPressed: _startFullSurah,
            icon: const Icon(Icons.playlist_play),
            tooltip: "Putar Full Surah",
          ),
        ],
      ),
      body: Consumer<QuranProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(child: CircularProgressIndicator(color: theme.primaryColor));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: provider.ayahs.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return _buildHeader(settings);
              }
              final ayah = provider.ayahs[index - 1];
              return _buildAyahItem(ayah, settings, theme);
            },
          );
        },
      ),
    );
  }

  Widget _buildHeader(SettingsProvider settings) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(30),
      margin: const EdgeInsets.only(bottom: 30),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F4D3A), Color(0xFF1B4332)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        children: [
          Text(
            widget.surah.englishName,
            style: GoogleFonts.inter(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 5),
          Text(
            widget.surah.englishNameTranslation,
            style: GoogleFonts.inter(fontSize: 16, color: Colors.white70),
          ),
          const Divider(color: Colors.white30, height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${widget.surah.revelationType.toUpperCase()} • ${widget.surah.numberOfAyahs} AYAT",
                style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(width: 15),
              GestureDetector(
                onTap: _startFullSurah,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.play_circle_fill, color: Colors.white, size: 18),
                      const SizedBox(width: 5),
                      Text("PUTAR FULL", style: GoogleFonts.inter(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          Text(
            "بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ",
            style: GoogleFonts.amiri(fontSize: settings.arabicFontSize, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildAyahItem(Ayah ayah, SettingsProvider settings, ThemeData theme) {
    final isFavorite = settings.favoriteAyahKeys.contains("${widget.surah.number}:${ayah.number}");
    final isPlaying = _playingAyahNumber == ayah.number;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: settings.isDarkMode ? Colors.white10 : const Color(0xFFF8FBFB),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: Color(0xFF0F4D3A),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    ayah.number.toString(),
                    style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => _shareAyah(ayah),
                icon: const Icon(Icons.share_outlined, size: 20, color: Color(0xFF0F4D3A)),
                tooltip: "Bagikan Ayat",
              ),
              IconButton(
                onPressed: () => _playAudio(ayah),
                icon: Icon(
                  isPlaying ? Icons.stop_circle : Icons.play_arrow_outlined, 
                  size: 24, 
                  color: isPlaying ? Colors.red : const Color(0xFF0F4D3A)
                ),
                tooltip: "Putar Audio",
              ),
              IconButton(
                onPressed: () => settings.toggleAyahFavorite(widget.surah.number, ayah.number),
                icon: Icon(
                  isFavorite ? Icons.bookmark : Icons.bookmark_outline, 
                  size: 20, 
                  color: isFavorite ? const Color(0xFFD4AF37) : const Color(0xFF0F4D3A)
                ),
                tooltip: "Simpan Ayat",
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            ayah.text,
            textAlign: TextAlign.right,
            style: GoogleFonts.amiri(
              fontSize: settings.arabicFontSize,
              height: 2.2,
              fontWeight: FontWeight.bold,
              color: settings.isDarkMode ? const Color(0xFF4DB6AC) : const Color(0xFF1B4332),
            ),
          ),
        ),
        if (settings.showTranslation) ...[
          const SizedBox(height: 15),
          Text(
            ayah.transliteration,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontStyle: FontStyle.italic,
              color: const Color(0xFF8B7355),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            ayah.translation,
            style: GoogleFonts.inter(
              fontSize: 14, 
              color: settings.isDarkMode ? Colors.white70 : Colors.grey[700], 
              height: 1.5
            ),
          ),
        ],
        const SizedBox(height: 40),
      ],
    );
  }
}
