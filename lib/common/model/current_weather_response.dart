import 'package:weather_app/common/model/weather.dart';
import 'package:weather_app/common/model/weather_location.dart';

class CurrentWeather {
  final WeatherLocation location;
  final Weather weather;

//<editor-fold desc="Data Methods">
  const CurrentWeather({
    required this.location,
    required this.weather,
  });

  @override
  String toString() {
    return 'CurrentWeatherResponse{ location: $location, weather: $weather,}';
  }

  factory CurrentWeather.fromMap(Map<String, dynamic> map) {
    return CurrentWeather(
      location: WeatherLocation.fromMap(map['location']),
      weather: Weather.fromMap(map['current']),
    );
  }

//</editor-fold>
}
