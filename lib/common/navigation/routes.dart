import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/core/constants/app_constants.dart';
import 'package:weather_app/common/navigation/route_paths.dart';
import 'package:weather_app/features/location/presentation/screens/search_location_screen.dart';
import 'package:weather_app/features/weather/presentation/screens/weather_screen.dart';

final appRoutes = GoRouter(
    observers: [BotToastNavigatorObserver()],
    redirect: (context, state) async {
      //If local locations is empty then navigate to search screen
      // else move to main screen

      final prefs = await SharedPreferences.getInstance();
      final locations = prefs.getStringList(PrefsConstants.locationsKey);
      if(locations == null || locations.isEmpty){
        return '/search';
      }

      return null;
    },
    initialLocation: '/main', routes: [
  GoRoute(
    path: '/search',
    name: RoutePaths.search,
    pageBuilder: (context, state) => CustomTransitionPage(
      child: const SearchLocationScreen(),
      transitionDuration: const Duration(milliseconds: 380),
      reverseTransitionDuration: const Duration(milliseconds: 280),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final fade = CurvedAnimation(
          parent: animation,
          curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
        );
        final slide = Tween<Offset>(
          begin: const Offset(0, 0.06),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        ));
        return FadeTransition(
          opacity: fade,
          child: SlideTransition(position: slide, child: child),
        );
      },
    ),
  ),
  GoRoute(
    path: '/main',
    name: RoutePaths.main,
    pageBuilder: (context, state) => CustomTransitionPage(
      child: const WeatherScreen(),
      transitionDuration: const Duration(milliseconds: 350),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    ),
  ),
]);
