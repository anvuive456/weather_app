import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/common/model/forecast.dart';
import 'package:weather_app/common/model/location.dart';
import 'package:weather_app/modules/weather/provider/weather_provider.dart';
import 'package:weather_app/modules/weather/widget/forecast_tile.dart';
import 'package:weather_app/resources/color.dart';
import 'package:weather_app/resources/string.dart';

class TodayForecastWidget extends ConsumerWidget {
  final Location location;
  const TodayForecastWidget(this.location, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final forecast = ref.watch(todayForecastProvider(location));
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.lightGrey
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            AppString.labelTodayForecast,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600
            ),
          ),
          forecast.maybeWhen(
            error: (error, stackTrace) {
              print(error);
              print(stackTrace);
              return TextButton(onPressed: () {
                ref.invalidate(todayForecastProvider(location));
              }, child: const Text(AppString.msgRefresh));
            },
            orElse: () => const SizedBox.shrink(),
            data:(data) =>  SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (var hour in data.hour)
                    ForecastHourTile(hour: hour)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
