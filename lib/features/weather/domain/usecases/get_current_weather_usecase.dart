import 'package:weather_app/features/weather/data/models/weather_model.dart';
import 'package:weather_app/features/weather/domain/repositories/i_weather_repository.dart';

class GetCurrentWeatherUseCase {
  const GetCurrentWeatherUseCase(this._repository);

  final IWeatherRepository _repository;

  Future<WeatherModel> call(double lat, double lon, {String lang = ''}) {
    return _repository.getCurrentWeather(lat, lon, lang: lang);
  }
}
