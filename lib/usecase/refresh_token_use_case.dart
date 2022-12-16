import 'package:injectable/injectable.dart';
import 'package:survey/api/exception/network_exceptions.dart';
import 'package:survey/api/repository/auth_repository.dart';
import 'package:survey/database/shared_preferences_utils.dart';
import 'package:survey/model/token_model.dart';
import 'package:survey/usecase/base/base_use_case.dart';

@Injectable()
class RefreshTokenUseCase extends NoInputUseCase<TokenModel> {
  final AuthRepository _repository;
  final SharedPreferencesUtils _sharedPreferencesUtils;

  const RefreshTokenUseCase(
    this._repository,
    this._sharedPreferencesUtils,
  );

  @override
  Future<Result<TokenModel>> call() async {
    final refreshToken = await _sharedPreferencesUtils.refreshToken;
    return _repository
        .refreshToken(refreshToken: refreshToken)
        .then((value) => _saveTokens(value))
        .onError<NetworkExceptions>(
            (exception, stackTrace) => Failed(UseCaseException(exception)));
  }

  Result<TokenModel> _saveTokens(TokenModel model) {
    _sharedPreferencesUtils.saveAccessToken(model.accessToken);
    _sharedPreferencesUtils.saveTokenType(model.tokenType);
    _sharedPreferencesUtils.saveRefreshToken(model.refreshToken);
    return Success(model);
  }
}
