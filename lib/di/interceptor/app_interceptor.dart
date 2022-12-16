import 'dart:io';

import 'package:dio/dio.dart';
import 'package:survey/database/shared_preferences_utils.dart';
import 'package:survey/di/di.dart';
import 'package:survey/model/token_model.dart';
import 'package:survey/usecase/base/base_use_case.dart';
import 'package:survey/usecase/refresh_token_use_case.dart';

const String _authorizationHeader = 'Authorization';

class AppInterceptor extends QueuedInterceptor {
  final bool requireAuthentication;
  final SharedPreferencesUtils sharedPreferencesUtils;
  final Dio dio;

  AppInterceptor({
    required this.requireAuthentication,
    required this.sharedPreferencesUtils,
    required this.dio,
  });

  @override
  Future onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    if (requireAuthentication) {
      options.headers.putIfAbsent(
          _authorizationHeader, () => sharedPreferencesUtils.authToken);
    }
    return super.onRequest(options, handler);
  }

  @override
  void onError(DioError error, ErrorInterceptorHandler handler) {
    final statusCode = error.response?.statusCode;
    if ((statusCode == HttpStatus.forbidden ||
            statusCode == HttpStatus.unauthorized) &&
        requireAuthentication) {
      _refreshToken(error, handler);
    } else {
      handler.next(error);
    }
  }

  void _refreshToken(
    DioError error,
    ErrorInterceptorHandler handler,
  ) async {
    try {
      final refreshTokenUseCase = getIt<RefreshTokenUseCase>();
      final result = await refreshTokenUseCase.call();
      if (result is Success<TokenModel>) {
        // Update new token header
        final newAuthToken = sharedPreferencesUtils.authToken;
        error.requestOptions.headers[_authorizationHeader] = newAuthToken;

        // Create request with new access token
        final options = Options(
          method: error.requestOptions.method,
          headers: error.requestOptions.headers,
        );
        final newRequest = await dio.request(
          "${error.requestOptions.baseUrl}${error.requestOptions.path}",
          options: options,
          data: error.requestOptions.data,
          queryParameters: error.requestOptions.queryParameters,
        );
        handler.resolve(newRequest);
      } else {
        handler.next(error);
      }
    } catch (exception) {
      if (exception is DioError) {
        handler.next(exception);
      } else {
        handler.next(error);
      }
    }
  }
}
