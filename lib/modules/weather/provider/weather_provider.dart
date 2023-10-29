import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/common/model/forecast.dart';
import 'package:weather_app/common/model/location.dart';
import 'package:weather_app/common/model/weather.dart';
import 'package:weather_app/common/service/weather_service.dart';
import 'package:weather_app/modules/setting/provider/setting_provider.dart';

var weatherProvider =
    FutureProvider.family<Weather, Location>((ref, arg) async {
  String lang =
      ref.watch(settingProvider.select((value) => value.language.code));

  final currWeather =
      await WeatherService().getCurrent(arg.lat, arg.lon, lang: lang);

  return currWeather.weather;
});

var todayForecastProvider =
    FutureProvider.family<Forecast, Location>((ref, arg) async {
  String lang =
      ref.watch(settingProvider.select((value) => value.language.code));

  final forcasts = await WeatherService()
      .getForecasts(arg.lat, arg.lon, days: 1, lang: lang);

  return forcasts.first;
});
var sevenDaysForecastProvider =
    FutureProvider.family<List<Forecast>, Location>((ref, arg) async {
  String lang =
      ref.watch(settingProvider.select((value) => value.language.code));

  final forcast = await WeatherService()
      .getForecasts(arg.lat, arg.lon, days: 7, lang: lang);
  return forcast;
});
