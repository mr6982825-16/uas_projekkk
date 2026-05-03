import 'package:flutter/material.dart';
import 'package:uas_projekk/core/theme.dart';

class HadithScreen extends StatelessWidget {
  const HadithScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> collections = [
      {"name": "Bukhari", "total": "7008 Hadith"},
      {"name": "Muslim", "total": "5362 Hadith"},
      {"name": "Abu Daud", "total": "4419 Hadith"},
      {"name": "Tirmidzi", "total": "3891 Hadith"},
      {"name": "Nasai", "total": "5364 Hadith"},
      {"name": "Ibnu Majah", "total": "4285 Hadith"},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Hadith Collections")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: collections.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              leading: const Icon(Icons.menu_book, color: AppTheme.primaryColor),
              title: Text(collections[index]['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(collections[index]['total']!),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // Navigate to hadith list
              },
            ),
          );
        },
      ),
    );
  }
}
