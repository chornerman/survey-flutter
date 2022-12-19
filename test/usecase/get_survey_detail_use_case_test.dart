import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:survey/api/exception/network_exceptions.dart';
import 'package:survey/usecase/base/base_use_case.dart';
import 'package:survey/usecase/get_survey_detail_use_case.dart';

import '../../test/mock/mock_dependencies.mocks.dart';

void main() {
  group('GetSurveyDetailUseCaseTest', () {
    late MockSurveyRepository mockRepository;
    late GetSurveyDetailUseCase useCase;

    final String surveyId = 'surveyId';

    setUp(() {
      mockRepository = MockSurveyRepository();
      useCase = GetSurveyDetailUseCase(mockRepository);
    });

    test(
        'When executing use case and repository returns success, it returns Success result with corresponding data',
        () async {
      final surveyDetail = MockSurveyDetailModel();
      when(mockRepository.getSurveyDetail(surveyId: surveyId))
          .thenAnswer((_) async => surveyDetail);

      final result = await useCase.call(surveyId);

      expect(result, isA<Success>());
      expect((result as Success).value, surveyDetail);
    });

    test(
        'When executing use case and repository returns error, it returns Failed result',
        () async {
      final exception = NetworkExceptions.badRequest();
      when(mockRepository.getSurveyDetail(surveyId: surveyId))
          .thenAnswer((_) => Future.error(exception));

      final result = await useCase.call(surveyId);

      expect(result, isA<Failed>());
      expect((result as Failed).exception.actualException, exception);
    });
  });
}
