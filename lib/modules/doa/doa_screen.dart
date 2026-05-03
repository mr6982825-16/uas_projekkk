import 'package:flutter/material.dart';
import 'package:uas_projekk/core/theme.dart';

import 'package:uas_projekk/modules/doa/doa_list_screen.dart';

class DoaScreen extends StatelessWidget {
  const DoaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> categories = [
      "Doa Harian",
      "Pagi & Petang",
      "Perjalanan",
      "Makan & Minum",
      "Rumah & Keluarga",
      "Haji & Umrah",
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Kumpulan Doa Harian")),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.2,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DoaListScreen(category: category),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.primaryColor.withOpacity(0.1)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.front_hand, color: AppTheme.primaryColor, size: 32),
                  const SizedBox(height: 12),
                  Text(categories[index], 
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
