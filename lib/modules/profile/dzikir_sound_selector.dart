import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:uas_projekk/modules/profile/settings_provider.dart';

class DzikirSound {
  final String id;
  final String name;
  final String description;
  final String localPath;

  const DzikirSound({
    required this.id,
    required this.name,
    required this.description,
    required this.localPath,
  });
}

class DzikirSoundSelectorSheet extends StatefulWidget {
  const DzikirSoundSelectorSheet({super.key});

  static const List<DzikirSound> sounds = [
    DzikirSound(
      id: 'dzikir_pagi',
      name: 'Dzikir Pagi (Lengkap)',
      description: 'Dzikir Al-Ma\'tsurat Pagi Hari',
      localPath: 'audio/dzikir_pagi.mp3',
    ),
    DzikirSound(
      id: 'dzikir_petang',
      name: 'Dzikir Petang (Lengkap)',
      description: 'Dzikir Al-Ma\'tsurat Sore Hari',
      localPath: 'audio/dzikir_petang.mp3',
    ),
  ];

  @override
  State<DzikirSoundSelectorSheet> createState() => _DzikirSoundSelectorSheetState();
}

class _DzikirSoundSelectorSheetState extends State<DzikirSoundSelectorSheet> {
  late final AudioPlayer _audioPlayer;
  String? _playingSoundId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (state == PlayerState.playing) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      if (mounted) {
        setState(() {
          _playingSoundId = null;
          _isLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.stop();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _togglePlay(DzikirSound sound) async {
    try {
      if (_playingSoundId == sound.id) {
        await _audioPlayer.stop();
        setState(() {
          _playingSoundId = null;
          _isLoading = false;
        });
      } else {
        setState(() {
          _playingSoundId = sound.id;
          _isLoading = true;
        });
        await _audioPlayer.stop();
        
        debugPrint("Playing preview from local asset: ${sound.localPath}");
        await _audioPlayer.play(AssetSource(sound.localPath));
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _playingSoundId = null;
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Gagal memutar audio: $e"),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final theme = Theme.of(context);
    final isDark = settings.isDarkMode;

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Pilih Suara Pengingat Dzikir",
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Pratinjau dan pilih suara alarm dzikir yang Anda inginkan",
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: DzikirSoundSelectorSheet.sounds.length,
                  itemBuilder: (context, index) {
                    final sound = DzikirSoundSelectorSheet.sounds[index];
                    final isSelected = settings.selectedDzikirSoundId == sound.id;
                    final isThisPlaying = _playingSoundId == sound.id;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF0F4D3A).withOpacity(0.08)
                            : theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF0F4D3A).withOpacity(0.3)
                              : theme.dividerColor.withOpacity(0.05),
                        ),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          onTap: () {
                            settings.setSelectedDzikirSoundId(sound.id);
                          },
                          leading: GestureDetector(
                            onTap: () => _togglePlay(sound),
                            child: Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: isThisPlaying
                                    ? const Color(0xFF0F4D3A)
                                    : (isDark ? Colors.white10 : const Color(0xFFF1F7F5)),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: _isLoading && isThisPlaying
                                    ? SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.5,
                                          valueColor: AlwaysStoppedAnimation<Color>(
                                            isThisPlaying ? Colors.white : const Color(0xFF0F4D3A),
                                          ),
                                        ),
                                      )
                                    : Icon(
                                        isThisPlaying ? Icons.stop_rounded : Icons.play_arrow_rounded,
                                        color: isThisPlaying
                                            ? Colors.white
                                            : const Color(0xFF0F4D3A),
                                      ),
                              ),
                            ),
                          ),
                          title: Text(
                            sound.name,
                            style: GoogleFonts.inter(
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          subtitle: Text(
                            sound.description,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          trailing: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected
                                  ? const Color(0xFF0F4D3A)
                                  : Colors.transparent,
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFF0F4D3A)
                                    : Colors.grey.withOpacity(0.5),
                                width: 2,
                              ),
                            ),
                            child: isSelected
                                ? const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 14,
                                  )
                                : null,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F4D3A),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                    "Simpan Pilihan",
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
