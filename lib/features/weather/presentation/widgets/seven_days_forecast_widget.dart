import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/common/widget/glass_card.dart';
import 'package:weather_app/features/location/data/models/location_model.dart';
import 'package:weather_app/features/weather/presentation/providers/weather_provider.dart';
import 'package:weather_app/features/weather/presentation/widgets/forecast_tile.dart';
import 'package:weather_app/resources/color.dart';
import 'package:weather_app/resources/string.dart';

class SevenDaysForecastWidget extends ConsumerWidget {
  final LocationModel location;

  const SevenDaysForecastWidget(this.location, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final forecasts = ref.watch(sevenDaysForecastProvider(location));
    return GlassCard(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.calendar_today_rounded,
                  size: 14, color: Colors.white60),
              const SizedBox(width: 6),
              const Text(
                AppString.label7daysForecast,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...forecasts.maybeWhen(
            orElse: () => [
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: CircularProgressIndicator(
                      color: AppColors.accent, strokeWidth: 2),
                ),
              )
            ],
            error: (error, stackTrace) {
              return [
                TextButton.icon(
                  onPressed: () =>
                      ref.invalidate(sevenDaysForecastProvider(location)),
                  icon: const Icon(Icons.refresh, color: AppColors.accent),
                  label: const Text(AppString.msgRefresh,
                      style: TextStyle(color: AppColors.accent)),
                )
              ];
            },
            data: (data) {
              return data
                  .asMap()
                  .entries
                  .map((e) =>
                      ForecastDayTile(forecast: e.value, staggerIndex: e.key))
                  .toList();
            },
          ),
        ],
      ),
    );
  }
}
