import 'package:weather_app/features/location/data/models/location_model.dart';
import 'package:weather_app/features/location/domain/repositories/i_location_repository.dart';

class AddLocationUseCase {
  const AddLocationUseCase(this._repository);

  final ILocationRepository _repository;

  Future<void> call(LocationModel location) {
    return _repository.addLocation(location);
  }
}
