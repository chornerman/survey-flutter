import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:survey/api/exception/network_exceptions.dart';
import 'package:survey/api/repository/auth_repository.dart';
import 'package:survey/database/hive_utils.dart';
import 'package:survey/database/shared_preferences_utils.dart';
import 'package:survey/usecase/base/base_use_case.dart';

@Injectable()
class LogoutUseCase extends NoInputUseCase<void> {
  final AuthRepository _repository;
  final SharedPreferencesUtils _sharedPreferencesUtils;
  final HiveUtils _hiveUtils;

  const LogoutUseCase(
    this._repository,
    this._sharedPreferencesUtils,
    this._hiveUtils,
  );

  @override
  Future<Result<void>> call() async {
    final token = await _sharedPreferencesUtils.accessToken;
    return _repository
        .logout(token: token)
        .then((value) => _clearTokensAndCache())
        .onError<NetworkExceptions>(
            (exception, stackTrace) => Failed(UseCaseException(exception)));
  }

  Result<void> _clearTokensAndCache() {
    _sharedPreferencesUtils.clear();
    _hiveUtils.clearSurveys();
    return Success(null);
  }
}
