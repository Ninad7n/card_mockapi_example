import 'dart:async';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiClient {
  ApiClient._internal() {
    _dio = Dio(_baseOptions)
      ..interceptors.addAll([
        _authInterceptor,
        LogInterceptor(requestBody: true, responseBody: true),
      ]);
  }
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;

  late final Dio _dio;
  final _baseOptions = BaseOptions(
    baseUrl: 'https://${dotenv.env['API_KEY']}.mockapi.io/api/',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 15),
    sendTimeout: const Duration(seconds: 10),
    responseType: ResponseType.plain,
    headers: {'Accept': 'application/json'},
  );
  Interceptor get _authInterceptor => InterceptorsWrapper(
    onRequest: (options, handler) async {
      handler.next(options);
    },
    onResponse: (response, handler) {
      log(
        "${response.realUri}\nSTATUS CODE:${response.statusCode}\n${response.data}",
        name: "_interceptor onResponse",
      );
      handler.resolve(response);
    },
    onError: (error, handler) async {
      if (error.response?.statusCode == 401) {
        final requestOptions = error.requestOptions;
        try {
          final opts = Options(
            method: requestOptions.method,
            headers: requestOptions.headers,
            responseType: requestOptions.responseType,
          );
          final cloneResp = await _dio.request(
            requestOptions.path,
            options: opts,
            data: requestOptions.data,
            queryParameters: requestOptions.queryParameters,
          );
          return handler.resolve(cloneResp);
        } catch (e) {
          log("");
        }
      }
      handler.next(error);
    },
  );

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Dio get dio => _dio;
}
