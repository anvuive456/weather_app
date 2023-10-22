class Weather {
  final int lastUpdatedEpoch;
  final String lastUpdated;
  final double tempC;
  final double tempF;
  final int isDay;
  final Condition condition;
  final double windMph;
  final double windKph;
  final int windDegree;
  final String windDir;
  final double pressureMb;
  final double pressureIn;
  final num humidity;
  final int cloud;
  final double feelLikeC;
  final double feelLikeF;
  final double visKm;
  final double visMiles;
  final double uv;
  final double gustMph;
  final double gustKph;
  final AirQuality? airQuality;

//<editor-fold desc="Data Methods">

  const Weather.empty({
    this.lastUpdatedEpoch = -1,
    this.lastUpdated = '',
    this.tempC = 0.0,
    this.tempF = 0.0,
    this.isDay = 0,
    this.condition = const Condition.empty(),
    this.windMph = 0.0,
    this.windKph= 0.0,
    this.windDegree= 0,
    this.windDir = '',
    this.pressureMb= 0.0,
    this.pressureIn= 0.0,
    this.humidity= 0.0,
    this.cloud = 0,
    this.feelLikeC= 0.0,
    this.feelLikeF= 0.0,
    this.visKm= 0.0,
    this.visMiles= 0.0,
    this.uv = 0.0,
    this.gustMph= 0.0,
    this.gustKph= 0.0,
    this.airQuality,
  });

  const Weather({
    required this.lastUpdatedEpoch,
    required this.lastUpdated,
    required this.tempC,
    required this.tempF,
    required this.isDay,
    required this.condition,
    required this.windMph,
    required this.windKph,
    required this.windDegree,
    required this.windDir,
    required this.pressureMb,
    required this.pressureIn,
    required this.humidity,
    required this.cloud,
    required this.feelLikeC,
    required this.feelLikeF,
    required this.visKm,
    required this.visMiles,
    required this.uv,
    required this.gustMph,
    required this.gustKph,
    this.airQuality,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Weather &&
          runtimeType == other.runtimeType &&
          lastUpdatedEpoch == other.lastUpdatedEpoch &&
          lastUpdated == other.lastUpdated &&
          tempC == other.tempC &&
          tempF == other.tempF &&
          isDay == other.isDay &&
          condition == other.condition &&
          windMph == other.windMph &&
          windKph == other.windKph &&
          windDegree == other.windDegree &&
          windDir == other.windDir &&
          pressureMb == other.pressureMb &&
          pressureIn == other.pressureIn &&
          humidity == other.humidity &&
          cloud == other.cloud &&
          feelLikeC == other.feelLikeC &&
          feelLikeF == other.feelLikeF &&
          visKm == other.visKm &&
          visMiles == other.visMiles &&
          uv == other.uv &&
          gustMph == other.gustMph &&
          gustKph == other.gustKph &&
          airQuality == other.airQuality);

  @override
  int get hashCode =>
      lastUpdatedEpoch.hashCode ^
      lastUpdated.hashCode ^
      tempC.hashCode ^
      tempF.hashCode ^
      isDay.hashCode ^
      condition.hashCode ^
      windMph.hashCode ^
      windKph.hashCode ^
      windDegree.hashCode ^
      windDir.hashCode ^
      pressureMb.hashCode ^
      pressureIn.hashCode ^
      humidity.hashCode ^
      cloud.hashCode ^
      feelLikeC.hashCode ^
      feelLikeF.hashCode ^
      visKm.hashCode ^
      visMiles.hashCode ^
      uv.hashCode ^
      gustMph.hashCode ^
      gustKph.hashCode ^
      airQuality.hashCode;

  @override
  String toString() {
    return 'Weather{ lastUpdatedEpoch: $lastUpdatedEpoch, lastUpdated: $lastUpdated, tempC: $tempC, tempF: $tempF, isDay: $isDay, condition: $condition, windMph: $windMph, windKph: $windKph, windDegree: $windDegree, windDir: $windDir, pressureMb: $pressureMb, pressureIn: $pressureIn, humidity: $humidity, cloud: $cloud, feelLikeC: $feelLikeC, feelLikeF: $feelLikeF, visKm: $visKm, visMiles: $visMiles, uv: $uv, gustMph: $gustMph, gustKph: $gustKph, airQuality: $airQuality,}';
  }

  factory Weather.fromMap(Map<String, dynamic> map) {
    return Weather(
      lastUpdatedEpoch: map['last_updated_epoch'] as int,
      lastUpdated: map['last_updated'] as String,
      tempC: map['temp_c'] as double,
      tempF: map['temp_f'] as double,
      isDay: map['is_day'] as int,
      condition: Condition.fromMap(map['condition']),
      windMph: map['wind_mph'] as double,
      windKph: map['wind_kph'] as double,
      windDegree: map['wind_degree'] as int,
      windDir: map['wind_dir'] as String,
      pressureMb: map['pressure_mb'] as double,
      pressureIn: map['pressure_in'] as double,
      humidity: map['humidity'] as num,
      cloud: map['cloud'] as int,
      feelLikeC: map['feel_like_c'] ?? 0.0,
      feelLikeF: map['feel_like_f'] ?? 0.0,
      visKm: map['vis_km'] as double,
      visMiles: map['vis_miles'] as double,
      uv: map['uv'] as double,
      gustMph: map['gust_mph'] as double,
      gustKph: map['gust_kph'] as double,
      airQuality: map['air_quality'] == null
          ? null
          : AirQuality.fromMap(map['air_quality']),
    );
  }

//</editor-fold>
}

class AirQuality {
  final double co;
  final double no2;
  final double o3;
  final double so2;
  final double pm25;
  final double pm10;
  final int usEpaIndex;
  final int gbDefraIndex;

//<editor-fold desc="Data Methods">
  const AirQuality({
    required this.co,
    required this.no2,
    required this.o3,
    required this.so2,
    required this.pm25,
    required this.pm10,
    required this.usEpaIndex,
    required this.gbDefraIndex,
  });

  @override
  String toString() {
    return 'AirQuality{ co: $co, no2: $no2, o3: $o3, so2: $so2, pm25: $pm25, pm10: $pm10, usEpaIndex: $usEpaIndex, gbDefraIndex: $gbDefraIndex,}';
  }

  Map<String, dynamic> toMap() {
    return {
      'co': co,
      'no2': no2,
      'o3': o3,
      'so2': so2,
      'pm25': pm25,
      'pm10': pm10,
      'usEpaIndex': usEpaIndex,
      'gbDefraIndex': gbDefraIndex,
    };
  }

  factory AirQuality.fromMap(Map<String, dynamic> map) {
    return AirQuality(
      co: map['co'] as double,
      no2: map['no2'] as double,
      o3: map['o3'] as double,
      so2: map['so2'] as double,
      pm25: map['pm2_5'] as double,
      pm10: map['pm10'] as double,
      usEpaIndex: map['us-epa-index'] as int,
      gbDefraIndex: map['gb-defra-index'] as int,
    );
  }
//</editor-fold>
}

class Condition {
  final String text;
  final String icon;
  final int code;

  String get iconUrl => 'https:$icon';

//<editor-fold desc="Data Methods">
  const Condition.empty({
    this.text = '',
    this.icon = '',
    this.code = -1,
  });

  const Condition({
    required this.text,
    required this.icon,
    required this.code,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Condition &&
          runtimeType == other.runtimeType &&
          text == other.text &&
          icon == other.icon &&
          code == other.code);

  @override
  int get hashCode => text.hashCode ^ icon.hashCode ^ code.hashCode;

  @override
  String toString() {
    return 'Condition{ text: $text, icon: $icon, code: $code,}';
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'icon': icon,
      'code': code,
    };
  }

  factory Condition.fromMap(Map<String, dynamic> map) {
    return Condition(
      text: map['text'] as String,
      icon: map['icon'] as String,
      code: map['code'] as int,
    );
  }
//</editor-fold>
}
