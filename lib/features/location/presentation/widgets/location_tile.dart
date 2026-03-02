import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/common/mixin/conversion_mixin.dart';
import 'package:weather_app/common/widget/glass_card.dart';
import 'package:weather_app/common/widget/weather_icon.dart';
import 'package:weather_app/features/location/data/models/location_model.dart';
import 'package:weather_app/features/setting/presentation/providers/setting_provider.dart';
import 'package:weather_app/features/weather/data/models/weather_model.dart';
import 'package:weather_app/features/weather/presentation/providers/weather_provider.dart';
import 'package:weather_app/resources/color.dart';

class LocationTile extends ConsumerStatefulWidget {
  final LocationModel location;
  final VoidCallback onTap;
  final int staggerIndex;

  const LocationTile({
    super.key,
    required this.location,
    required this.onTap,
    this.staggerIndex = 0,
  });

  @override
  ConsumerState<LocationTile> createState() => _LocationTileState();
}

class _LocationTileState extends ConsumerState<LocationTile>
    with SingleTickerProviderStateMixin, ConversionMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0.1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _fadeAnim =
        CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    Future.delayed(Duration(milliseconds: widget.staggerIndex * 60), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final weather = ref.watch(weatherProvider(widget.location)
        .select((value) => value.value ?? const WeatherModel.empty()));
    final condition = ref.watch(weatherProvider(widget.location).select(
        (value) =>
            value.value?.condition ?? const ConditionModel.empty()));
    final degreeType =
        ref.watch(settingProvider.select((value) => value.degreeType));

    return FadeTransition(
      opacity: _fadeAnim,
      child: SlideTransition(
        position: _slideAnim,
        child: GestureDetector(
          onTap: widget.onTap,
          child: GlassCard(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.location.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.location.country,
                        style: const TextStyle(
                            fontSize: 13, color: Colors.white54),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        getDegree(degreeType, weather.tempC, weather.tempF),
                        style: const TextStyle(
                          fontSize: 22,
                          color: AppColors.tempColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    WeatherIcon(size: 40, url: condition.iconUrl),
                    const SizedBox(height: 4),
                    SizedBox(
                      width: 80,
                      child: Text(
                        condition.text,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 12, color: Colors.white70),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
