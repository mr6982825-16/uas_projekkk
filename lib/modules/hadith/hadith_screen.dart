import 'package:flutter/material.dart';
import 'package:uas_projekk/core/theme.dart';

import 'package:uas_projekk/modules/hadith/hadith_list_screen.dart';

class HadithScreen extends StatelessWidget {
  const HadithScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> collections = [
      {"name": "Bukhari", "total": "7008 Hadith", "slug": "bukhari"},
      {"name": "Muslim", "total": "5362 Hadith", "slug": "muslim"},
      {"name": "Abu Daud", "total": "4419 Hadith", "slug": "abu-daud"},
      {"name": "Tirmidzi", "total": "3891 Hadith", "slug": "tirmidzi"},
      {"name": "Nasai", "total": "5364 Hadith", "slug": "nasai"},
      {"name": "Ibnu Majah", "total": "4285 Hadith", "slug": "ibnu-majah"},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Koleksi Hadist")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: collections.length,
        itemBuilder: (context, index) {
          final collection = collections[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              leading: const Icon(Icons.menu_book, color: AppTheme.primaryColor),
              title: Text(collection['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(collection['total']!),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => HadithListScreen(
                      title: collection['name']!,
                      slug: collection['slug']!,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
