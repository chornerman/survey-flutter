import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:survey/di/interceptor/app_interceptor.dart';
import 'package:survey/env_variables.dart';

const String _headerContentType = 'Content-Type';
const String _defaultContentType = 'application/json; charset=utf-8';
const int _connectionTimeout = 30000;

@Singleton()
class DioProvider {
  Dio? _nonAuthenticatedDio;

  Dio getNonAuthenticatedDio() {
    _nonAuthenticatedDio ??= _createDio();
    return _nonAuthenticatedDio!;
  }

  Dio _createDio({bool requireAuthentication = false}) {
    final dio = Dio();
    final appInterceptor =
        AppInterceptor(requireAuthentication: requireAuthentication);
    final interceptors = <Interceptor>[];
    interceptors.add(appInterceptor);
    if (!kReleaseMode) {
      interceptors.add(LogInterceptor(
        request: true,
        responseBody: true,
        requestBody: true,
        requestHeader: true,
      ));
    }

    return dio
      ..options.connectTimeout = _connectionTimeout
      ..options.receiveTimeout = _connectionTimeout
      ..options.headers = {_headerContentType: _defaultContentType}
      ..options.baseUrl = EnvVariables.apiEndpoint
      ..interceptors.addAll(interceptors);
  }
}
