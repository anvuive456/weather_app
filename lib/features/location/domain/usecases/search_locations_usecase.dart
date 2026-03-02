import 'package:weather_app/features/location/data/models/location_model.dart';
import 'package:weather_app/features/location/domain/repositories/i_location_repository.dart';

class SearchLocationsUseCase {
  const SearchLocationsUseCase(this._repository);

  final ILocationRepository _repository;

  Future<List<LocationModel>> call(String query, {String lang = ''}) {
    return _repository.searchLocations(query, lang: lang);
  }
}
