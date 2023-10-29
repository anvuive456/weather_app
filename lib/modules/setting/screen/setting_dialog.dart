import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/resources/string.dart';

import '../../../common/app_constants.dart';
import '../provider/setting_provider.dart';

class SettingDialog extends ConsumerWidget {
  const SettingDialog({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final currDegree =
        ref.watch(settingProvider.select((value) => value.degreeType));
    final currMeasure =
        ref.watch(settingProvider.select((value) => value.measureType));
    final currLang =
        ref.watch(settingProvider.select((value) => value.language));
    final settingNotifier = ref.read(settingProvider.notifier);

    return Dialog(
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              AppString.settingLabelDegree,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          for (final type in DegreeType.values)
            RadioListTile<DegreeType>(
              groupValue: currDegree,
              value:  type,
              title: Text(type.name),
              onChanged: (value) {
                if (value != null) {
                  settingNotifier.changeDegreeType(type);
                }
              },
            ),
          const Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              AppString.settingLabelMeasure,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          for (final type in MeasureType.values)
            RadioListTile<MeasureType>(
              groupValue: currMeasure,
              value: type,
              title: Text(type.name),
              onChanged: (value) {
                if (value != null) {
                  settingNotifier.changeMeasureType(type);
                }
              },
            ),
          const Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              AppString.settingLabelLanguage,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          for (final type in AppLanguage.values)
            RadioListTile<AppLanguage>(
              groupValue: currLang,
              value: type,
              title: Text(type.title),
              onChanged: (value) {
                if (value != null) {
                  settingNotifier.changeLanguage(type);
                }
              },
            ),

        ],
      ),
    );
  }
}
