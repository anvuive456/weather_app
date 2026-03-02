import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/common/mixin/conversion_mixin.dart';
import 'package:weather_app/common/widget/glass_card.dart';
import 'package:weather_app/common/widget/weather_icon.dart';
import 'package:weather_app/core/constants/app_constants.dart';
import 'package:weather_app/core/utils/app_toast.dart';
import 'package:weather_app/features/location/data/models/location_model.dart';
import 'package:weather_app/features/location/presentation/providers/location_providers.dart';
import 'package:weather_app/features/setting/presentation/providers/setting_provider.dart';
import 'package:weather_app/features/weather/data/models/forecast_model.dart';
import 'package:weather_app/features/weather/data/models/weather_model.dart';
import 'package:weather_app/features/weather/presentation/providers/weather_provider.dart';
import 'package:weather_app/features/weather/presentation/widgets/air_quality_widget.dart';
import 'package:weather_app/features/weather/presentation/widgets/seven_days_forecast_widget.dart';
import 'package:weather_app/features/weather/presentation/widgets/today_forecast_widget.dart';
import 'package:weather_app/features/weather/presentation/widgets/weather_stat_grid_tile.dart';
import 'package:weather_app/resources/color.dart';

class WeatherPage extends ConsumerStatefulWidget {
  final LocationModel location;

  const WeatherPage(this.location, {super.key});

  @override
  ConsumerState createState() => _WeatherPageState();
}

class _WeatherPageState extends ConsumerState<WeatherPage>
    with ConversionMixin, SingleTickerProviderStateMixin {
  LocationModel get location => widget.location;

  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim =
        CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _animController, curve: Curves.easeOut));

    ref.listenManual(weatherProvider(location), (previous, next) {
      if (next is AsyncError) {
        AppToast.showError(next.asError?.error.toString() ?? '');
      }
      if (next is AsyncData) {
        _animController.forward(from: 0);
      }
    }, fireImmediately: true);
    super.initState();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final asyncWeather = ref.watch(weatherProvider(location));
    final weather = asyncWeather.value ?? const WeatherModel.empty();
    final degreeType =
        ref.watch(settingProvider.select((value) => value.degreeType));
    final measureType =
        ref.watch(settingProvider.select((value) => value.measureType));

    return RefreshIndicator.adaptive(
      color: AppColors.accent,
      onRefresh: () {
        // Invalidate cache so the next fetch always hits the network.
        ref
            .read(weatherRepositoryProvider)
            .invalidateLocation(location.lat, location.lon);
        ref.invalidate(weatherProvider(location));
        ref.invalidate(todayForecastProvider(location));
        ref.invalidate(sevenDaysForecastProvider(location));
        return ref.refresh(weatherProvider(location).future);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: asyncWeather.maybeWhen(
            orElse: () => const _LoadingView(),
            data: (data) => FadeTransition(
              opacity: _fadeAnim,
              child: SlideTransition(
                position: _slideAnim,
                child: _DataView(
                  location: location,
                  weather: weather,
                  degreeType: degreeType,
                  measureType: measureType,
                  onRemove: () => ref
                      .read(localLocationsProvider.notifier)
                      .removeLocation(location),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 400,
      child: Center(
          child: CircularProgressIndicator(color: AppColors.accent)),
    );
  }
}

class _DataView extends ConsumerWidget with ConversionMixin {
  final LocationModel location;
  final WeatherModel weather;
  final DegreeType degreeType;
  final MeasureType measureType;
  final VoidCallback onRemove;

  const _DataView({
    required this.location,
    required this.weather,
    required this.degreeType,
    required this.measureType,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todayForecast =
        ref.watch(todayForecastProvider(location)).value;

    return Column(
      children: [
        const SizedBox(height: 16),
        _HeaderSection(
          location: location,
          weather: weather,
          degreeType: degreeType,
          measureType: measureType,
        ),
        const SizedBox(height: 20),
        TodayForecastWidget(location),
        const SizedBox(height: 12),
        if (weather.airQuality != null) ...[
          AirQualityWidget(aqi: weather.airQuality!),
          const SizedBox(height: 12),
        ],
        _StatsGrid(weather: weather, measureType: measureType),
        const SizedBox(height: 12),
        if (todayForecast != null)
          _SunriseSunsetSection(astro: todayForecast.astro),
        const SizedBox(height: 12),
        SevenDaysForecastWidget(location),
        const SizedBox(height: 20),
        _RemoveButton(onTap: onRemove),
        const SizedBox(height: 40),
      ],
    );
  }
}

class _HeaderSection extends StatelessWidget with ConversionMixin {
  final LocationModel location;
  final WeatherModel weather;
  final DegreeType degreeType;
  final MeasureType measureType;

  const _HeaderSection({
    required this.location,
    required this.weather,
    required this.degreeType,
    required this.measureType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            location.name,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        Text(
          location.country,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: Colors.white70),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (weather.condition.icon.isNotEmpty)
              WeatherIcon(url: weather.condition.iconUrl, size: 72),
            const SizedBox(width: 8),
            TweenAnimationBuilder<double>(
              tween: Tween(
                begin: 0,
                end: degreeType == DegreeType.celsius
                    ? weather.tempC
                    : weather.tempF,
              ),
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOut,
              builder: (context, value, _) {
                return Text(
                  degreeType == DegreeType.celsius
                      ? '${value.round()}°C'
                      : '${value.round()}°F',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: AppColors.tempColor,
                        fontWeight: FontWeight.bold,
                      ),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          weather.condition.text,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(color: Colors.white70),
        ),
        const SizedBox(height: 8),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 16,
          runSpacing: 4,
          children: [
            _InfoChip(
              icon: CupertinoIcons.thermometer,
              label:
                  'Feels ${getDegree(degreeType, weather.feelLikeC, weather.feelLikeF)}',
            ),
            _InfoChip(
              icon: CupertinoIcons.wind,
              label:
                  '${weather.windDir} ${getMeasure(measureType, weather.windKph, weather.windMph, true)}',
            ),
            _InfoChip(
              icon: CupertinoIcons.cloud_fill,
              label: '${weather.cloud}% cloud',
            ),
          ],
        ),
        const SizedBox(height: 6),
        if (weather.lastUpdated.isNotEmpty)
          Text(
            'Updated: ${weather.lastUpdated}',
            style: const TextStyle(fontSize: 11, color: Colors.white38),
          ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: Colors.white54),
        const SizedBox(width: 4),
        Text(label,
            style: const TextStyle(fontSize: 12, color: Colors.white60)),
      ],
    );
  }
}

class _StatsGrid extends StatelessWidget with ConversionMixin {
  final WeatherModel weather;
  final MeasureType measureType;

  const _StatsGrid({required this.weather, required this.measureType});

  @override
  Widget build(BuildContext context) {
    return GridView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 2,
      ),
      children: [
        WeatherStatGridTile(
          icon: CupertinoIcons.sun_max,
          label: 'UV Index',
          stat: '${weather.uv.round()}',
          index: 0,
        ),
        WeatherStatGridTile(
          icon: CupertinoIcons.drop,
          label: 'Humidity',
          stat: '${weather.humidity}%',
          index: 1,
        ),
        WeatherStatGridTile(
          icon: CupertinoIcons.eye,
          label: 'Visibility',
          stat: getMeasure(measureType, weather.visKm, weather.visMiles),
          index: 2,
        ),
        WeatherStatGridTile(
          icon: CupertinoIcons.wind,
          label: 'Wind ${weather.windDir}',
          stat: getMeasure(
              measureType, weather.windKph, weather.windMph, true),
          index: 3,
        ),
        WeatherStatGridTile(
          icon: CupertinoIcons.gauge,
          label: 'Pressure',
          stat: '${weather.pressureMb.round()} mb',
          index: 4,
        ),
        WeatherStatGridTile(
          icon: CupertinoIcons.cloud,
          label: 'Cloud Cover',
          stat: '${weather.cloud}%',
          index: 5,
        ),
      ],
    );
  }
}

class _SunriseSunsetSection extends StatelessWidget {
  final AstroModel astro;

  const _SunriseSunsetSection({required this.astro});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.wb_twilight_rounded, size: 14, color: Colors.white60),
              SizedBox(width: 6),
              Text(
                'Sun & Moon',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.white70),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _AstroItem(
                  icon: CupertinoIcons.sunrise,
                  iconColor: const Color(0xFFFFB347),
                  label: 'Sunrise',
                  value: astro.sunrise,
                ),
              ),
              Expanded(
                child: _AstroItem(
                  icon: CupertinoIcons.sunset,
                  iconColor: const Color(0xFFFF7043),
                  label: 'Sunset',
                  value: astro.sunset,
                ),
              ),
              Expanded(
                child: _AstroItem(
                  icon: CupertinoIcons.moon_stars,
                  iconColor: Colors.white70,
                  label: 'Moon Phase',
                  value: astro.moonPhase,
                ),
              ),
              Expanded(
                child: _AstroItem(
                  icon: CupertinoIcons.moon_fill,
                  iconColor: Colors.white54,
                  label: 'Illumination',
                  value: '${astro.moonIllumination}%',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AstroItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const _AstroItem({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: iconColor, size: 22),
        const SizedBox(height: 4),
        Text(
          value,
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.w600),
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 10, color: Colors.white54),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _RemoveButton extends StatelessWidget {
  final VoidCallback onTap;

  const _RemoveButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: Colors.red.withAlpha(40),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.red.withAlpha(100)),
          ),
          child: const Text(
            'Remove this location',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.redAccent,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
