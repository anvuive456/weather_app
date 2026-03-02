import 'package:weather_app/core/network/app_response.dart';
import 'package:weather_app/core/network/rest_api.dart';
import 'package:weather_app/core/network/api_path.dart';
import 'package:weather_app/features/weather/data/models/current_weather_model.dart';
import 'package:weather_app/features/weather/data/models/forecast_model.dart';

abstract class IWeatherRemoteDatasource {
  Future<CurrentWeatherModel> getCurrentWeather(double lat, double lon,
      {String lang});

  Future<List<ForecastModel>> getForecasts(double lat, double lon,
      {int days, bool withAqi, String lang});
}

class WeatherRemoteDatasource implements IWeatherRemoteDatasource {
  const WeatherRemoteDatasource([this._api = const DioHttpProvider()]);

  final DioHttpProvider _api;

  @override
  Future<CurrentWeatherModel> getCurrentWeather(double lat, double lon,
      {String lang = ''}) async {
    final req = {
      'q': '$lat,$lon',
      'aqi': 'yes',
      if (lang.isNotEmpty) 'lang': lang,
    };

    final res = await _api.dioGetRequest(ApiPath.current, query: req);

    return switch (res) {
      SuccessResponse success =>
        Future.value(CurrentWeatherModel.fromMap(success.data)),
      ErrorResponse err => Future.error(err.detail),
      TimeOutResponse out => Future.error(out.message),
    };
  }

  @override
  Future<List<ForecastModel>> getForecasts(double lat, double lon,
      {int days = 10, bool withAqi = false, String lang = ''}) async {
    final req = {
      'q': '$lat,$lon',
      if (lang.isNotEmpty) 'lang': lang,
      'days': days,
      'aqi': withAqi ? 'yes' : 'no',
    };

    final res = await _api.dioGetRequest(ApiPath.forecast, query: req);

    return switch (res) {
      SuccessResponse success => Future.value(
          (success.data['forecast']['forecastday'] as List)
              .map((e) => ForecastModel.fromMap(e))
              .toList()),
      ErrorResponse err => Future.error(err.detail),
      TimeOutResponse out => Future.error(out.message),
    };
  }
}
