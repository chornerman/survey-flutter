import 'package:injectable/injectable.dart';
import 'package:survey/api/exception/network_exceptions.dart';
import 'package:survey/api/repository/survey_repository.dart';
import 'package:survey/api/request/submit_survey_request.dart';
import 'package:survey/usecase/base/base_use_case.dart';

class SubmitSurveyInput {
  String surveyId;
  List<SubmitSurveyQuestionRequest> questions;

  SubmitSurveyInput({
    required this.surveyId,
    required this.questions,
  });
}

@Injectable()
class SubmitSurveyUseCase extends UseCase<void, SubmitSurveyInput> {
  final SurveyRepository _repository;

  const SubmitSurveyUseCase(this._repository);

  @override
  Future<Result<void>> call(SubmitSurveyInput input) {
    return _repository
        .submitSurvey(surveyId: input.surveyId, questions: input.questions)
        // ignore: unnecessary_cast
        .then((value) => Success(null) as Result<void>)
        .onError<NetworkExceptions>(
            (exception, stackTrace) => Failed(UseCaseException(exception)));
  }
}
