import 'package:flutter/material.dart';
import 'package:uas_projekk/core/theme.dart';

class DoaListScreen extends StatelessWidget {
  final String category;
  const DoaListScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    // Mock data for Doa
    final List<Map<String, String>> doas = [
      {
        "title": "Doa Before Sleeping",
        "arab": "بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا",
        "translation": "With Your name, O Allah, I die and I live."
      },
      {
        "title": "Doa After Waking Up",
        "arab": "الْحَمْدُ لِلَّهِ الَّذِي أَحْيَانَا بَعْدَ مَا أَمَاتَنَا وَإِلَيْهِ النُّشُورُ",
        "translation": "All praise is for Allah who gave us life after having taken it from us and unto Him is the resurrection."
      },
    ];

    return Scaffold(
      appBar: AppBar(title: Text(category)),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: doas.length,
        itemBuilder: (context, index) {
          final doa = doas[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(doa['title']!, style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
                  const SizedBox(height: 16),
                  Text(
                    doa['arab']!,
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, height: 1.8),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    doa['translation']!,
                    style: const TextStyle(fontSize: 14, color: Colors.black87, fontStyle: FontStyle.italic),
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
