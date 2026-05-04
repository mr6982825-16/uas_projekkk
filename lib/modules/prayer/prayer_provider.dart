import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class PrayerProvider with ChangeNotifier {
  PrayerTimes? _prayerTimes;
  String _locationName = "Detecting...";
  bool _isLoading = false;

  PrayerTimes? get prayerTimes => _prayerTimes;
  String get locationName => _locationName;
  bool get isLoading => _isLoading;

  String get nextPrayerName {
    if (_prayerTimes == null) return "...";
    final next = _prayerTimes!.nextPrayer();
    if (next == Prayer.none) return "Fajr (Tomorrow)";
    return next.name.toUpperCase();
  }

  DateTime? get nextPrayerTime {
    if (_prayerTimes == null) return null;
    final next = _prayerTimes!.nextPrayer();
    if (next == Prayer.none) return _prayerTimes!.fajr;
    return _prayerTimes!.timeForPrayer(next);
  }

  Future<void> fetchPrayerTimes() async {
    _isLoading = true;
    notifyListeners();

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _locationName = "Location Disabled";
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _locationName = "Permission Denied";
          return;
        }
      }

      Position? position;
      try {
        position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low,
          timeLimit: const Duration(seconds: 5),
        );
      } catch (e) {
        debugPrint("Location timeout or error, using fallback: $e");
      }

      // Default to Jakarta if position is null
      final lat = position?.latitude ?? -6.2088;
      final lon = position?.longitude ?? 106.8456;
      final coordinates = Coordinates(lat, lon);
      
      final params = CalculationMethod.muslim_world_league.getParameters();
      params.madhab = Madhab.shafi;
      
      _prayerTimes = PrayerTimes.today(coordinates, params);
      _locationName = position != null ? "Current Location" : "Jakarta (Default)";
    } catch (e) {
      debugPrint("Error calculating prayer times: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String formatTime(DateTime time) {
    return DateFormat.Hm().format(time.toLocal());
  }
}
