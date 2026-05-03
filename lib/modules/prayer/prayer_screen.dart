import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uas_projekk/modules/prayer/prayer_provider.dart';
import 'package:uas_projekk/core/theme.dart';

class PrayerScreen extends StatefulWidget {
  const PrayerScreen({super.key});

  @override
  State<PrayerScreen> createState() => _PrayerScreenState();
}

class _PrayerScreenState extends State<PrayerScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<PrayerProvider>().fetchPrayerTimes());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Prayer Times")),
      body: Consumer<PrayerProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.prayerTimes == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Location services required"),
                  ElevatedButton(
                    onPressed: () => provider.fetchPrayerTimes(),
                    child: const Text("Retry"),
                  )
                ],
              ),
            );
          }

          final pt = provider.prayerTimes!;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildTimeRow("Fajr", pt.fajr, provider),
              _buildTimeRow("Sunrise", pt.sunrise, provider),
              _buildTimeRow("Dhuhr", pt.dhuhr, provider),
              _buildTimeRow("Asr", pt.asr, provider),
              _buildTimeRow("Maghrib", pt.maghrib, provider),
              _buildTimeRow("Isha", pt.isha, provider),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTimeRow(String name, DateTime time, PrayerProvider provider) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(provider.formatTime(time), 
              style: const TextStyle(fontSize: 18, color: AppTheme.primaryColor, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
