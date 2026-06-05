class PlaceModel {
  final String placeId;
  final String name;
  final String vicinity; // Extracted from tags if available, or just empty
  final double latitude;
  final double longitude;
  final double rating; // Not available in OSM usually, default to 0
  final int userRatingsTotal; // default to 0

  PlaceModel({
    required this.placeId,
    required this.name,
    required this.vicinity,
    required this.latitude,
    required this.longitude,
    required this.rating,
    required this.userRatingsTotal,
  });

  factory PlaceModel.fromJson(Map<String, dynamic> json) {
    // Overpass node usually has lat/lon directly. If it's a way with 'out center', it has center.lat/center.lon
    double lat = json['lat']?.toDouble() ?? json['center']?['lat']?.toDouble() ?? 0.0;
    double lon = json['lon']?.toDouble() ?? json['center']?['lon']?.toDouble() ?? 0.0;
    
    final tags = json['tags'] as Map<String, dynamic>? ?? {};
    
    // Construct a pseudo vicinity from address tags if available
    String address = '';
    if (tags['addr:street'] != null) {
      address = tags['addr:street'];
      if (tags['addr:housenumber'] != null) address += " No. ${tags['addr:housenumber']}";
      if (tags['addr:city'] != null) address += ", ${tags['addr:city']}";
    } else {
      address = tags['description'] ?? 'Lokasi berbasis OpenStreetMap';
    }

    return PlaceModel(
      placeId: json['id']?.toString() ?? '',
      name: tags['name'] ?? tags['brand'] ?? 'Unknown Place',
      vicinity: address,
      latitude: lat,
      longitude: lon,
      rating: 0.0, // OSM doesn't typically provide ratings natively like Google
      userRatingsTotal: 0,
    );
  }
}
