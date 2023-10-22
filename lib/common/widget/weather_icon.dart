import 'package:flutter/material.dart';

class WeatherIcon extends StatelessWidget {
  final String url;
  final double? size;

  const WeatherIcon({
    super.key,
    required this.url,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      height: size,
      width: size,
      errorBuilder: (context, error, stackTrace) => SizedBox.square(
        dimension: size,
      ),
    );
  }
}
