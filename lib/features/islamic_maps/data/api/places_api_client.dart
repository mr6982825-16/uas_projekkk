import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../models/place_model.dart';

class PlacesApiClient {
  final Dio _dio = Dio();

  Future<List<PlaceModel>> searchNearby(double lat, double lng, String type, String keyword) async {
    final query = _buildOverpassQuery(lat, lng, type, keyword);

    try {
      final response = await _dio.post(
        'https://overpass-api.de/api/interpreter',
        data: query,
        options: Options(headers: {'Content-Type': 'application/x-www-form-urlencoded'}),
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final elements = data['elements'] as List<dynamic>? ?? <dynamic>[];

        return elements
            .whereType<Map<String, dynamic>>()
            .map((element) => PlaceModel.fromOverpassJson(element))
            .where((place) => place.latitude != 0.0 || place.longitude != 0.0)
            .toList();
      }
    } catch (e) {
      debugPrint('Exception fetching places: $e');
    }

    return [];
  }

  String _buildOverpassQuery(double lat, double lng, String type, String keyword) {
    const radiusKm = 5.0;
    final latDelta = radiusKm / 111.32;
    final lonDelta = radiusKm / (111.32 * cos(lat * pi / 180));

    final south = lat - latDelta;
    final north = lat + latDelta;
    final west = lng - lonDelta;
    final east = lng + lonDelta;

    final isMosque = type == 'mosque';
    final keywordText = keyword.toLowerCase();

    String searchClause;
    if (isMosque) {
      searchClause = '''
        node["amenity"="place_of_worship"]["religion"="muslim"]($south,$west,$north,$east);
        way["amenity"="place_of_worship"]["religion"="muslim"]($south,$west,$north,$east);
        relation["amenity"="place_of_worship"]["religion"="muslim"]($south,$west,$north,$east);
      ''';
    } else {
      searchClause = '''
        node["amenity"="restaurant"]($south,$west,$north,$east);
        way["amenity"="restaurant"]($south,$west,$north,$east);
        relation["amenity"="restaurant"]($south,$west,$north,$east);
      ''';
    }

    if (!isMosque && keywordText.contains('halal')) {
      searchClause += '''
        node["name"~"halal|islam|arab"]($south,$west,$north,$east);
        way["name"~"halal|islam|arab"]($south,$west,$north,$east);
        relation["name"~"halal|islam|arab"]($south,$west,$north,$east);
      ''';
    }

    return '''
      [out:json][timeout:25];
      (
        $searchClause
      );
      out center;
    ''';
  }
}
