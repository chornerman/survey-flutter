import 'package:injectable/injectable.dart';
import 'package:survey/api/service/user_service.dart';
import 'package:survey/di/provider/dio_provider.dart';
import 'package:survey/flavors.dart';

@module
abstract class ServiceModule {
  @Singleton()
  UserService provideUserService(DioProvider dioProvider) {
    return UserService(
      dioProvider.getNonAuthenticatedDio(),
      baseUrl: F.apiEndpoint,
    );
  }
}
