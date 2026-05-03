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

      Position position = await Geolocator.getCurrentPosition();
      final coordinates = Coordinates(position.latitude, position.longitude);
      final params = CalculationMethod.muslim_world_league.getParameters();
      params.madhab = Madhab.shafi;
      
      _prayerTimes = PrayerTimes.today(coordinates, params);
      _locationName = "Current Location"; // In real app, use geocoding
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
