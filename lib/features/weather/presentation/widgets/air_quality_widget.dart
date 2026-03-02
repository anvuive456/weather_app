import 'package:flutter/material.dart';
import 'package:weather_app/common/widget/glass_card.dart';
import 'package:weather_app/features/weather/data/models/weather_model.dart';
import 'package:weather_app/resources/color.dart';
import 'package:weather_app/resources/string.dart';

class AirQualityWidget extends StatelessWidget {
  final AirQualityModel aqi;

  const AirQualityWidget({super.key, required this.aqi});

  Color get _aqiColor {
    final index = aqi.usEpaIndex;
    if (index <= 2) return AppColors.aqiGood;
    if (index <= 4) return AppColors.aqiModerate;
    return AppColors.aqiUnhealthy;
  }

  String get _aqiLabel {
    final index = aqi.usEpaIndex;
    if (index == 1) return 'Good';
    if (index == 2) return 'Moderate';
    if (index == 3) return 'Unhealthy for sensitive';
    if (index == 4) return 'Unhealthy';
    if (index == 5) return 'Very Unhealthy';
    return 'Hazardous';
  }

  double get _aqiProgress => (aqi.usEpaIndex / 6).clamp(0.0, 1.0);

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppString.labelAirQualitiyIndex,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.white70,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _aqiColor.withAlpha(40),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _aqiColor.withAlpha(100)),
                ),
                child: Text(
                  _aqiLabel,
                  style: TextStyle(
                    fontSize: 12,
                    color: _aqiColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text(
                'PM10: ',
                style: TextStyle(color: Colors.white60, fontSize: 13),
              ),
              Text(
                '${aqi.pm10.toStringAsFixed(1)} µg/m³',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 16),
              const Text(
                'PM2.5: ',
                style: TextStyle(color: Colors.white60, fontSize: 13),
              ),
              Text(
                '${aqi.pm25.toStringAsFixed(1)} µg/m³',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: _aqiProgress),
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOut,
            builder: (context, value, _) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: value,
                  minHeight: 8,
                  backgroundColor: Colors.white12,
                  valueColor: AlwaysStoppedAnimation(_aqiColor),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
