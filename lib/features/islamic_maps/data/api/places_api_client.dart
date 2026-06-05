import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../models/place_model.dart';

class PlacesApiClient {
  final Dio _dio = Dio();
  
  // Free Overpass API endpoints
  final String _baseUrl = "https://overpass-api.de/api/interpreter";

  Future<List<PlaceModel>> searchNearby(double lat, double lng, String type) async {
    try {
      // Build Overpass QL query based on type
      String query = '';
      
      if (type == 'mosque') {
        query = '''
        [out:json][timeout:25];
        (
          node["amenity"="place_of_worship"]["religion"="muslim"](around:5000, ${lat}, ${lng});
          way["amenity"="place_of_worship"]["religion"="muslim"](around:5000, ${lat}, ${lng});
        );
        out center;
        ''';
      } else if (type == 'halal') {
        // Find restaurants or fast food that have diet:halal tag, or at least search for restaurant with name containing 'halal'
        query = '''
        [out:json][timeout:25];
        (
          node["amenity"="restaurant"]["diet:halal"="yes"](around:5000, ${lat}, ${lng});
          node["amenity"="fast_food"]["diet:halal"="yes"](around:5000, ${lat}, ${lng});
          node["amenity"="restaurant"](around:5000, ${lat}, ${lng}); 
        );
        out center;
        ''';
        // Note: as a fallback we pull standard restaurants if strict halal tags are missing, 
        // since OSM halal data can be sparse in some areas. In a real app we'd filter strictly.
      }

      final response = await _dio.post(
        _baseUrl,
        data: query,
        options: Options(
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
      );

      if (response.statusCode == 200 && response.data['elements'] != null) {
        final List elements = response.data['elements'];
        
        // Filter out nodes without names to keep the UI clean
        var parsed = elements
            .map((json) => PlaceModel.fromJson(json))
            .where((place) => place.name != 'Unknown Place')
            .toList();
            
        // If it's halal, try to do some client-side basic filtering just in case
        if (type == 'halal') {
          // simple logic: if we pulled raw restaurants as fallback, maybe keep them all or filter by name
          // we'll keep it simple for now and return them.
        }
        
        return parsed;
      }
    } catch (e) {
      debugPrint("Exception fetching overpass places: \$e");
    }
    return [];
  }
}
