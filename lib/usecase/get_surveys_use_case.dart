import 'package:injectable/injectable.dart';
import 'package:survey/api/repository/survey_repository.dart';
import 'package:survey/model/survey_model.dart';
import 'package:survey/usecase/base/base_use_case.dart';

class GetSurveysInput {
  final int pageNumber;
  final int pageSize;

  GetSurveysInput({
    required this.pageNumber,
    required this.pageSize,
  });
}

@Injectable()
class GetSurveysUseCase extends UseCase<List<SurveyModel>, GetSurveysInput> {
  final SurveyRepository _repository;

  const GetSurveysUseCase(this._repository);

  @override
  Future<Result<List<SurveyModel>>> call(GetSurveysInput input) {
    return _repository
        .getSurveys(
          pageNumber: input.pageNumber,
          pageSize: input.pageSize,
        )
        // ignore: unnecessary_cast
        .then((value) => Success(value) as Result<List<SurveyModel>>)
        .onError<Exception>(
            (exception, stackTrace) => Failed(UseCaseException(exception)));
  }
}
