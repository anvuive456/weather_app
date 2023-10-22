import 'package:dio/dio.dart';

sealed class AppResponse {
  const AppResponse();

  factory AppResponse.map(Response response) {
    return switch (response.statusCode) {
      200 || 201 || 202 => SuccessResponse(data: response.data),
      _ when response.statusCode != null => ErrorResponse(
          errorCode: response.statusCode!, detail: response.data.toString()),
      _ => const TimeOutResponse()
    };
  }
}

class ErrorResponse extends AppResponse {
  const ErrorResponse({required this.errorCode, required this.detail});

  final int errorCode;
  final String detail;

  @override
  String toString() => detail;
}

class SuccessResponse extends AppResponse {
  const SuccessResponse({required this.data});

  final dynamic data;

  @override
  String toString() => data.toString();
}

class TimeOutResponse extends AppResponse {
  final String message;

  const TimeOutResponse([this.message = "Cannot connect to service"]);

  @override
  String toString() => message;
}
