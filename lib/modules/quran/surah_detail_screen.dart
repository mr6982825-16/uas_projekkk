import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:share_plus/share_plus.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
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
  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener = ItemPositionsListener.create();
  
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
    
    int currentIndex = provider.ayahs.indexWhere((a) => a.number == _playingAyahNumber);
    int nextAyahIndex = currentIndex + 1;

    if (nextAyahIndex < provider.ayahs.length) {
      final nextAyah = provider.ayahs[nextAyahIndex];
      _playAudio(nextAyah, autoPlay: true);
      
      // Scroll accurately using ItemScrollController
      _itemScrollController.scrollTo(
        index: nextAyahIndex + 1, // +1 because of header
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOutCubic,
        alignment: 0.1, // Positioning the item slightly below the top
      );
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
        if (!autoPlay) _isAutoPlay = false;
      });
    } catch (e) {
      debugPrint("Error playing audio: $e");
    }
  }

  Future<void> _startFullSurah() async {
    final provider = context.read<QuranProvider>();
    if (provider.ayahs.isEmpty) return;
    
    setState(() => _isAutoPlay = true);
    _playAudio(provider.ayahs.first, autoPlay: true);
    
    _itemScrollController.scrollTo(
      index: 1, 
      duration: const Duration(milliseconds: 500),
      alignment: 0.1,
    );
  }

  void _shareAyah(Ayah ayah) {
    String shareText = "${ayah.text}\n\n"
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
            icon: Icon(_isAutoPlay ? Icons.stop_circle : Icons.playlist_play),
            tooltip: "Putar Full Surah",
          ),
        ],
      ),
      body: Consumer<QuranProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(child: CircularProgressIndicator(color: theme.primaryColor));
          }

          return ScrollablePositionedList.builder(
            itemScrollController: _itemScrollController,
            itemPositionsListener: _itemPositionsListener,
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
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 15,
            runSpacing: 10,
            children: [
              Text(
                "${widget.surah.revelationType.toUpperCase()} • ${widget.surah.numberOfAyahs} AYAT",
                style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              GestureDetector(
                onTap: _startFullSurah,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _isAutoPlay ? Colors.red.withOpacity(0.5) : Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(_isAutoPlay ? Icons.stop : Icons.play_circle_fill, color: Colors.white, size: 18),
                      const SizedBox(width: 5),
                      Text(_isAutoPlay ? "BERHENTI" : "PUTAR FULL", style: GoogleFonts.inter(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
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
    final isPlaying = _playingAyahNumber == ayah.number;
    final highlightColor = const Color(0xFF0F4D3A);
    final normalArabicColor = settings.isDarkMode ? Colors.white70 : Colors.black87;
    final ayahFontSize = (settings.arabicFontSize - 2).clamp(20.0, 36.0);

    return Column(
      key: ValueKey("ayah_${ayah.number}"),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: isPlaying ? highlightColor.withOpacity(0.08) : Colors.transparent,
            borderRadius: BorderRadius.circular(15),
            border: isPlaying ? Border.all(color: highlightColor.withOpacity(0.3), width: 1) : null,
          ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isPlaying ? highlightColor : const Color(0xFF0F4D3A).withOpacity(0.7),
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
                onPressed: () => _playAudio(ayah),
                icon: Icon(
                  isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill, 
                  size: 28, 
                  color: isPlaying ? highlightColor : const Color(0xFF0F4D3A),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        Align(
          alignment: Alignment.centerRight,
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 500),
            style: GoogleFonts.amiri(
              fontSize: ayahFontSize,
              height: 1.6,
              fontWeight: isPlaying ? FontWeight.w500 : FontWeight.normal,
              color: isPlaying ? highlightColor : normalArabicColor,
            ),
            child: Text(
              ayah.text,
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
            ),
          ),
        ),
        const SizedBox(height: 12),
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 500),
          style: GoogleFonts.inter(
            fontSize: 14,
            fontStyle: FontStyle.italic,
            fontWeight: isPlaying ? FontWeight.bold : FontWeight.normal,
            color: isPlaying ? highlightColor : Colors.grey[600],
          ),
          child: Text(ayah.transliteration),
        ),
        const SizedBox(height: 8),
        Text(
          ayah.translation,
          style: GoogleFonts.inter(
            fontSize: 14, 
            color: settings.isDarkMode ? Colors.white60 : Colors.black54, 
            height: 1.5
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}
