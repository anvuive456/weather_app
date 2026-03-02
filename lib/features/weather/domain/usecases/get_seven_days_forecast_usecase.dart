import 'package:weather_app/features/weather/data/models/forecast_model.dart';
import 'package:weather_app/features/weather/domain/repositories/i_weather_repository.dart';

class GetSevenDaysForecastUseCase {
  const GetSevenDaysForecastUseCase(this._repository);

  final IWeatherRepository _repository;

  Future<List<ForecastModel>> call(double lat, double lon, {String lang = ''}) {
    return _repository.getSevenDaysForecast(lat, lon, lang: lang);
  }
}
