import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/common/model/forecast.dart';
import 'package:weather_app/common/model/location.dart';
import 'package:weather_app/common/model/weather.dart';
import 'package:weather_app/common/service/weather_service.dart';

var weatherProvider =
    FutureProvider.family<Weather, Location>((ref, arg) async {
  final currWeather = await WeatherService().getCurrent(arg.lat, arg.lon);

  return currWeather.weather;
});

var todayForecastProvider =
    FutureProvider.family<Forecast, Location>((ref, arg) async {
  final forcasts =
      await WeatherService().getForecasts(arg.lat, arg.lon, days: 1);

  return forcasts.first;
});
var sevenDaysForecastProvider =
    FutureProvider.family<List<Forecast>, Location>((ref, arg) async {
  final forcast =
      await WeatherService().getForecasts(arg.lat, arg.lon, days: 7);
  return forcast;
});
