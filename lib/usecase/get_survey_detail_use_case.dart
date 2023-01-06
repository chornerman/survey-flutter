import 'package:injectable/injectable.dart';
import 'package:survey/api/exception/network_exceptions.dart';
import 'package:survey/api/repository/survey_repository.dart';
import 'package:survey/model/survey_detail_model.dart';
import 'package:survey/usecase/base/base_use_case.dart';

@Injectable()
class GetSurveyDetailUseCase extends UseCase<SurveyDetailModel, String> {
  final SurveyRepository _repository;

  const GetSurveyDetailUseCase(this._repository);

  @override
  Future<Result<SurveyDetailModel>> call(String surveyId) {
    return _repository
        .getSurveyDetail(surveyId: surveyId)
        // ignore: unnecessary_cast
        .then((value) => Success(value) as Result<SurveyDetailModel>)
        .onError<NetworkExceptions>(
            (exception, stackTrace) => Failed(UseCaseException(exception)));
  }
}
