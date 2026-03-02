import 'package:dio/dio.dart';

import 'app_response.dart';
import 'dio_client.dart';

class DioHttpProvider {
  const DioHttpProvider();

  Future<AppResponse> dioGetRequest(String urlPath,
      {Map<String, dynamic>? query, Function(dynamic)? onError}) async {
    return await dio
        .get<AppResponse>(urlPath, queryParameters: query)
        .then((value) => value.data!)
        .onError<DioException>((error, stackTrace) {
      return error.error as AppResponse;
    });
  }

  Future<AppResponse> dioPutRequest(
    String urlPath, {
    body,
    Map<String, dynamic>? params,
  }) async {
    return await dio
        .put<AppResponse>(urlPath, queryParameters: params, data: body)
        .then((value) => value.data!)
        .onError<DioException>((error, stackTrace) {
      return error.error as AppResponse;
    });
  }

  Future<AppResponse> dioPostRequest(
    String urlPath, {
    body,
    Map<String, dynamic>? params,
  }) async {
    return await dio
        .post<AppResponse>(urlPath, queryParameters: params, data: body)
        .then((value) => value.data!)
        .onError<DioException>((error, stackTrace) {
      return error.error as AppResponse;
    });
  }

  Future<AppResponse> dioDeleteRequest(
    String urlPath, {
    body,
  }) async {
    return await dio
        .delete<AppResponse>(urlPath, data: body)
        .then((value) => value.data!)
        .onError<DioException>((error, stackTrace) {
      return error.error as AppResponse;
    });
  }
}
