import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:survey/api/exception/network_exceptions.dart';
import 'package:survey/api/repository/auth_repository.dart';
import 'package:survey/database/shared_preferences_utils.dart';
import 'package:survey/model/login_model.dart';
import 'package:survey/usecase/base/base_use_case.dart';

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
        .onError<NetworkExceptions>(
            (exception, stackTrace) => Failed(UseCaseException(exception)));
  }

  Result<void> _saveTokens(LoginModel model) {
    _sharedPreferencesUtils.saveAccessToken(model.accessToken);
    _sharedPreferencesUtils.saveTokenType(model.tokenType);
    _sharedPreferencesUtils.saveRefreshToken(model.refreshToken);
    return Success(null);
  }
}
