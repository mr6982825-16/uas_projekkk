import 'package:flutter_test/flutter_test.dart';
import 'package:uas_projekk/modules/prayer/prayer_provider.dart';

void main() {
  group('PrayerProvider qibla bearing', () {
    test('calculates a reasonable bearing to the Kaaba from Jakarta', () {
      final bearing = PrayerProvider.calculateQiblaBearing(-6.2088, 106.8456);

      expect(bearing, greaterThan(0.0));
      expect(bearing, lessThan(360.0));
      expect(bearing, closeTo(294.0, 10.0));
    });
  });
}
