import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'list_api.dart';

class DioClient {
  late final Dio _dio;

  DioClient() {
    _dio = _createDio();
    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
      ));
    }
  }

  Dio get dio => _dio;

  Dio _createDio() => Dio(
        BaseOptions(
          baseUrl: ListAPI.baseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          sendTimeout: const Duration(seconds: 10),
          validateStatus: (status) => status != null && status >= 200 && status < 300,
        ),
      );
}
