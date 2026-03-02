import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/core/utils/cache_manager.dart';
import 'package:weather_app/features/location/data/models/location_model.dart';
import 'package:weather_app/features/weather/data/datasources/weather_remote_datasource.dart';
import 'package:weather_app/features/weather/data/models/forecast_model.dart';
import 'package:weather_app/features/weather/data/models/weather_model.dart';
import 'package:weather_app/features/weather/data/repositories/weather_repository_impl.dart';
import 'package:weather_app/features/weather/domain/usecases/get_current_weather_usecase.dart';
import 'package:weather_app/features/weather/domain/usecases/get_seven_days_forecast_usecase.dart';
import 'package:weather_app/features/weather/domain/usecases/get_today_forecast_usecase.dart';
import 'package:weather_app/features/setting/presentation/providers/setting_provider.dart';

// ── Infrastructure ────────────────────────────────────────────────────────────

final weatherRemoteDatasourceProvider =
    Provider<IWeatherRemoteDatasource>((ref) {
  return const WeatherRemoteDatasource();
});

/// Singleton CacheManager shared across all weather requests.
/// Lives as long as the ProviderScope (entire app lifetime).
final weatherCacheManagerProvider = Provider<CacheManager>((ref) {
  return CacheManager();
});

/// Repository exposed as its concrete type so callers can access
/// [WeatherRepositoryImpl.invalidateLocation] when doing manual refreshes.
final weatherRepositoryProvider = Provider<WeatherRepositoryImpl>((ref) {
  return WeatherRepositoryImpl(
    ref.watch(weatherRemoteDatasourceProvider),
    ref.watch(weatherCacheManagerProvider),
  );
});

// ── Use cases ─────────────────────────────────────────────────────────────────

final getCurrentWeatherUseCaseProvider =
    Provider<GetCurrentWeatherUseCase>((ref) {
  return GetCurrentWeatherUseCase(ref.watch(weatherRepositoryProvider));
});

final getTodayForecastUseCaseProvider =
    Provider<GetTodayForecastUseCase>((ref) {
  return GetTodayForecastUseCase(ref.watch(weatherRepositoryProvider));
});

final getSevenDaysForecastUseCaseProvider =
    Provider<GetSevenDaysForecastUseCase>((ref) {
  return GetSevenDaysForecastUseCase(ref.watch(weatherRepositoryProvider));
});

// ── Feature providers ─────────────────────────────────────────────────────────

var weatherProvider =
    FutureProvider.family<WeatherModel, LocationModel>((ref, location) async {
  final lang =
      ref.watch(settingProvider.select((value) => value.language.code));
  final useCase = ref.watch(getCurrentWeatherUseCaseProvider);
  return useCase(location.lat, location.lon, lang: lang);
});

var todayForecastProvider =
    FutureProvider.family<ForecastModel, LocationModel>((ref, location) async {
  final lang =
      ref.watch(settingProvider.select((value) => value.language.code));
  final useCase = ref.watch(getTodayForecastUseCaseProvider);
  return useCase(location.lat, location.lon, lang: lang);
});

var sevenDaysForecastProvider =
    FutureProvider.family<List<ForecastModel>, LocationModel>(
        (ref, location) async {
  final lang =
      ref.watch(settingProvider.select((value) => value.language.code));
  final useCase = ref.watch(getSevenDaysForecastUseCaseProvider);
  return useCase(location.lat, location.lon, lang: lang);
});
