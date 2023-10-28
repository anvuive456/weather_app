import 'package:flutter/material.dart';
import 'package:weather_app/resources/color.dart';

class WeatherStatGridTile extends StatelessWidget {
  final String label;
  final String stat;
  final String description;

  const WeatherStatGridTile(
      {super.key,
      required this.label,
      required this.stat,
      required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
            side: BorderSide(color: AppColors.primary),
            borderRadius: BorderRadius.circular(15)),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
            ),
          ),
          Text(
            stat,
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}
