import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/common/widget/glass_card.dart';
import 'package:weather_app/features/location/data/models/location_model.dart';
import 'package:weather_app/features/weather/presentation/providers/weather_provider.dart';
import 'package:weather_app/features/weather/presentation/widgets/forecast_tile.dart';
import 'package:weather_app/resources/color.dart';
import 'package:weather_app/resources/string.dart';

class TodayForecastWidget extends ConsumerWidget {
  final LocationModel location;

  const TodayForecastWidget(this.location, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final forecast = ref.watch(todayForecastProvider(location));
    return GlassCard(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.access_time_rounded,
                  size: 14, color: Colors.white60),
              const SizedBox(width: 6),
              const Text(
                AppString.labelTodayForecast,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          forecast.maybeWhen(
            error: (error, stackTrace) {
              return TextButton.icon(
                onPressed: () =>
                    ref.invalidate(todayForecastProvider(location)),
                icon: const Icon(Icons.refresh, color: AppColors.accent),
                label: const Text(AppString.msgRefresh,
                    style: TextStyle(color: AppColors.accent)),
              );
            },
            orElse: () => const Center(
              child: SizedBox(
                height: 60,
                child: CircularProgressIndicator(
                  color: AppColors.accent,
                  strokeWidth: 2,
                ),
              ),
            ),
            data: (data) {
              final hours = data.hour
                  .where((e) =>
                      e.parsedTime.hour.compareTo(DateTime.now().hour) >= 0)
                  .toList();
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (var i = 0; i < hours.length; i++)
                      ForecastHourTile(hour: hours[i], staggerIndex: i),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
