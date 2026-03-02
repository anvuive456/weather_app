import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:weather_app/common/mixin/setting_mixin.dart';
import 'package:weather_app/common/navigation/route_paths.dart';
import 'package:weather_app/common/widget/weather_background.dart';
import 'package:weather_app/features/location/data/models/location_model.dart';
import 'package:weather_app/features/location/presentation/providers/location_providers.dart';
import 'package:weather_app/features/weather/presentation/providers/weather_provider.dart';
import 'package:weather_app/features/weather/presentation/screens/weather_page.dart';
import 'package:weather_app/resources/color.dart';

class WeatherScreen extends ConsumerStatefulWidget {
  const WeatherScreen({super.key});

  @override
  ConsumerState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends ConsumerState<WeatherScreen>
    with AppSettingMixin {
  final _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    ref.listenManual(localLocationsProvider, (previous, next) {
      if (next.locations.isEmpty) {
        context.goNamed(RoutePaths.search);
      }
      if (previous != null) {
        _handleAddedLocation(previous.locations, next.locations);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _handleAddedLocation(
    List<LocationModel> prevLocations,
    List<LocationModel> nextLocations,
  ) {
    if (prevLocations.length < nextLocations.length) {
      _pageController.animateToPage(
        nextLocations.length,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(localLocationsProvider);
    final currentLocation = state.locations.isEmpty
        ? null
        : state.locations[_currentPage.clamp(0, state.locations.length - 1)];

    // Watch current weather for the visible page to drive the background.
    final weatherValue = currentLocation == null
        ? null
        : ref.watch(weatherProvider(currentLocation)).value;

    final conditionCode = weatherValue?.condition.code ?? 1000;
    final isDay = weatherValue?.isDay.isOdd ?? true;

    return WeatherBackground(
      conditionCode: conditionCode,
      isDay: isDay,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        bottomNavigationBar: state.locations.isEmpty
            ? null
            : Align(
                alignment: Alignment.bottomCenter,
                heightFactor: .1,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: SmoothPageIndicator(
                    effect: const ExpandingDotsEffect(
                      dotColor: Colors.white38,
                      activeDotColor: AppColors.accent,
                      dotHeight: 8,
                      dotWidth: 8,
                      expansionFactor: 3,
                    ),
                    controller: _pageController,
                    count: state.locations.length,
                  ),
                ),
              ),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _GlassIconButton(
                      icon: Icons.add_location_alt_outlined,
                      onTap: () => context.pushNamed(RoutePaths.search),
                    ),
                    settingIcon,
                  ],
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: state.locations.length,
                  onPageChanged: (index) =>
                      setState(() => _currentPage = index),
                  itemBuilder: (context, index) {
                    return WeatherPage(state.locations[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GlassIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _GlassIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.glass,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}
