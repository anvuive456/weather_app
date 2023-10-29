import 'package:weather_app/common/model/location.dart';
import 'package:weather_app/common/network/api_path.dart';
import 'package:weather_app/common/network/app_respsonse.dart';
import 'package:weather_app/common/network/rest_api.dart';

class LocationService {
  const LocationService();

  final DioHttpProvider _api = const DioHttpProvider();

  Future<List<Location>> getLocations(String text, {String lang = ''}) async {
    final req = {
      'q': text,
      if (lang.isNotEmpty) 'lang': lang,
    };

    final res = await _api.dioGetRequest(ApiPath.search, query: req);

    return switch (res) {
      SuccessResponse success => Future.value(
          (success.data as List).map((e) => Location.fromMap(e)).toList()),
      ErrorResponse err => Future.error(err.detail),
      TimeOutResponse out => Future.error(out.message),
    };
  }
}
