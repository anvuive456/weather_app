import 'package:weather_app/features/weather/data/models/forecast_model.dart';
import 'package:weather_app/features/weather/domain/repositories/i_weather_repository.dart';

class GetTodayForecastUseCase {
  const GetTodayForecastUseCase(this._repository);

  final IWeatherRepository _repository;

  Future<ForecastModel> call(double lat, double lon, {String lang = ''}) {
    return _repository.getTodayForecast(lat, lon, lang: lang);
  }
}
