import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uas_projekk/modules/quran/surah_detail_screen.dart';
import 'package:uas_projekk/modules/quran/quran_provider.dart';
import 'package:uas_projekk/core/theme.dart';

class QuranScreen extends StatefulWidget {
  const QuranScreen({super.key});

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<QuranProvider>().fetchSurahs());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Al-Qur'an"),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) => setState(() => _searchQuery = value.toLowerCase()),
              decoration: InputDecoration(
                hintText: "Search Surah...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
              ),
            ),
          ),
        ),
      ),
      body: Consumer<QuranProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final filteredSurahs = provider.surahs.where((s) {
            final name = "${s['englishName']} ${s['name']}".toLowerCase();
            return name.contains(_searchQuery);
          }).toList();

          if (filteredSurahs.isEmpty) {
            return const Center(child: Text("No Surahs found"));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: filteredSurahs.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final surah = filteredSurahs[index];
              return ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      surah['number'].toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
                    ),
                  ),
                ),
                title: Text(surah['englishName'], style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text("${surah['revelationType']} • ${surah['numberOfAyahs']} Ayah"),
                trailing: Text(
                  surah['name'],
                  style: const TextStyle(fontSize: 20, fontFamily: 'Amiri', fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SurahDetailScreen(surah: surah),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
