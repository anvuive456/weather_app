import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

import 'app_respsonse.dart';
import 'dio_http.dart';

class DioHttpProvider {
  const DioHttpProvider();

  Future<AppResponse> dioGetRequest(String urlPath,
      {Map<String, dynamic>? query, Function(dynamic)? onError}) async {
    print("dioGetRequest $urlPath");
    print("dioGetRequest ${dio.options.baseUrl}");

    return await dio
        .get<AppResponse>(urlPath, queryParameters: query)
        .then((value) => value.data!)
        .onError<DioException>((error, stackTrace) {
      print(error);
      print(stackTrace);
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

  Future<dynamic> download(String urlPath, String fileName,
      {Map<String, dynamic>? params, Function(int)? progressCallback}) async {
    String dir = '';
    if (Platform.isIOS) {
      dir = (await getTemporaryDirectory()).path;
    } else {
      dir =
          '${(await getExternalStorageDirectory())!.parent.parent.parent.parent.path}/Download';
    }
    print('dioDownload: $dir/$fileName');

    String oldPercent = '0';
    var res =
        await dio.download(urlPath, '$dir/$fileName', queryParameters: params,
            // options: Options(headers: headers),
            onReceiveProgress: (received, total) {
      if (total != -1) {
        if (oldPercent != (received / total * 100).toStringAsFixed(0) &&
            int.parse((received / total * 100).toStringAsFixed(0)) % 10 == 0) {
          oldPercent = (received / total * 100).toStringAsFixed(0);
          progressCallback!(int.parse(oldPercent));
        }
      }
    });
    return res;
  }
}
