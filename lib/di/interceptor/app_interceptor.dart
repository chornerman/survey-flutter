import 'package:dio/dio.dart';

class AppInterceptor extends Interceptor {
  final bool requireAuthentication;

  AppInterceptor({required this.requireAuthentication});

  @override
  Future onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    if (requireAuthentication) {
      // TODO: Add header
    }
    return super.onRequest(options, handler);
  }
}
