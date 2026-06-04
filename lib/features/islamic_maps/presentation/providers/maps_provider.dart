import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../data/api/places_api_client.dart';
import '../../data/models/place_model.dart';

class MapsProvider with ChangeNotifier {
  final MapController _mapController = MapController();
  Position? _currentPosition;
  bool _isLoading = true;
  String _errorMessage = '';
  
  // Custom marker for user
  Marker? _userMarker;
  List<PlaceModel> _places = [];
  List<Marker> _placeMarkers = [];
  
  // Filter state
  String _currentFilter = 'Semua';
  final PlacesApiClient _placesApi = PlacesApiClient();

  MapController get mapController => _mapController;
  Position? get currentPosition => _currentPosition;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  String get currentFilter => _currentFilter;
  List<PlaceModel> get places => _places;
  
  List<Marker> get allMarkers {
    List<Marker> markers = List.from(_placeMarkers);
    if (_userMarker != null) {
      markers.add(_userMarker!);
    }
    return markers;
  }

  // Selected place for bottom sheet
  PlaceModel? _selectedPlace;
  PlaceModel? get selectedPlace => _selectedPlace;
  
  void clearSelectedPlace() {
    _selectedPlace = null;
    notifyListeners();
  }

  Future<void> fetchUserLocation() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _errorMessage = 'Layanan GPS mati. Mohon aktifkan GPS.';
        _isLoading = false;
        notifyListeners();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
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

      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high
      );
      
      _updateUserMarker();
      await fetchPlaces('Semua'); // Default fetch
      
      recenterToUser(); // recenter after getting location
    } catch (e) {
      _errorMessage = 'Gagal mendapatkan lokasi: \$e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  void _updateUserMarker() {
    if (_currentPosition == null) return;
    
    _userMarker = Marker(
      point: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
      width: 40,
      height: 40,
      child: const Icon(
        Icons.my_location,
        color: Colors.blue,
        size: 30,
      ),
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
          'mosque'
        );
        _places.addAll(masjidData);
      }
      
      if (filter == 'Halal Food' || filter == 'Semua') {
        final halalData = await _placesApi.searchNearby(
          _currentPosition!.latitude, 
          _currentPosition!.longitude, 
          'halal'
        );
        _places.addAll(halalData);
      }
      
      _generatePlaceMarkers();
      
    } catch (e) {
      debugPrint("Error fetching places: \$e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  void _generatePlaceMarkers() {
    _placeMarkers.clear();
    
    for (var place in _places) {
      final isMosque = place.name.toLowerCase().contains('masjid') || place.name.toLowerCase().contains('mosque');
      final color = isMosque ? Colors.green : Colors.orange;
      final icon = isMosque ? Icons.mosque : Icons.restaurant;
      
      _placeMarkers.add(
        Marker(
          point: LatLng(place.latitude, place.longitude),
          width: 40,
          height: 40,
          child: GestureDetector(
            onTap: () {
              _selectedPlace = place;
              notifyListeners();
            },
            child: Icon(
              icon,
              color: color,
              size: 30,
            ),
          ),
        )
      );
    }
  }

  void recenterToUser() {
    if (_currentPosition != null) {
      _mapController.move(
        LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        15.0,
      );
    }
  }
}
