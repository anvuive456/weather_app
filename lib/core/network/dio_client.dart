import 'package:dio/dio.dart';

import 'api_path.dart';

Dio dio = Dio(
  BaseOptions(
    baseUrl: ApiPath.baseUrl,
    headers: {
      'Accept': 'application/json',
      'Content-type': 'application/json',
    },
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 10),
  ),
);
