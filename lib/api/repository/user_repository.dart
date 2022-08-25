import 'package:injectable/injectable.dart';
import 'package:survey/api/request/login_request.dart';
import 'package:survey/api/response/login_response.dart';
import 'package:survey/api/service/user_service.dart';
import 'package:survey/flavors.dart';

const String _grantTypePassword = 'password';

abstract class UserRepository {
  Future<LoginResponse> login(
      {required String email, required String password});
}

@Singleton(as: UserRepository)
class UserRepositoryImpl extends UserRepository {
  final UserService _userService;

  UserRepositoryImpl(this._userService);

  @override
  Future<LoginResponse> login(
      {required String email, required String password}) {
    return _userService.login(
      LoginRequest(
        grantType: _grantTypePassword,
        email: email,
        password: password,
        clientId: F.clientId,
        clientSecret: F.clientSecret,
      ),
    );
  }
}
