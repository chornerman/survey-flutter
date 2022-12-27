import 'package:injectable/injectable.dart';
import 'package:survey/api/exception/network_exceptions.dart';
import 'package:survey/api/repository/user_repository.dart';
import 'package:survey/model/user_model.dart';
import 'package:survey/usecase/base/base_use_case.dart';

@Injectable()
class GetUserUseCase extends NoInputUseCase<UserModel> {
  final UserRepository _repository;

  const GetUserUseCase(this._repository);

  @override
  Future<Result<UserModel>> call() {
    return _repository
        .getUser()
        // ignore: unnecessary_cast
        .then((value) => Success(value) as Result<UserModel>)
        .onError<NetworkExceptions>(
            (exception, stackTrace) => Failed(UseCaseException(exception)));
  }
}
