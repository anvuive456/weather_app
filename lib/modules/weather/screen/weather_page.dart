import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/common/app_constants.dart';
import 'package:weather_app/common/mixin/conversion_mixin.dart';
import 'package:weather_app/common/model/current_weather_response.dart';
import 'package:weather_app/common/model/weather.dart';
import 'package:weather_app/common/model/weather_location.dart';
import 'package:weather_app/common/widget/app_button.dart';
import 'package:weather_app/modules/setting/provider/setting_provider.dart';
import 'package:weather_app/modules/weather/provider/local_location_provider.dart';
import 'package:weather_app/modules/weather/provider/weather_provider.dart';
import 'package:weather_app/modules/weather/widget/seven_days_forecast_widget.dart';
import 'package:weather_app/modules/weather/widget/today_forecast_widget.dart';
import 'package:weather_app/resources/color.dart';

import '../../../common/model/location.dart';

class WeatherPage extends ConsumerStatefulWidget {
  final Location location;

  const WeatherPage(this.location, {super.key});

  @override
  ConsumerState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends ConsumerState<WeatherPage>
    with ConversionMixin {
  Location get location => widget.location;

  @override
  Widget build(BuildContext context) {
    final weather = ref.watch(weatherProvider(location)
        .select((value) => value.value ?? const Weather.empty()));

    final degreeType =
        ref.watch(settingProvider.select((value) => value.degreeType));

    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            location.name,
            style: const TextStyle(fontSize: 28),
          ),
          Text(location.country),
          Text(
            getDegree(degreeType, weather.tempC, weather.tempF),
            style: const TextStyle(
              fontSize: 48,
              color: kPrimaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            weather.condition.text,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(
            height: 20,
          ),
          TodayForecastWidget(location),
          SevenDaysForecastWidget(location),
          AppButton(
            buttonColor: kRedColor,
            child: Text('Remove this location',style: TextStyle(
              color: kWhiteColor
            ),),
            onTap: () {
              ref
                  .read(localLocationsProvider.notifier)
                  .removeLocation(location);
            },
          ),
          SizedBox(height: 40,)
        ],
      ),
    );
  }
}
