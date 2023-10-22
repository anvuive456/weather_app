final class AppString {
  static const String msgInitSearch =
      'Enter city name or latitude and longitude(lat,long) to find locations';
  static const String hintSearchLocation =
      'London/51.52,-0.11';

  static const String settingLabelDegree = 'Degree';
  static const String settingLabelMeasure = 'Measure';
  static const String appName = 'Weather App';

  static const String msgLoadingLocations='Getting locations...';

  static const String label7daysForecast='7 days forecast';
  static const String labelTodayForecast='Today forecast';

  static const String msgRefresh = 'Something went wrong. Click here to refresh';

  const AppString._();

  static String msgNoLocationFound(String searchText) {
    return 'No locations found with $searchText';
  }
}
