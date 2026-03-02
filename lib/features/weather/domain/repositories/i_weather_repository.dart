import 'package:weather_app/features/weather/data/models/forecast_model.dart';
import 'package:weather_app/features/weather/data/models/weather_model.dart';

abstract class IWeatherRepository {
  Future<WeatherModel> getCurrentWeather(double lat, double lon, {String lang});

  Future<ForecastModel> getTodayForecast(double lat, double lon, {String lang});

  Future<List<ForecastModel>> getSevenDaysForecast(double lat, double lon,
      {String lang});
}
