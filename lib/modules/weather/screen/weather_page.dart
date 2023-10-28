import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/common/app_constants.dart';
import 'package:weather_app/common/general_utils/app_toast.dart';
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
import 'package:weather_app/modules/weather/widget/weather_stat_grid_tile.dart';
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
  void initState() {
    ref.listenManual(weatherProvider(location), (previous, next) {
      if (next is AsyncError) {
        AppToast.showError(next.asError?.error.toString() ?? '');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final weather = ref.watch(weatherProvider(location)
        .select((value) => value.value ?? const Weather.empty()));

    final degreeType =
        ref.watch(settingProvider.select((value) => value.degreeType));

    return RefreshIndicator.adaptive(
      onRefresh: () {
        return ref.refresh(weatherProvider(location).future);
      },
      child: SingleChildScrollView(
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
                color: AppColors.primary,
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
            GridView(
              physics: NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              children: [
                WeatherStatGridTile(
                  label: 'UV',
                  stat: '${weather.uv} ',
                  description: '',
                ),
                WeatherStatGridTile(
                    label: 'Humidity',
                    stat: '${weather.humidity}%',
                    description: ''),
                WeatherStatGridTile(
                    label: 'Humidity',
                    stat: '${weather.humidity}%',
                    description: ''),
              ],
            ),
            SevenDaysForecastWidget(location),
            AppButton(
              buttonColor: AppColors.red,
              child: Text(
                'Remove this location',
                style: TextStyle(color: AppColors.white),
              ),
              onTap: () {
                ref
                    .read(localLocationsProvider.notifier)
                    .removeLocation(location);
              },
            ),
            SizedBox(
              height: 40,
            )
          ],
        ),
      ),
    );
  }
}
