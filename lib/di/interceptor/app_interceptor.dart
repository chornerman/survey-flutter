import 'package:dio/dio.dart';
import 'package:survey/database/shared_preferences_utils.dart';

const String _authorizationHeader = 'Authorization';

class AppInterceptor extends Interceptor {
  final bool requireAuthentication;
  final SharedPreferencesUtils sharedPreferencesUtils;

  AppInterceptor({
    required this.requireAuthentication,
    required this.sharedPreferencesUtils,
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
}
