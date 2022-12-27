import 'package:injectable/injectable.dart';
import 'package:survey/api/service/auth_service.dart';
import 'package:survey/api/service/survey_service.dart';
import 'package:survey/api/service/user_service.dart';
import 'package:survey/di/provider/dio_provider.dart';
import 'package:survey/env_variables.dart';

@module
abstract class ServiceModule {
  @Singleton()
  AuthService provideAuthService(DioProvider dioProvider) {
    return AuthService(
      dioProvider.getNonAuthenticatedDio(),
      baseUrl: EnvVariables.apiEndpoint,
    );
  }

  @Singleton()
  SurveyService provideSurveyService(DioProvider dioProvider) {
    return SurveyService(
      dioProvider.getAuthenticatedDio(),
      baseUrl: EnvVariables.apiEndpoint,
    );
  }

  @Singleton()
  UserService provideUserService(DioProvider dioProvider) {
    return UserService(
      dioProvider.getAuthenticatedDio(),
      baseUrl: EnvVariables.apiEndpoint,
    );
  }
}
