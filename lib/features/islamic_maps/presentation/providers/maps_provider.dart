import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import '../../data/api/places_api_client.dart';
import '../../data/models/place_model.dart';

class MapsProvider with ChangeNotifier {
  MapController? _mapController;
  Position? _currentPosition;
  bool _isLoading = true;
  String _errorMessage = '';

  Marker? _userMarker;
  List<PlaceModel> _places = [];
  List<Marker> _placeMarkers = [];

  String _currentFilter = 'Semua';
  final PlacesApiClient _placesApi = PlacesApiClient();

  MapController get mapController => _mapController ??= MapController();
  Position? get currentPosition => _currentPosition;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  String get currentFilter => _currentFilter;
  List<PlaceModel> get places => _places;

  List<Marker> get allMarkers {
    final markers = <Marker>[];
    if (_userMarker != null) {
      markers.add(_userMarker!);
    }
    markers.addAll(_placeMarkers);
    return markers;
  }

  void onMapCreated(MapController controller) {
    _mapController = controller;
    if (_currentPosition != null) {
      recenterToUser();
    }
  }

  Future<void> fetchUserLocation() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _errorMessage = 'Layanan GPS mati. Mohon aktifkan GPS.';
        _isLoading = false;
        notifyListeners();
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _errorMessage = 'Izin lokasi ditolak.';
          _isLoading = false;
          notifyListeners();
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _errorMessage = 'Izin lokasi diblokir permanen oleh sistem.';
        _isLoading = false;
        notifyListeners();
        return;
      }

      _currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      _updateUserMarker();
      await fetchPlaces('Semua');
    } catch (e) {
      _errorMessage = 'Gagal mendapatkan lokasi: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _updateUserMarker() {
    if (_currentPosition == null) return;

    _userMarker = Marker(
      point: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
      width: 45,
      height: 45,
      child: const Icon(Icons.my_location, color: Colors.blueAccent, size: 34),
    );
  }

  Future<void> fetchPlaces(String filter) async {
    if (_currentPosition == null) return;

    _currentFilter = filter;
    _isLoading = true;
    notifyListeners();

    _places.clear();

    try {
      if (filter == 'Masjid' || filter == 'Semua') {
        final masjidData = await _placesApi.searchNearby(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
          'mosque',
          'masjid',
        );
        _places.addAll(masjidData);
      }

      if (filter == 'Halal Food' || filter == 'Semua') {
        final halalData = await _placesApi.searchNearby(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
          'restaurant',
          'halal',
        );
        _places.addAll(halalData);
      }

      _generatePlaceMarkers();
    } catch (e) {
      debugPrint('Error fetching places: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  PlaceModel? _selectedPlace;
  PlaceModel? get selectedPlace => _selectedPlace;

  void clearSelectedPlace() {
    _selectedPlace = null;
    notifyListeners();
  }

  void _generatePlaceMarkers() {
    _placeMarkers.clear();

    for (final place in _places) {
      final isMosque = place.name.toLowerCase().contains('masjid') || place.name.toLowerCase().contains('mosque');
      final markerColor = isMosque ? Colors.green : Colors.orange;

      _placeMarkers.add(
        Marker(
          point: LatLng(place.latitude, place.longitude),
          width: 42,
          height: 42,
          child: GestureDetector(
            onTap: () {
              _selectedPlace = place;
              notifyListeners();
            },
            child: Icon(Icons.place, color: markerColor, size: 30),
          ),
        ),
      );
    }
  }

  void recenterToUser() {
    final controller = _mapController;
    if (controller != null && _currentPosition != null) {
      controller.move(LatLng(_currentPosition!.latitude, _currentPosition!.longitude), 15.0);
    }
  }
}
