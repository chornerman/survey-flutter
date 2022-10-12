import 'package:injectable/injectable.dart';
import 'package:survey/api/service/auth_service.dart';
import 'package:survey/di/provider/dio_provider.dart';
import 'package:survey/flavors.dart';

@module
abstract class ServiceModule {
  @Singleton()
  AuthService provideAuthService(DioProvider dioProvider) {
    return AuthService(
      dioProvider.getNonAuthenticatedDio(),
      baseUrl: F.apiEndpoint,
    );
  }
}
