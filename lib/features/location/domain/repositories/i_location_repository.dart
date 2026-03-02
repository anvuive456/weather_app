import 'package:weather_app/features/location/data/models/location_model.dart';

abstract class ILocationRepository {
  Future<List<LocationModel>> searchLocations(String query, {String lang});

  Future<List<LocationModel>> getLocalLocations();

  Future<void> addLocation(LocationModel location);

  Future<void> removeLocation(LocationModel location);
}
