import 'package:injectable/injectable.dart';
import 'package:survey/api/grant_type.dart';
import 'package:survey/api/request/login_request.dart';
import 'package:survey/api/response/login_response.dart';
import 'package:survey/api/service/auth_service.dart';
import 'package:survey/flavors.dart';

abstract class AuthRepository {
  Future<LoginResponse> login(
      {required String email, required String password});
}

@Singleton(as: AuthRepository)
class AuthRepositoryImpl extends AuthRepository {
  final AuthService _authService;

  AuthRepositoryImpl(this._authService);

  @override
  Future<LoginResponse> login(
      {required String email, required String password}) {
    return _authService.login(
      LoginRequest(
        grantType: GrantType.password.value,
        email: email,
        password: password,
        clientId: F.clientId,
        clientSecret: F.clientSecret,
      ),
    );
  }
}
