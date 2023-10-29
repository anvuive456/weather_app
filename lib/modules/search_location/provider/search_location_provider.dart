import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/common/general_utils/extension.dart';
import 'package:weather_app/common/network/app_respsonse.dart';
import 'package:weather_app/modules/setting/provider/setting_provider.dart';

import '../../../common/general_utils/debouncer.dart';
import '../../../common/model/base_state.dart';
import '../../../common/model/location.dart';
import '../../../common/service/location_service.dart';

class SearchLocationState extends BaseState {
  final String searchText;
  final List<Location> locations;

  bool get noLocationFound => searchText.isNotEmpty && locations.isEmpty;

  const SearchLocationState.init({
    this.searchText = '',
    this.locations = const [],
    super.error,
    super.loading = false,
  });

//<editor-fold desc="Data Methods">
  SearchLocationState({
    required this.searchText,
    required this.locations,
    super.error,
    required super.loading,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SearchLocationState &&
          runtimeType == other.runtimeType &&
          searchText == other.searchText &&
          locations == other.locations &&
          loading == other.loading &&
          error == other.error);

  @override
  int get hashCode => searchText.hashCode ^ locations.hashCode ^ super.hashCode;

  @override
  String toString() {
    return 'SearchLocationState{ searchText:$searchText, locations:$locations, loading:$loading, error:$error}';
  }

  SearchLocationState copyWith({
    String? searchText,
    List<Location>? locations,
    String? error,
    bool? loading,
  }) {
    return SearchLocationState(
      error: error,
      loading: loading ?? this.loading,
      searchText: searchText ?? this.searchText,
      locations: locations ?? this.locations,
    );
  }

//</editor-fold>
}

class SearchLocationNotifier extends StateNotifier<SearchLocationState> {
  SearchLocationNotifier(
      [this._locationService = const LocationService(), this.lang = ''])
      : super(const SearchLocationState.init());
  final LocationService _locationService;
  final String lang;

  final _debouncer = Debouncer(delay: 800);

  void find(String text) async {
    if (text.isBlank) {
      state = const SearchLocationState.init();

      //Cancel the debounce so it won't get the last fetch
      _debouncer.cancel();
      return;
    }

    _debouncer.run(() {
      state = state.copyWith(searchText: text, loading: true);
      _getLocations();
    });
  }

  void _getLocations() async {
    await _locationService.getLocations(state.searchText).then((value) {
      state = state.copyWith(locations: value);
    }).onError((error, stackTrace) {
      state = state.copyWith(error: error.toString());
    }).whenComplete(() {
      state = state.copyWith(loading: false);
    });
  }
}

var searchLocationProvider =
    StateNotifierProvider<SearchLocationNotifier, SearchLocationState>((ref) {
  String lang =
      ref.watch(settingProvider.select((value) => value.language.code));

  return SearchLocationNotifier(
    LocationService(),
    lang
  );
});
