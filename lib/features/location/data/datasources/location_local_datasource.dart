import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/core/constants/app_constants.dart';
import 'package:weather_app/features/location/data/models/location_model.dart';

abstract class ILocationLocalDatasource {
  Future<List<LocationModel>> getLocations();
  Future<bool> saveLocations(List<LocationModel> locations);
  Future<bool> hasLocations();
}

class LocationLocalDatasource implements ILocationLocalDatasource {
  @override
  Future<List<LocationModel>> getLocations() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonArray = prefs.getStringList(PrefsConstants.locationsKey);

    if (jsonArray == null) return [];

    return jsonArray
        .map((e) => jsonDecode(e))
        .map((e) => LocationModel.fromMap(e))
        .toList();
  }

  @override
  Future<bool> saveLocations(List<LocationModel> locations) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setStringList(
      PrefsConstants.locationsKey,
      locations.map((e) => jsonEncode(e.toMap())).toList(),
    );
  }

  @override
  Future<bool> hasLocations() async {
    final prefs = await SharedPreferences.getInstance();
    final locations = prefs.getStringList(PrefsConstants.locationsKey);
    return locations != null && locations.isNotEmpty;
  }
}
