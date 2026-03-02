import 'package:weather_app/features/location/data/models/location_model.dart';
import 'package:weather_app/features/location/domain/repositories/i_location_repository.dart';

class GetLocalLocationsUseCase {
  const GetLocalLocationsUseCase(this._repository);

  final ILocationRepository _repository;

  Future<List<LocationModel>> call() {
    return _repository.getLocalLocations();
  }
}
