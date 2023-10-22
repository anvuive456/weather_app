import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/common/app_constants.dart';
import 'package:weather_app/common/general_utils/highlight_occurences.dart';
import 'package:weather_app/common/mixin/conversion_mixin.dart';
import 'package:weather_app/common/model/location.dart';
import 'package:weather_app/common/model/weather.dart';
import 'package:weather_app/common/service/weather_service.dart';
import 'package:weather_app/common/widget/weather_icon.dart';
import 'package:weather_app/modules/setting/provider/setting_provider.dart';
import 'package:weather_app/modules/weather/provider/weather_provider.dart';
import 'package:weather_app/resources/color.dart';



class LocationTile extends ConsumerWidget with ConversionMixin{
  final Location location;
  final VoidCallback onTap;
  final String? searchText;

  const LocationTile(
      {super.key,
      required this.location,
      required this.onTap,
      this.searchText});

  @override
  Widget build(BuildContext context, ref) {
    final weather = ref.watch(weatherProvider(location)
        .select((value) => value.value ?? const Weather.empty()));

    final condition = ref.watch(weatherProvider(location)
        .select((value) => value.value?.condition ?? const Condition.empty()));

    final degreeType =
        ref.watch(settingProvider.select((value) => value.degreeType));
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        isThreeLine: true,
        title: Text.rich(TextSpan(
            children: highlightOccurrences(location.name, searchText))),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(location.country,style: const TextStyle(
              fontSize: 14,
              color: kGreyText
            ),),
            const SizedBox(height: 10,),
            Text(
              getDegree(
                degreeType,
                weather.tempC,
                weather.tempF,
              ),
              style: const TextStyle(
                fontSize: 18,
                  color: kDarkGrey,
                  fontWeight: FontWeight.w800
              ),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: WeatherIcon(
                size: 24,
                url: condition.iconUrl,
              ),
            ),
            Text(
              condition.text,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14,
                  ),
            ),
          ],
        ),
      ),
    );
  }


}
