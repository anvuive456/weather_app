import 'package:weather_app/core/network/api_path.dart';
import 'package:weather_app/core/network/app_response.dart';
import 'package:weather_app/core/network/rest_api.dart';
import 'package:weather_app/features/location/data/models/location_model.dart';

abstract class ILocationRemoteDatasource {
  Future<List<LocationModel>> searchLocations(String query, {String lang});
}

class LocationRemoteDatasource implements ILocationRemoteDatasource {
  const LocationRemoteDatasource([this._api = const DioHttpProvider()]);

  final DioHttpProvider _api;

  @override
  Future<List<LocationModel>> searchLocations(String query,
      {String lang = ''}) async {
    final req = {
      'q': query,
      if (lang.isNotEmpty) 'lang': lang,
    };

    final res = await _api.dioGetRequest(ApiPath.search, query: req);

    return switch (res) {
      SuccessResponse success => Future.value(
          (success.data as List)
              .map((e) => LocationModel.fromMap(e))
              .toList()),
      ErrorResponse err => Future.error(err.detail),
      TimeOutResponse out => Future.error(out.message),
    };
  }
}
