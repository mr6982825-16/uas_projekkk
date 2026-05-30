import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationResult {
  final String city;
  final String country;
  final double latitude;
  final double longitude;

  LocationResult({
    required this.city,
    required this.country,
    required this.latitude,
    required this.longitude,
  });
}

class LocationRepository {
  /// Meminta izin lokasi dan mengembalikan lokasi kota saat ini
  Future<LocationResult?> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the 
      // App to enable the location services.
      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return null;
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately. 
      return null;
    } 

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        return LocationResult(
          city: place.subAdministrativeArea ?? place.locality ?? place.administrativeArea ?? 'Jakarta',
          country: place.country ?? 'Indonesia',
          latitude: position.latitude,
          longitude: position.longitude,
        );
      }
    } catch (e) {
      print("Error getting location: \$e");
    }
    
    return null;
  }
}
