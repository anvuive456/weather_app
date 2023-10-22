import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/common/app_constants.dart';
import 'package:weather_app/common/navigation/route_paths.dart';
import 'package:weather_app/modules/search_location/screen/search_location_screen.dart';
import 'package:weather_app/modules/weather/screen/weather_screen.dart';

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
    pageBuilder: (context, state) =>
        const CupertinoPage(child: SearchLocationScreen()),
  ),
  GoRoute(
    path: '/main',
    name: RoutePaths.main,
    pageBuilder: (context, state) =>
        const CupertinoPage(child: WeatherScreen()),
  ),
]);
