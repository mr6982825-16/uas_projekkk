class PrayerSchedule {
  final String fajr;
  final String dhuhr;
  final String asr;
  final String maghrib;
  final String isha;
  final String date;

  PrayerSchedule({
    required this.fajr,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
    required this.date,
  });

  factory PrayerSchedule.fromJson(Map<String, dynamic> json) {
    final timings = json['data']['timings'];
    final dateStr = json['data']['date']['readable'];
    return PrayerSchedule(
      fajr: timings['Fajr'],
      dhuhr: timings['Dhuhr'],
      asr: timings['Asr'],
      maghrib: timings['Maghrib'],
      isha: timings['Isha'],
      date: dateStr,
    );
  }
  
  // Create an empty schedule
  factory PrayerSchedule.empty() {
    return PrayerSchedule(
      fajr: '--:--',
      dhuhr: '--:--',
      asr: '--:--',
      maghrib: '--:--',
      isha: '--:--',
      date: '-',
    );
  }
}
