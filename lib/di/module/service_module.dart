import 'package:injectable/injectable.dart';
import 'package:survey/api/service/auth_service.dart';
import 'package:survey/api/service/survey_service.dart';
import 'package:survey/api/service/user_service.dart';
import 'package:survey/di/provider/dio_provider.dart';
import 'package:survey/env_variables.dart';

@module
abstract class ServiceModule {
  @Singleton(as: AuthService)
  AuthServiceImpl provideAuthService(DioProvider dioProvider) {
    return AuthServiceImpl(
      dioProvider.getNonAuthenticatedDio(),
      baseUrl: EnvVariables.apiEndpoint,
    );
  }

  @Singleton(as: SurveyService)
  SurveyServiceImpl provideSurveyService(DioProvider dioProvider) {
    return SurveyServiceImpl(
      dioProvider.getAuthenticatedDio(),
      baseUrl: EnvVariables.apiEndpoint,
    );
  }

  @Singleton(as: UserService)
  UserServiceImpl provideUserService(DioProvider dioProvider) {
    return UserServiceImpl(
      dioProvider.getAuthenticatedDio(),
      baseUrl: EnvVariables.apiEndpoint,
    );
  }
}
