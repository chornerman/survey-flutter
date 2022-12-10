import 'package:injectable/injectable.dart';
import 'package:survey/api/exception/network_exceptions.dart';
import 'package:survey/api/repository/auth_repository.dart';
import 'package:survey/usecase/base/base_use_case.dart';

@Injectable()
class ResetPasswordUseCase extends UseCase<void, String> {
  final AuthRepository _repository;

  const ResetPasswordUseCase(this._repository);

  @override
  Future<Result<void>> call(String email) {
    return _repository
        .resetPassword(email: email)
        // ignore: unnecessary_cast
        .then((value) => Success(null) as Result<void>)
        .onError<NetworkExceptions>(
            (exception, stackTrace) => Failed(UseCaseException(exception)));
  }
}
