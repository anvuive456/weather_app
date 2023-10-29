const kWeatherApiKey = '58f6f89817364691864100348232010';

enum DegreeType {
  celsius,
  fahrenheit,
}

enum MeasureType {
  km,
  miles,
}

enum AppLanguage {
  en('', 'English'),
  vi('vi', 'Tiếng Việt');

  final String code;

  final String title;

  const AppLanguage(this.code, this.title);
}

final class PrefsConstants {
  static const String locationsKey = 'LOCATIONS';
}
