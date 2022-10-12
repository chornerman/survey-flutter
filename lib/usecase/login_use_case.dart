import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:survey/api/repository/auth_repository.dart';
import 'package:survey/api/response/login_response.dart';
import 'package:survey/usecase/base/base_use_case.dart';
import 'package:survey/utils/shared_preferences_utils.dart';

class LoginInput {
  final String email;
  final String password;

  LoginInput({
    required this.email,
    required this.password,
  });
}

@Injectable()
class LoginUseCase extends UseCase<void, LoginInput> {
  final AuthRepository _repository;
  final SharedPreferencesUtils _sharedPreferencesUtils;

  const LoginUseCase(
    this._repository,
    this._sharedPreferencesUtils,
  );

  @override
  Future<Result<void>> call(LoginInput input) {
    return _repository
        .login(email: input.email, password: input.password)
        .then((value) => _saveTokens(value))
        .onError<Exception>(
            (exception, stackTrace) => Failed(UseCaseException(exception)));
  }

  Result<void> _saveTokens(LoginResponse loginResponse) {
    _sharedPreferencesUtils.saveAccessToken(loginResponse.accessToken);
    _sharedPreferencesUtils.saveTokenType(loginResponse.tokenType);
    _sharedPreferencesUtils.saveRefreshToken(loginResponse.refreshToken);
    return Success(null);
  }
}
