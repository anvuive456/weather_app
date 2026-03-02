import 'package:weather_app/core/utils/cache_manager.dart';
import 'package:weather_app/features/weather/data/datasources/weather_remote_datasource.dart';
import 'package:weather_app/features/weather/data/models/forecast_model.dart';
import 'package:weather_app/features/weather/data/models/weather_model.dart';
import 'package:weather_app/features/weather/domain/repositories/i_weather_repository.dart';

class WeatherRepositoryImpl implements IWeatherRepository {
  const WeatherRepositoryImpl(this._remoteDatasource, this._cache);

  final IWeatherRemoteDatasource _remoteDatasource;
  final CacheManager _cache;

  // ── Cache TTLs ──────────────────────────────────────────────────────────────
  // Current weather: refresh every 10 min.
  // API data is real-time but weather doesn't shift dramatically in under 10 min.
  static const _currentWeatherTtl = Duration(minutes: 10);

  // Hourly forecast: refresh every 30 min.
  // Hourly slots are pre-computed by the provider; they stabilise quickly.
  static const _todayForecastTtl = Duration(minutes: 30);

  // 7-day forecast: refresh every 2 hours.
  // Long-range daily forecasts are inherently coarse and change slowly.
  static const _sevenDaysForecastTtl = Duration(hours: 2);

  // ── Cache key helpers ────────────────────────────────────────────────────────
  static String _currentKey(double lat, double lon, String lang) =>
      'weather_current_${lat}_${lon}_$lang';

  static String _todayKey(double lat, double lon, String lang) =>
      'weather_today_${lat}_${lon}_$lang';

  static String _sevenDaysKey(double lat, double lon, String lang) =>
      'weather_7days_${lat}_${lon}_$lang';

  // ── Public: invalidate all cached data for a location ───────────────────────
  /// Clears every cached entry that belongs to (lat, lon).
  /// Call this before a manual refresh so the user always gets fresh data.
  void invalidateLocation(double lat, double lon) {
    _cache.invalidateWhere((key) => key.contains('_${lat}_${lon}_'));
  }

  // ── IWeatherRepository ───────────────────────────────────────────────────────
  @override
  Future<WeatherModel> getCurrentWeather(double lat, double lon,
      {String lang = ''}) async {
    final key = _currentKey(lat, lon, lang);
    final cached = _cache.get<WeatherModel>(key);
    if (cached != null) return cached;

    final result =
        await _remoteDatasource.getCurrentWeather(lat, lon, lang: lang);
    _cache.set(key, result.weather, _currentWeatherTtl);
    return result.weather;
  }

  @override
  Future<ForecastModel> getTodayForecast(double lat, double lon,
      {String lang = ''}) async {
    final key = _todayKey(lat, lon, lang);
    final cached = _cache.get<ForecastModel>(key);
    if (cached != null) return cached;

    final forecasts =
        await _remoteDatasource.getForecasts(lat, lon, days: 1, lang: lang);
    final today = forecasts.first;
    _cache.set(key, today, _todayForecastTtl);
    return today;
  }

  @override
  Future<List<ForecastModel>> getSevenDaysForecast(double lat, double lon,
      {String lang = ''}) async {
    final key = _sevenDaysKey(lat, lon, lang);
    final cached = _cache.get<List<ForecastModel>>(key);
    if (cached != null) return cached;

    final forecasts =
        await _remoteDatasource.getForecasts(lat, lon, days: 7, lang: lang);
    _cache.set(key, forecasts, _sevenDaysForecastTtl);
    return forecasts;
  }
}
