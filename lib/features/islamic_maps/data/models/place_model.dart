class PlaceModel {
  final String placeId;
  final String name;
  final String vicinity;
  final double latitude;
  final double longitude;
  final double rating;
  final int userRatingsTotal;

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
    return PlaceModel(
      placeId: json['place_id'] ?? '',
      name: json['name'] ?? 'Unknown Place',
      vicinity: json['vicinity'] ?? '',
      latitude: json['geometry']?['location']?['lat']?.toDouble() ?? 0.0,
      longitude: json['geometry']?['location']?['lng']?.toDouble() ?? 0.0,
      rating: json['rating']?.toDouble() ?? 0.0,
      userRatingsTotal: json['user_ratings_total'] ?? 0,
    );
  }

  factory PlaceModel.fromOverpassJson(Map<String, dynamic> json) {
    final tags = Map<String, dynamic>.from(json['tags'] ?? <String, dynamic>{});
    final center = json['center'] is Map ? Map<String, dynamic>.from(json['center']) : null;

    final latitude = (json['lat'] ?? center?['lat'])?.toDouble() ?? 0.0;
    final longitude = (json['lon'] ?? center?['lon'])?.toDouble() ?? 0.0;

    final addressParts = [
      tags['addr:street'],
      tags['addr:suburb'],
      tags['addr:city'],
    ].whereType<String>().where((part) => part.isNotEmpty).toList();

    return PlaceModel(
      placeId: json['id']?.toString() ?? '',
      name: tags['name'] ?? tags['brand'] ?? 'Tempat Islami',
      vicinity: addressParts.join(', '),
      latitude: latitude,
      longitude: longitude,
      rating: 0.0,
      userRatingsTotal: 0,
    );
  }
}
