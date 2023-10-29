import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/common/app_constants.dart';
import 'package:weather_app/common/model/base_state.dart';
import 'package:weather_app/common/model/location.dart';

class LocalLocationsState extends BaseState {
  final List<Location> locations;

  bool get hasOneLeft => locations.length == 1;

//<editor-fold desc="Data Methods">
  const LocalLocationsState.init({
    this.locations = const [],
    super.error,
    super.loading = false,
  });

  const LocalLocationsState({
    required this.locations,
    super.error,
    required super.loading,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalLocationsState &&
          runtimeType == other.runtimeType &&
          locations == other.locations);

  @override
  int get hashCode => locations.hashCode;

  @override
  String toString() {
    return 'LocalLocationsState{ locations: $locations,}';
  }

  LocalLocationsState copyWith(
      {List<Location>? locations, String? error, bool? loading}) {
    return LocalLocationsState(
      error: error,
      loading: loading ?? this.loading,
      locations: locations ?? this.locations,
    );
  }

//</editor-fold>
}

class LocalLocationsNotifier extends StateNotifier<LocalLocationsState> {
  LocalLocationsNotifier() : super(const LocalLocationsState.init());
  late SharedPreferences _prefs;

  void init() async {
    await _initSharedPrefs();
    _getLocalLocations();
  }

  Future<void> _initSharedPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  void _getLocalLocations() async {
    final jsonArray = _prefs.getStringList(PrefsConstants.locationsKey);

    if (jsonArray == null) {
      state = state.copyWith(locations: []);
      return;
    }

    final locations = jsonArray
        .map((e) => jsonDecode(e))
        .map((e) => Location.fromMap(e))
        .toList();

    state = state.copyWith(locations: locations);
  }

  ///Sometime you get _prefs is not initialized
  ///
  /// Then you have to use Future wrapper like Future.delay in that function
  void addLocation(Location location) async {
    if (state.locations.contains(location)) {
      state = state.copyWith(error: 'This location is already added');
      return;
    }
    state = state.copyWith(locations: [...state.locations, location]);
    final added = await _prefs.setStringList(PrefsConstants.locationsKey,
        state.locations.map((e) => jsonEncode(e.toMap())).toList());

    if (!added) {
      state = state.copyWith(error: 'Couldn\'t add location. Please try again');
    }
  }

  void removeLocation(Location location) async {
    if (!state.locations.contains(location)) {
      state = state.copyWith(error: 'This location is not added');
      return;
    }

    state = state.copyWith(
        locations:
            state.locations.where((element) => element != location).toList());
    final added = await _prefs.setStringList(PrefsConstants.locationsKey,
        state.locations.map((e) => jsonEncode(e.toMap())).toList());

    if (!added) {
      state =
          state.copyWith(error: 'Couldn\'t remove location. Please try again');
    }
  }
}

var localLocationsProvider =
    StateNotifierProvider<LocalLocationsNotifier, LocalLocationsState>((ref) {
  final notifier = LocalLocationsNotifier();
  notifier.init();

  return notifier;
});
