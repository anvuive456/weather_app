import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/common/mixin/conversion_mixin.dart';
import 'package:weather_app/common/widget/weather_icon.dart';
import 'package:weather_app/features/setting/presentation/providers/setting_provider.dart';
import 'package:weather_app/features/weather/data/models/forecast_model.dart';
import 'package:weather_app/resources/color.dart';

class ForecastDayTile extends ConsumerStatefulWidget {
  final ForecastModel forecast;
  final int staggerIndex;

  const ForecastDayTile(
      {super.key, required this.forecast, this.staggerIndex = 0});

  @override
  ConsumerState<ForecastDayTile> createState() => _ForecastDayTileState();
}

class _ForecastDayTileState extends ConsumerState<ForecastDayTile>
    with SingleTickerProviderStateMixin, ConversionMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _opacityAnim = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    Future.delayed(Duration(milliseconds: widget.staggerIndex * 60), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String getDateText(DateTime date) {
    if (date.day == DateTime.now().day) return 'Today';
    return DateFormat('EEEE').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final degreeType =
        ref.watch(settingProvider.select((value) => value.degreeType));
    final day = widget.forecast.day;

    return FadeTransition(
      opacity: _opacityAnim,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            SizedBox(
              width: 80,
              child: Text(
                getDateText(widget.forecast.parsedDate),
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            WeatherIcon(url: day.condition.iconUrl, size: 24),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                day.condition.text,
                style: const TextStyle(fontSize: 12, color: Colors.white70),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              getDegree(degreeType, day.mintempC, day.mintempF),
              style: const TextStyle(fontSize: 13, color: Colors.white60),
            ),
            const SizedBox(width: 6),
            _TempBar(),
            const SizedBox(width: 6),
            Text(
              getDegree(degreeType, day.maxtempC, day.maxtempF),
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.tempColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TempBar extends StatelessWidget {
  const _TempBar();

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOut,
      builder: (context, value, _) {
        return Container(
          width: 60 * value,
          height: 4,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            gradient: const LinearGradient(
              colors: [Colors.white38, AppColors.tempColor],
            ),
          ),
        );
      },
    );
  }
}

class ForecastHourTile extends ConsumerStatefulWidget {
  final HourForecastModel hour;
  final int staggerIndex;

  const ForecastHourTile(
      {super.key, required this.hour, this.staggerIndex = 0});

  @override
  ConsumerState<ForecastHourTile> createState() => _ForecastHourTileState();
}

class _ForecastHourTileState extends ConsumerState<ForecastHourTile>
    with SingleTickerProviderStateMixin, ConversionMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _opacityAnim = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    Future.delayed(Duration(milliseconds: widget.staggerIndex * 80), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String getHourText(DateTime time) {
    if (time.hour == DateTime.now().hour) return 'Now';
    return DateFormat('j').format(time);
  }

  @override
  Widget build(BuildContext context) {
    final degreeType =
        ref.watch(settingProvider.select((value) => value.degreeType));
    final measureType =
        ref.watch(settingProvider.select((value) => value.measureType));
    final isNow = widget.hour.parsedTime.hour == DateTime.now().hour;

    return FadeTransition(
      opacity: _opacityAnim,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: isNow ? AppColors.accent.withAlpha(30) : Colors.white10,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isNow ? AppColors.accent.withAlpha(80) : Colors.white12,
          ),
        ),
        child: Column(
          children: [
            Text(
              getHourText(widget.hour.parsedTime),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isNow ? AppColors.accent : Colors.white70,
              ),
            ),
            const SizedBox(height: 6),
            WeatherIcon(url: widget.hour.condition.iconUrl, size: 24),
            const SizedBox(height: 4),
            Text(
              getDegree(degreeType, widget.hour.tempC, widget.hour.tempF),
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(CupertinoIcons.wind,
                    size: 12, color: Colors.white54),
                const SizedBox(width: 2),
                Text(
                  getMeasure(
                      measureType, widget.hour.windKph, widget.hour.windMph,
                      true),
                  style: const TextStyle(fontSize: 10, color: Colors.white54),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(CupertinoIcons.drop,
                    size: 12, color: AppColors.accent),
                const SizedBox(width: 2),
                Text(
                  '${widget.hour.willItRain}%',
                  style: const TextStyle(fontSize: 10, color: AppColors.accent),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
