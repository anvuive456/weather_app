import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/core/model/base_state.dart';
import 'package:weather_app/features/location/data/datasources/location_local_datasource.dart';
import 'package:weather_app/features/location/data/datasources/location_remote_datasource.dart';
import 'package:weather_app/features/location/data/models/location_model.dart';
import 'package:weather_app/features/location/data/repositories/location_repository_impl.dart';
import 'package:weather_app/features/location/domain/usecases/add_location_usecase.dart';
import 'package:weather_app/features/location/domain/usecases/get_local_locations_usecase.dart';
import 'package:weather_app/features/location/domain/usecases/remove_location_usecase.dart';
import 'package:weather_app/features/location/domain/usecases/search_locations_usecase.dart';
import 'package:weather_app/features/setting/presentation/providers/setting_provider.dart';
import 'package:weather_app/core/utils/extension.dart';
import 'package:weather_app/core/utils/debouncer.dart';

// Datasource providers
final locationRemoteDatasourceProvider =
    Provider<ILocationRemoteDatasource>((ref) {
  return const LocationRemoteDatasource();
});

final locationLocalDatasourceProvider =
    Provider<ILocationLocalDatasource>((ref) {
  return LocationLocalDatasource();
});

// Repository provider
final locationRepositoryProvider = Provider<LocationRepositoryImpl>((ref) {
  return LocationRepositoryImpl(
    ref.watch(locationRemoteDatasourceProvider),
    ref.watch(locationLocalDatasourceProvider),
  );
});

// Use case providers
final getLocalLocationsUseCaseProvider =
    Provider<GetLocalLocationsUseCase>((ref) {
  return GetLocalLocationsUseCase(ref.watch(locationRepositoryProvider));
});

final addLocationUseCaseProvider = Provider<AddLocationUseCase>((ref) {
  return AddLocationUseCase(ref.watch(locationRepositoryProvider));
});

final removeLocationUseCaseProvider = Provider<RemoveLocationUseCase>((ref) {
  return RemoveLocationUseCase(ref.watch(locationRepositoryProvider));
});

final searchLocationsUseCaseProvider =
    Provider<SearchLocationsUseCase>((ref) {
  return SearchLocationsUseCase(ref.watch(locationRepositoryProvider));
});

// ─── Local Locations ─────────────────────────────────────────────────────────

class LocalLocationsState extends BaseState {
  final List<LocationModel> locations;

  bool get hasOneLeft => locations.length == 1;

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
  String toString() => 'LocalLocationsState{ locations: $locations }';

  LocalLocationsState copyWith(
      {List<LocationModel>? locations, String? error, bool? loading}) {
    return LocalLocationsState(
      error: error,
      loading: loading ?? this.loading,
      locations: locations ?? this.locations,
    );
  }
}

class LocalLocationsNotifier extends StateNotifier<LocalLocationsState> {
  LocalLocationsNotifier(this._getLocations, this._addLocation,
      this._removeLocation)
      : super(const LocalLocationsState.init());

  final GetLocalLocationsUseCase _getLocations;
  final AddLocationUseCase _addLocation;
  final RemoveLocationUseCase _removeLocation;

  void init() async {
    final locations = await _getLocations();
    state = state.copyWith(locations: locations);
  }

  void addLocation(LocationModel location) async {
    try {
      await _addLocation(location);
      final locations = await _getLocations();
      state = state.copyWith(locations: locations);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  void removeLocation(LocationModel location) async {
    try {
      await _removeLocation(location);
      final locations = await _getLocations();
      state = state.copyWith(locations: locations);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}

final localLocationsProvider =
    StateNotifierProvider<LocalLocationsNotifier, LocalLocationsState>((ref) {
  final notifier = LocalLocationsNotifier(
    ref.watch(getLocalLocationsUseCaseProvider),
    ref.watch(addLocationUseCaseProvider),
    ref.watch(removeLocationUseCaseProvider),
  );
  notifier.init();
  return notifier;
});

// ─── Search Location ──────────────────────────────────────────────────────────

class SearchLocationState extends BaseState {
  final String searchText;
  final List<LocationModel> locations;

  bool get noLocationFound => searchText.isNotEmpty && locations.isEmpty;

  const SearchLocationState.init({
    this.searchText = '',
    this.locations = const [],
    super.error,
    super.loading = false,
  });

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
  int get hashCode =>
      searchText.hashCode ^ locations.hashCode ^ super.hashCode;

  @override
  String toString() {
    return 'SearchLocationState{ searchText:$searchText, locations:$locations, loading:$loading, error:$error}';
  }

  SearchLocationState copyWith({
    String? searchText,
    List<LocationModel>? locations,
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
}

class SearchLocationNotifier extends StateNotifier<SearchLocationState> {
  SearchLocationNotifier(this._searchUseCase, [this.lang = ''])
      : super(const SearchLocationState.init());

  final SearchLocationsUseCase _searchUseCase;
  final String lang;
  final _debouncer = Debouncer(delay: 800);

  void find(String text) async {
    if (text.isBlank) {
      state = const SearchLocationState.init();
      _debouncer.cancel();
      return;
    }

    _debouncer.run(() {
      state = state.copyWith(searchText: text, loading: true);
      _getLocations();
    });
  }

  void _getLocations() async {
    await _searchUseCase(state.searchText, lang: lang).then((value) {
      state = state.copyWith(locations: value);
    }).onError((error, stackTrace) {
      state = state.copyWith(error: error.toString());
    }).whenComplete(() {
      state = state.copyWith(loading: false);
    });
  }
}

final searchLocationProvider =
    StateNotifierProvider<SearchLocationNotifier, SearchLocationState>((ref) {
  final lang =
      ref.watch(settingProvider.select((value) => value.language.code));
  return SearchLocationNotifier(
    ref.watch(searchLocationsUseCaseProvider),
    lang,
  );
});
