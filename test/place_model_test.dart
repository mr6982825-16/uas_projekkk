import 'package:flutter_test/flutter_test.dart';
import 'package:uas_projekk/features/islamic_maps/data/models/place_model.dart';

void main() {
  group('PlaceModel', () {
    test('parses Overpass-style location data', () {
      final overpassData = {
        'type': 'node',
        'id': 12345,
        'lat': -6.2004,
        'lon': 106.8167,
        'tags': {
          'name': 'Masjid Al-Ihsan',
          'amenity': 'place_of_worship',
          'religion': 'muslim',
          'addr:street': 'Jl. Merdeka',
          'addr:city': 'Jakarta',
        },
      };

      final place = PlaceModel.fromOverpassJson(overpassData);

      expect(place.placeId, '12345');
      expect(place.name, 'Masjid Al-Ihsan');
      expect(place.latitude, -6.2004);
      expect(place.longitude, 106.8167);
      expect(place.vicinity, 'Jl. Merdeka, Jakarta');
    });
  });
}
