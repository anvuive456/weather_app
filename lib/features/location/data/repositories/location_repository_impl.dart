import 'package:weather_app/features/location/data/datasources/location_local_datasource.dart';
import 'package:weather_app/features/location/data/datasources/location_remote_datasource.dart';
import 'package:weather_app/features/location/data/models/location_model.dart';
import 'package:weather_app/features/location/domain/repositories/i_location_repository.dart';

class LocationRepositoryImpl implements ILocationRepository {
  const LocationRepositoryImpl(
      this._remoteDatasource, this._localDatasource);

  final ILocationRemoteDatasource _remoteDatasource;
  final ILocationLocalDatasource _localDatasource;

  @override
  Future<List<LocationModel>> searchLocations(String query,
      {String lang = ''}) {
    return _remoteDatasource.searchLocations(query, lang: lang);
  }

  @override
  Future<List<LocationModel>> getLocalLocations() {
    return _localDatasource.getLocations();
  }

  @override
  Future<void> addLocation(LocationModel location) async {
    final current = await _localDatasource.getLocations();
    if (current.contains(location)) {
      throw Exception('This location is already added');
    }
    await _localDatasource.saveLocations([...current, location]);
  }

  @override
  Future<void> removeLocation(LocationModel location) async {
    final current = await _localDatasource.getLocations();
    if (!current.contains(location)) {
      throw Exception('This location is not added');
    }
    final updated = current.where((e) => e != location).toList();
    await _localDatasource.saveLocations(updated);
  }
}
