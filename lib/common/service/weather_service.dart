import 'package:weather_app/common/model/current_weather_response.dart';
import 'package:weather_app/common/model/forecast.dart';
import 'package:weather_app/common/network/api_path.dart';
import 'package:weather_app/common/network/app_respsonse.dart';
import 'package:weather_app/common/network/rest_api.dart';

class WeatherService {
  final DioHttpProvider _api = const DioHttpProvider();

  Future<CurrentWeather> getCurrent(double lat, double lon) async {
    final req = {
      'q': '$lat,$lon',
      'aqi': 'yes',
    };

    final res = await _api.dioGetRequest(ApiPath.current, query: req);

    return switch (res) {
      SuccessResponse success =>
        Future.value(CurrentWeather.fromMap(success.data)),
      ErrorResponse err => Future.error(err.detail),
      TimeOutResponse out => Future.error(out.message),
    };
  }

  Future<List<Forecast>> getForecasts(
  double lat, double lon, {int days = 10, bool withAqi = false}) async {
    final req = {
      'q': '$lat,$lon',

      'days': days,
      'aqi': withAqi ? 'yes' : 'no',
    };

    final res = await _api.dioGetRequest(ApiPath.forecast, query: req);

    return switch (res) {
      SuccessResponse success => Future.value(
          (success.data['forecast']['forecastday'] as List)
              .map((e) => Forecast.fromMap(e)).toList()),
      ErrorResponse err => Future.error(err.detail),
      TimeOutResponse out => Future.error(out.message),
    };
  }
}
