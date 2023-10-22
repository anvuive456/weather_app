import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/common/service/location_service.dart';

void main() {}

void testLocationService() {

  final LocationService service = LocationService();
  test('Test get locations', () async {
    final res = await service.getLocations('London');
  });
}
