import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/common/model/location.dart';
import 'package:weather_app/modules/weather/provider/weather_provider.dart';
import 'package:weather_app/modules/weather/widget/forecast_tile.dart';
import 'package:weather_app/resources/string.dart';

class SevenDaysForecastWidget extends ConsumerWidget {
  final Location location;

  const SevenDaysForecastWidget(this.location, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final forcasts = ref.watch(sevenDaysForecastProvider(location));
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppString.label7daysForecast,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          ...forcasts.maybeWhen(
            orElse: () => [SizedBox.shrink()],
            error: (error, stackTrace) {
              return [TextButton(onPressed: () {
                ref.invalidate(sevenDaysForecastProvider(location));
              }, child: const Text(AppString.msgRefresh))];
            },
            data: (data) {
              return data.map((e) => ForecastDayTile(forecast: e)).toList();
            },
          )
        ],
      ),
    );
  }
}
