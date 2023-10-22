import 'package:dio/dio.dart';
import 'package:weather_app/common/app_constants.dart';

import 'app_respsonse.dart';

class AppInterceptor implements InterceptorsWrapper {
  AppInterceptor();

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    DioException nextErr = err;

    switch (err.type) {
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.connectionError:
      case DioExceptionType.unknown:
        nextErr = err.copyWith(
            requestOptions: err.requestOptions, error: const TimeOutResponse());
        break;
      default:
        nextErr = err.copyWith(
            error: ErrorResponse(
          errorCode: err.response?.statusCode ?? 0,
          detail:
              'ERROR: ${err.response?.statusCode} ${err.response?.data.toString()}',
        ));
    }
    return handler.next(nextErr);
  }

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    var newOptions = options.copyWith(queryParameters: {
      'key': kWeatherApiKey,
      ...options.queryParameters,
    });
    print(newOptions.queryParameters);
    return handler.next(newOptions);
  }

  @override
  void onResponse(
      Response<dynamic> response, ResponseInterceptorHandler handler) {
    // AppLog.print(response.data);
    final data = AppResponse.map(response);

    return handler.next(
      Response<AppResponse>(
        requestOptions: response.requestOptions,
        data: data,
      ),
    );
  }
}
