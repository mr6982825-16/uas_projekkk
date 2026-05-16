import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:provider/provider.dart';
import 'package:uas_projekk/core/theme.dart';
import 'package:uas_projekk/modules/dzikir/dzikir_model.dart';
import 'package:uas_projekk/modules/dzikir/dzikir_provider.dart';

class DzikirPagiPetangScreen extends StatefulWidget {
  final String title;
  const DzikirPagiPetangScreen({
    super.key,
    required this.title,
    required this.dzikirList, // Still taking this for backward compatibility if needed, but we'll use provider
  });
  
  // ignore: unused_element
  final List<Dzikir> dzikirList;

  @override
  State<DzikirPagiPetangScreen> createState() => _DzikirPagiPetangScreenState();
}

class _DzikirPagiPetangScreenState extends State<DzikirPagiPetangScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final AudioPlayer _audioPlayer = AudioPlayer();
  final TextEditingController _searchController = TextEditingController();
  
  String _searchQuery = "";
  bool _showLatin = true;
  bool _showTranslation = true;
  bool _isPlaying = false;
  Map<String, int> _counts = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    // Set initial tab based on title if possible
    if (widget.title.contains("Petang") || widget.title.contains("Sore")) {
      _tabController.index = 1;
    }
    
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });

    // Fetch data from API
    Future.microtask(() => context.read<DzikirProvider>().fetchDzikirData());
  }

  @override
  void dispose() {
    _tabController.dispose();
    _audioPlayer.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _toggleAudio(String audioPath) async {
    try {
      if (_isPlaying) {
        await _audioPlayer.stop();
        setState(() => _isPlaying = false);
      } else {
        await _audioPlayer.play(AssetSource(audioPath));
        setState(() => _isPlaying = true);
        
        _audioPlayer.onPlayerComplete.listen((event) {
          if (mounted) setState(() => _isPlaying = false);
        });
      }
    } catch (e) {
      debugPrint("Error playing audio: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("File audio $audioPath tidak ditemukan")),
        );
      }
    }
  }

  void _incrementCount(String judul, int target) {
    HapticFeedback.lightImpact();
    setState(() {
      final current = _counts[judul] ?? 0;
      if (current < target) {
        _counts[judul] = current + 1;
      }
    });
  }

  List<Dzikir> _filterList(List<Dzikir> list) {
    if (_searchQuery.isEmpty) return list;
    return list.where((d) => 
      d.judul.toLowerCase().contains(_searchQuery) || 
      d.arab.toLowerCase().contains(_searchQuery)
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: Text("Dzikir", style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(_isPlaying ? Icons.stop_circle : Icons.play_circle_outline),
            onPressed: () {
              final path = _tabController.index == 0 ? 'audio/dzikir_pagi.mp3' : 'audio/dzikir_petang.mp3';
              _toggleAudio(path);
            },
          ),
          IconButton(
            icon: Icon(Icons.translate, color: _showTranslation ? Colors.white : Colors.white38),
            onPressed: () => setState(() => _showTranslation = !_showTranslation),
            tooltip: "Tampilkan Terjemahan",
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(110),
          child: Column(
            children: [
              TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: "Pagi"),
                  Tab(text: "Petang"),
                ],
                indicatorColor: Colors.white,
                labelStyle: GoogleFonts.inter(fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "Cari dzikir...",
                    prefixIcon: const Icon(Icons.search, size: 20),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.9),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Consumer<DzikirProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          return TabBarView(
            controller: _tabController,
            children: [
              _buildDzikirList(provider.dzikirPagi.isEmpty ? DzikirData.dzikirPagi : provider.dzikirPagi),
              _buildDzikirList(provider.dzikirPetang.isEmpty ? DzikirData.dzikirPetang : provider.dzikirPetang),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDzikirList(List<Dzikir> list) {
    final filtered = _filterList(list);
    
    if (filtered.isEmpty) {
      return Center(
        child: Text("Tidak ada dzikir ditemukan", style: GoogleFonts.inter(color: Colors.grey)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final dzikir = filtered[index];
        final currentCount = _counts[dzikir.judul] ?? 0;
        final isCompleted = currentCount >= dzikir.target;

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 2,
          shadowColor: Colors.black12,
          child: InkWell(
            onTap: () => _incrementCount(dzikir.judul, dzikir.target),
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              dzikir.judul,
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                            if (dzikir.fadhilah.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                dzikir.fadhilah,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: Colors.blueGrey,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: isCompleted ? Colors.green.shade100 : Colors.teal.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          "$currentCount / ${dzikir.target}",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            color: isCompleted ? Colors.green.shade700 : Colors.teal.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    dzikir.arab,
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                    style: GoogleFonts.amiri(
                      fontSize: 24,
                      height: 1.8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (_showLatin && dzikir.latin.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text(
                      dzikir.latin,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.teal.shade800,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                  if (_showTranslation && dzikir.terjemahan.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      dzikir.terjemahan,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: Colors.black54,
                        height: 1.5,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
