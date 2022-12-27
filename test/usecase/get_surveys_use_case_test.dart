import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:survey/api/exception/network_exceptions.dart';
import 'package:survey/model/survey_model.dart';
import 'package:survey/usecase/base/base_use_case.dart';
import 'package:survey/usecase/get_surveys_use_case.dart';

import '../../test/mock/mock_dependencies.mocks.dart';

void main() {
  group('GetSurveysUseCaseTest', () {
    late MockSurveyRepository mockRepository;
    late GetSurveysUseCase useCase;

    setUp(() {
      mockRepository = MockSurveyRepository();
      useCase = GetSurveysUseCase(mockRepository);
    });

    test(
        'When executing use case and repository returns success, it returns Success result with corresponding data',
        () async {
      final surveys = <SurveyModel>[];
      when(mockRepository.getSurveys(pageNumber: 1, pageSize: 2))
          .thenAnswer((_) async => surveys);

      final result =
          await useCase.call(GetSurveysInput(pageNumber: 1, pageSize: 2));

      expect(result, isA<Success>());
      expect((result as Success).value, surveys);
    });

    test(
        'When executing use case and repository returns error, it returns Failed result',
        () async {
      final exception = NetworkExceptions.badRequest();
      when(mockRepository.getSurveys(pageNumber: 1, pageSize: 2))
          .thenAnswer((_) => Future.error(exception));

      final result =
          await useCase.call(GetSurveysInput(pageNumber: 1, pageSize: 2));

      expect(result, isA<Failed>());
      expect((result as Failed).exception.actualException, exception);
    });
  });
}
