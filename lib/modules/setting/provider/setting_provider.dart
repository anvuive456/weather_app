import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/common/app_constants.dart';

class SettingState {
  final DegreeType degreeType;
  final MeasureType measureType;

  const SettingState.init({
    this.degreeType = DegreeType.celsius,
    this.measureType = MeasureType.km,
  });

//<editor-fold desc="Data Methods">
  const SettingState({
    required this.degreeType,
    required this.measureType,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SettingState &&
          runtimeType == other.runtimeType &&
          degreeType == other.degreeType &&
          measureType == other.measureType);

  @override
  int get hashCode => degreeType.hashCode ^ measureType.hashCode;

  @override
  String toString() {
    return 'SettingState{degreeType: $degreeType, measureType: $measureType}';
  }

  SettingState copyWith({
    DegreeType? degreeType,
    MeasureType? measureType,
  }) {
    return SettingState(
      measureType: measureType ?? this.measureType,
      degreeType: degreeType ?? this.degreeType,
    );
  }

//</editor-fold>
}

class SettingNotifier extends StateNotifier<SettingState> {
  SettingNotifier() : super(const SettingState.init());

  void changeDegreeType(DegreeType type) {
    state = state.copyWith(degreeType: type);
  }

  void changeMeasureType(MeasureType type) {
    state = state.copyWith(measureType: type);
  }
}

var settingProvider =
    StateNotifierProvider<SettingNotifier, SettingState>((ref) {
  final notifier = SettingNotifier();

  return notifier;
});
