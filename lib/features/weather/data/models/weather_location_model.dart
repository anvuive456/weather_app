import 'package:weather_app/features/location/data/models/location_model.dart';

class WeatherLocationModel extends LocationModel {
  final String tzId;
  final int localTimeEpoch;
  final String localTime;

//<editor-fold desc="Data Methods">
  const WeatherLocationModel({
    required this.tzId,
    required this.localTimeEpoch,
    required this.localTime,
    super.id = -1,
    required super.name,
    required super.region,
    required super.country,
    required super.lat,
    required super.lon,
    super.url = '',
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WeatherLocationModel &&
          runtimeType == other.runtimeType &&
          tzId == other.tzId &&
          localTimeEpoch == other.localTimeEpoch &&
          localTime == other.localTime);

  @override
  int get hashCode =>
      tzId.hashCode ^ localTimeEpoch.hashCode ^ localTime.hashCode;

  @override
  String toString() {
    return 'WeatherLocationModel{ tzId: $tzId, localTimeEpoch: $localTimeEpoch, localTime: $localTime,}';
  }

  factory WeatherLocationModel.fromMap(Map<String, dynamic> map) {
    return WeatherLocationModel(
      tzId: map['tzId'] ?? '',
      localTimeEpoch: map['localtime_epoch'] ?? -1,
      localTime: map['localtime'] ?? '',
      name: map['name'] ?? '',
      region: map['region'] ?? '',
      country: map['country'],
      lat: map['lat'] ?? 0.0,
      lon: map['lon'] ?? 0.0,
    );
  }

//</editor-fold>
}
