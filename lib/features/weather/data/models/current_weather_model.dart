import 'package:weather_app/features/weather/data/models/weather_model.dart';
import 'package:weather_app/features/weather/data/models/weather_location_model.dart';

class CurrentWeatherModel {
  final WeatherLocationModel location;
  final WeatherModel weather;

//<editor-fold desc="Data Methods">
  const CurrentWeatherModel({
    required this.location,
    required this.weather,
  });

  @override
  String toString() {
    return 'CurrentWeatherModel{ location: $location, weather: $weather,}';
  }

  factory CurrentWeatherModel.fromMap(Map<String, dynamic> map) {
    return CurrentWeatherModel(
      location: WeatherLocationModel.fromMap(map['location']),
      weather: WeatherModel.fromMap(map['current']),
    );
  }

//</editor-fold>
}
