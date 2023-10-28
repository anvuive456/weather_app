import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:weather_app/common/mixin/setting_mixin.dart';
import 'package:weather_app/common/navigation/route_paths.dart';
import 'package:weather_app/common/widget/app_button.dart';
import 'package:weather_app/modules/weather/provider/local_location_provider.dart';
import 'package:weather_app/modules/weather/screen/weather_page.dart';
import 'package:weather_app/resources/color.dart';

class WeatherScreen extends ConsumerStatefulWidget {
  const WeatherScreen({super.key});

  @override
  ConsumerState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends ConsumerState<WeatherScreen>
    with AppSettingMixin {
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(localLocationsProvider);
    return Scaffold(
      bottomNavigationBar: state.locations.isEmpty
          ? null
          : Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SmoothPageIndicator(
                      effect: ScrollingDotsEffect(),
                      controller: _pageController,
                      count: state.locations.length)
                ],
              ),
            ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppButton(
                    child: Icon(
                      Icons.add_circle_outline,
                      color: AppColors.white,
                    ),
                    onTap: () {
                      context.goNamed(RoutePaths.search);
                    },
                  ),
                  settingIcon
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: state.locations.length,
                itemBuilder: (context, index) {
                  final item = state.locations[index];

                  return WeatherPage(item);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
