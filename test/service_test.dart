import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/features/location/data/datasources/location_remote_datasource.dart';

void main() {}

void testLocationService() {
  final LocationRemoteDatasource datasource = const LocationRemoteDatasource();
  test('Test get locations', () async {
    await datasource.searchLocations('London');
  });
}
