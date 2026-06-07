import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../data/api/places_api_client.dart';
import '../../data/models/place_model.dart';

class MapsProvider with ChangeNotifier {
  GoogleMapController? _mapController;
  Position? _currentPosition;
  bool _isLoading = true;
  String _errorMessage = '';
  
  // Custom marker for user
  Marker? _userMarker;
  List<PlaceModel> _places = [];
  Set<Marker> _placeMarkers = {};
  
  // Filter state
  String _currentFilter = 'Semua';
  final PlacesApiClient _placesApi = PlacesApiClient();

  GoogleMapController? get mapController => _mapController;
  Position? get currentPosition => _currentPosition;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  String get currentFilter => _currentFilter;
  List<PlaceModel> get places => _places;
  
  Set<Marker> get allMarkers {
    Set<Marker> markers = Set.from(_placeMarkers);
    if (_userMarker != null) {
      markers.add(_userMarker!);
    }
    return markers;
  }

  void onMapCreated(GoogleMapController controller) {
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
      markerId: const MarkerId('user_location'),
      position: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
      infoWindow: const InfoWindow(title: 'Lokasi Anda'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
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
          'masjid'
        );
        _places.addAll(masjidData);
      }
      
      if (filter == 'Halal Food' || filter == 'Semua') {
        final halalData = await _placesApi.searchNearby(
          _currentPosition!.latitude, 
          _currentPosition!.longitude, 
          'restaurant', 
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
  
  // Selected place for bottom sheet
  PlaceModel? _selectedPlace;
  PlaceModel? get selectedPlace => _selectedPlace;
  
  void clearSelectedPlace() {
    _selectedPlace = null;
    notifyListeners();
  }

  void _generatePlaceMarkers() {
    _placeMarkers.clear();
    
    for (var place in _places) {
      final isMosque = place.name.toLowerCase().contains('masjid') || place.name.toLowerCase().contains('mosque');
      final hue = isMosque ? BitmapDescriptor.hueGreen : BitmapDescriptor.hueOrange;
      
      _placeMarkers.add(
        Marker(
          markerId: MarkerId(place.placeId),
          position: LatLng(place.latitude, place.longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(hue),
          onTap: () {
            _selectedPlace = place;
            notifyListeners();
          },
        )
      );
    }
  }

  void recenterToUser() {
    if (_mapController != null && _currentPosition != null) {
      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
            zoom: 15.0,
          ),
        ),
      );
    }
  }
}
