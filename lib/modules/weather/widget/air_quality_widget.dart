import 'package:flutter/material.dart';
import 'package:weather_app/common/general_utils/extension.dart';
import 'package:weather_app/common/model/weather.dart';
import 'package:weather_app/resources/color.dart';
import 'package:weather_app/resources/string.dart';

class AirQualityWidget extends StatelessWidget {
  final AirQuality aqi;

  const AirQualityWidget({super.key, required this.aqi});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      padding: const EdgeInsets.all(10),
      decoration: ShapeDecoration(
        color: AppColors.primary.lighten(.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Column(
        children: [
          Text(
            AppString.labelAirQualitiyIndex,
            style: TextStyle(fontSize: 14, color: AppColors.white),
          ),
          Text(
            aqi.pm10.toString(),
            style: TextStyle(color: AppColors.white, fontSize: 20),
          ),

        ],
      ),
    );
  }
}
