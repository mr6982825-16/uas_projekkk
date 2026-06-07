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
}
