import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/common/navigation/routes.dart';
import 'package:weather_app/common/network/custom.interceptor.dart';
import 'package:weather_app/common/network/dio_http.dart';
import 'package:weather_app/resources/string.dart';
import 'package:weather_app/resources/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupInterceptor();
  runApp(const ProviderScope(child: MyApp()));
}


void setupInterceptor(){
  dio.interceptors.add(AppInterceptor());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: appRoutes,
      title: AppString.appName,
      theme: appTheme,
      builder: BotToastInit(),
    );
  }
}
