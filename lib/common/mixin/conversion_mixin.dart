import 'package:weather_app/common/app_constants.dart';

mixin ConversionMixin {
  String getDegree(DegreeType type, double tempC, double tempF) {
    return switch (type) {
      DegreeType.celsius => '$tempC°C',
      DegreeType.fahrenheit => '$tempF°F'
    };
  }

  String getMeasure(MeasureType type, double km, double miles,
      [bool perHour = false]) {
    return switch (type) {
      MeasureType.km => '$km ${perHour ? 'km/h' : 'km'}',
      MeasureType.miles => '$miles ${perHour ? 'mph' : 'miles'}'
    };
  }
}
