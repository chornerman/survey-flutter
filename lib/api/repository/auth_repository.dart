import 'package:injectable/injectable.dart';
import 'package:survey/api/exception/network_exceptions.dart';
import 'package:survey/api/grant_type.dart';
import 'package:survey/api/request/login_request.dart';
import 'package:survey/api/request/reset_password_request.dart';
import 'package:survey/api/service/auth_service.dart';
import 'package:survey/env_variables.dart';
import 'package:survey/model/login_model.dart';

abstract class AuthRepository {
  Future<LoginModel> login({
    required String email,
    required String password,
  });

  Future<void> resetPassword({
    required String email,
  });
}

@Singleton(as: AuthRepository)
class AuthRepositoryImpl extends AuthRepository {
  final AuthService _authService;

  AuthRepositoryImpl(this._authService);

  @override
  Future<LoginModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _authService.login(
        LoginRequest(
          grantType: GrantType.password.value,
          email: email,
          password: password,
          clientId: EnvVariables.clientId,
          clientSecret: EnvVariables.clientSecret,
        ),
      );
      return LoginModel.fromResponse(response);
    } catch (exception) {
      throw NetworkExceptions.fromDioException(exception);
    }
  }

  @override
  Future<void> resetPassword({required String email}) async {
    try {
      await _authService.resetPassword(
        ResetPasswordRequest(
          user: ResetPasswordUserRequest(email: email),
          clientId: EnvVariables.clientId,
          clientSecret: EnvVariables.clientSecret,
        ),
      );
    } catch (exception) {
      throw NetworkExceptions.fromDioException(exception);
    }
  }
}
