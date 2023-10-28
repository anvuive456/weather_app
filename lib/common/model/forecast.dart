import 'package:weather_app/common/model/weather.dart';

class Forecast {
  final String date;
  final int dateEpoch;
  final DayForecast day;
  final Astro astro;
  final List<HourForecast> hour;

  DateTime get parsedDate => DateTime.parse(date);

//<editor-fold desc="Data Methods">
  const Forecast({
    required this.date,
    required this.dateEpoch,
    required this.day,
    required this.astro,
    required this.hour,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Forecast &&
          runtimeType == other.runtimeType &&
          date == other.date &&
          dateEpoch == other.dateEpoch &&
          day == other.day &&
          astro == other.astro &&
          hour == other.hour);

  @override
  int get hashCode =>
      date.hashCode ^
      dateEpoch.hashCode ^
      day.hashCode ^
      astro.hashCode ^
      hour.hashCode;

  @override
  String toString() {
    return 'Forecast{ date: $date, dateEpoch: $dateEpoch, day: $day, astro: $astro, hour: $hour,}';
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'date_epoch': dateEpoch,
      'day': day,
      'astro': astro,
      'hour': hour,
    };
  }

  factory Forecast.fromMap(Map<String, dynamic> map) {
    print(map['date_epoch']);
    return Forecast(
      date: map['date'] ?? '',
      dateEpoch: map['date_epoch'] ,
      day: DayForecast.fromMap(map['day']),
      astro: Astro.fromMap(map['astro']),
      hour: (map['hour'] as List).map((e) => HourForecast.fromMap(e)).toList(),
    );
  }

//</editor-fold>
}

class Astro {
  final String sunrise;
  final String sunset;
  final String moonrise;
  final String moonset;
  final String moonPhase;
  final int moonIllumination;
  final int isMoonUp;
  final int isSunUp;

//<editor-fold desc="Data Methods">
  const Astro({
    required this.sunrise,
    required this.sunset,
    required this.moonrise,
    required this.moonset,
    required this.moonPhase,
    required this.moonIllumination,
    required this.isMoonUp,
    required this.isSunUp,
  });

  @override
  String toString() {
    return 'Astro{ sunrise: $sunrise, sunset: $sunset, moonrise: $moonrise, moonset: $moonset, moonPhase: $moonPhase, moonIllumination: $moonIllumination, isMoonUp: $isMoonUp, isSunUp: $isSunUp,}';
  }

  factory Astro.fromMap(Map<String, dynamic> map) {
    return Astro(
      sunrise: map['sunrise'] ?? '',
      sunset: map['sunset'] ?? '',
      moonrise: map['moonrise'] ?? '',
      moonset: map['moonset'] ?? '',
      moonPhase: map['moonPhase'] ?? '',
      moonIllumination: map['moon_illumination'] ?? 0,
      isMoonUp: map['is_moonup'] ?? 0,
      isSunUp: map['is_sun_up'] ?? 0,
    );
  }

//</editor-fold>
}

class DayForecast {
  final double maxtempC;
  final double maxtempF;
  final double mintempC;
  final double mintempF;
  final double avgtempC;
  final double avgtempF;
  final double maxwindMph;
  final double maxwindKph;
  final double totalprecipMm;
  final double totalprecipIn;
  final num totalsnowCm;
  final double avgvisKm;
  final num avgvisMiles;
  final num avghumidity;
  final int dailyWillItRain;
  final int dailyChanceOfRain;
  final int dailyWillItSnow;
  final int dailyChanceOfSnow;
  final Condition condition;
  final num uv;
  final AirQuality? airQuality;

//<editor-fold desc="Data Methods">
  const DayForecast({
    required this.maxtempC,
    required this.maxtempF,
    required this.mintempC,
    required this.mintempF,
    required this.avgtempC,
    required this.avgtempF,
    required this.maxwindMph,
    required this.maxwindKph,
    required this.totalprecipMm,
    required this.totalprecipIn,
    required this.totalsnowCm,
    required this.avgvisKm,
    required this.avgvisMiles,
    required this.avghumidity,
    required this.dailyWillItRain,
    required this.dailyChanceOfRain,
    required this.dailyWillItSnow,
    required this.dailyChanceOfSnow,
    required this.condition,
    required this.uv,
    this.airQuality,
  });

  @override
  String toString() {
    return 'Day{ maxtempC: $maxtempC, maxtempF: $maxtempF, mintempC: $mintempC, mintempF: $mintempF, avgtempC: $avgtempC, avgtempF: $avgtempF, maxwindMph: $maxwindMph, maxwindKph: $maxwindKph, totalprecipMm: $totalprecipMm, totalprecipIn: $totalprecipIn, totalsnowCm: $totalsnowCm, avgvisKm: $avgvisKm, avgvisMiles: $avgvisMiles, avghumidity: $avghumidity, dailyWillItRain: $dailyWillItRain, dailyChanceOfRain: $dailyChanceOfRain, dailyWillItSnow: $dailyWillItSnow, dailyChanceOfSnow: $dailyChanceOfSnow, condition: $condition, uv: $uv, airQuality: $airQuality,}';
  }

  Map<String, dynamic> toMap() {
    return {
      'maxtemp_c': maxtempC,
      'maxtemp_f': maxtempF,
      'mintemp_c': mintempC,
      'mintemp_f': mintempF,
      'avgtemp_c': avgtempC,
      'avgtemp_f': avgtempF,
      'maxwind_mph': maxwindMph,
      'maxwind_kph': maxwindKph,
      'totalprecip_mm': totalprecipMm,
      'totalprecip_in': totalprecipIn,
      'totalsnow_cm': totalsnowCm,
      'avgvis_km': avgvisKm,
      'avgvis_miles': avgvisMiles,
      'avghumidity': avghumidity,
      'daily_will_it_rain': dailyWillItRain,
      'daily_chance_of_rain': dailyChanceOfRain,
      'daily_will_it_snow': dailyWillItSnow,
      'daily_chance_of_snow': dailyChanceOfSnow,
      'condition': condition.toMap(),
      'uv': uv,
      'air_quality': airQuality?.toMap(),
    };
  }

  factory DayForecast.fromMap(Map<String, dynamic> map) {
    return DayForecast(
      maxtempC: map['maxtemp_c'] ?? 0.0,
      maxtempF: map['maxtemp_f'] ?? 0.0,
      mintempC: map['mintemp_c'] ?? 0.0,
      mintempF: map['mintemp_f'] ?? 0.0,
      avgtempC: map['avgtemp_c'] ?? 0.0,
      avgtempF: map['avgtemp_f'] ?? 0.0,
      maxwindMph: map['maxwind_mph'] ?? 0.0,
      maxwindKph: map['maxwind_kph'] ?? 0.0,
      totalprecipMm: map['totalprecip_mm'] ?? 0.0,
      totalprecipIn: map['totalprecip_in'] ?? 0.0,
      totalsnowCm: map['totalsnow_cm'] ?? 0,
      avgvisKm: map['avgvis_km'] ?? 0.0,
      avgvisMiles: map['avgvis_miles'] ?? 0,
      avghumidity: map['avghumidity'] ?? 0,
      dailyWillItRain: map['daily_will_it_rain'] ?? 0,
      dailyChanceOfRain: map['daily_chance_of_rain'] ?? 0,
      dailyWillItSnow: map['daily_will_it_snow'] ?? 0,
      dailyChanceOfSnow: map['daily_chance_of_snow'] ?? 0,
      condition: Condition.fromMap(map['condition']),
      uv: map['uv'] ?? 0,
      airQuality: map['air_quality'] == null
          ? null
          : AirQuality.fromMap(map['air_quality']),
    );
  }
//</editor-fold>
}

class HourForecast {
  final int timeEpoch;
  final String time;
  final double tempC;
  final double tempF;
  final int isDay;
  final Condition condition;
  final double windMph;
  final double windKph;
  final int windDegree;
  final String windDir;
  final num pressureMb;
  final double pressureIn;
  final double precipMm;
  final double precipIn;
  final num humidity;
  final int cloud;
  final double feelslikeC;
  final double feelslikeF;
  final double windchillC;
  final double windchillF;
  final double heatindexC;
  final double heatindexF;
  final double dewpointC;
  final double dewpointF;
  final int willItRain;
  final num chanceOfRain;
  final int willItSnow;
  final num chanceOfSnow;
  final num visKm;
  final num visMiles;
  final double gustMph;
  final double gustKph;
  final num uv;
  final AirQuality? airQuality;

  DateTime get parsedTime => DateTime.parse(time);

//<editor-fold desc="Data Methods">
  const HourForecast({
    required this.timeEpoch,
    required this.time,
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
    required this.precipMm,
    required this.precipIn,
    required this.humidity,
    required this.cloud,
    required this.feelslikeC,
    required this.feelslikeF,
    required this.windchillC,
    required this.windchillF,
    required this.heatindexC,
    required this.heatindexF,
    required this.dewpointC,
    required this.dewpointF,
    required this.willItRain,
    required this.chanceOfRain,
    required this.willItSnow,
    required this.chanceOfSnow,
    required this.visKm,
    required this.visMiles,
    required this.gustMph,
    required this.gustKph,
    required this.uv,
    this.airQuality,
  });

  @override
  String toString() {
    return 'Hour{ timeEpoch: $timeEpoch, time: $time, tempC: $tempC, tempF: $tempF, isDay: $isDay, condition: $condition, windMph: $windMph, windKph: $windKph, windDegree: $windDegree, windDir: $windDir, pressureMb: $pressureMb, pressureIn: $pressureIn, precipMm: $precipMm, precipIn: $precipIn, humidity: $humidity, cloud: $cloud, feelslikeC: $feelslikeC, feelslikeF: $feelslikeF, windchillC: $windchillC, windchillF: $windchillF, heatindexC: $heatindexC, heatindexF: $heatindexF, dewpointC: $dewpointC, dewpointF: $dewpointF, willItRain: $willItRain, chanceOfRain: $chanceOfRain, willItSnow: $willItSnow, chanceOfSnow: $chanceOfSnow, visKm: $visKm, visMiles: $visMiles, gustMph: $gustMph, gustKph: $gustKph, uv: $uv, airQuality: $airQuality,}';
  }

  factory HourForecast.fromMap(Map<String, dynamic> map) {
    return HourForecast(
      timeEpoch: map['time_epoch'] ?? 0,
      time: map['time'] ?? '',
      tempC: map['temp_c'] ?? 0.0,
      tempF: map['temp_f'] ?? 0.0,
      isDay: map['is_day'] ?? 0,
      condition: Condition.fromMap(map['condition']),
      windMph: map['wind_mph'] ?? 0.0,
      windKph: map['wind_kph'] ?? 0.0,
      windDegree: map['wind_degree'] ?? 0,
      windDir: map['wind_dir'] ?? '',
      pressureMb: map['pressure_mb'] ?? 0,
      pressureIn: map['pressure_in'] ?? 0.0,
      precipMm: map['precip_mm'] ?? 0.0,
      precipIn: map['precip_in'] ?? 0.0,
      humidity: map['humidity'] ?? 0,
      cloud: map['cloud'] ?? 0,
      feelslikeC: map['feelslike_c'] ?? 0.0,
      feelslikeF: map['feelslike_f'] ?? 0.0,
      windchillC: map['windchill_c'] ?? 0.0,
      windchillF: map['windchill_f'] ?? 0.0,
      heatindexC: map['heatindex_c'] ?? 0.0,
      heatindexF: map['heatindexF_f'] ?? 0.0,
      dewpointC: map['dewpoint_c'] ?? 0.0,
      dewpointF: map['dewpoint_f'] ?? 0.0,
      willItRain: map['will_it_rain'] ?? 0,
      chanceOfRain: map['chance_of_rain'] ?? 0,
      willItSnow: map['will_it_snow'] ?? 0,
      chanceOfSnow: map['chance_of_snow'] ?? 0,
      visKm: map['vis_km'] ?? 0,
      visMiles: map['vis_miles'] ?? 0,
      gustMph: map['gust_mph'] ?? 0.0,
      gustKph: map['gust_kph'] ?? 0.0,
      uv: map['uv'] ?? 0,
      airQuality: map['air_quality'] == null
          ? null
          : AirQuality.fromMap(map['air_quality']),
    );
  }

//</editor-fold>
}
