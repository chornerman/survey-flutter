import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:survey/api/exception/network_exceptions.dart';
import 'package:survey/usecase/base/base_use_case.dart';
import 'package:survey/usecase/submit_survey_use_case.dart';

import '../../test/mock/mock_dependencies.mocks.dart';

void main() {
  group('SubmitSurveyUseCaseTest', () {
    late MockSurveyRepository mockRepository;
    late SubmitSurveyUseCase useCase;

    final submitSurveyInput = SubmitSurveyInput(
      surveyId: 'surveyId',
      questions: [],
    );

    setUp(() {
      mockRepository = MockSurveyRepository();
      useCase = SubmitSurveyUseCase(mockRepository);
    });

    test(
        'When executing use case and repository returns success, it returns Success result',
        () async {
      when(mockRepository.submitSurvey(
        surveyId: submitSurveyInput.surveyId,
        questions: submitSurveyInput.questions,
      )).thenAnswer((_) async => null);

      final result = await useCase.call(submitSurveyInput);

      expect(result, isA<Success>());
    });

    test(
        'When executing use case and repository returns error, it returns Failed result',
        () async {
      final exception = NetworkExceptions.badRequest();
      when(mockRepository.submitSurvey(
        surveyId: submitSurveyInput.surveyId,
        questions: submitSurveyInput.questions,
      )).thenAnswer((_) => Future.error(exception));

      final result = await useCase.call(submitSurveyInput);

      expect(result, isA<Failed>());
      expect((result as Failed).exception.actualException, exception);
    });
  });
}
