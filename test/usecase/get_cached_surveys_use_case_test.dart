import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:survey/model/survey_model.dart';
import 'package:survey/usecase/get_cached_surveys_use_case.dart';

import '../mock/mock_dependencies.mocks.dart';

void main() {
  group('GetCachedSurveysUseCaseTest', () {
    late MockHiveUtils mockHiveUtils;
    late GetCachedSurveysUseCase useCase;

    setUp(() async {
      mockHiveUtils = MockHiveUtils();
      useCase = GetCachedSurveysUseCase(mockHiveUtils);
    });

    test(
        'When fetching cached surveys, it returns cached surveys correspondingly',
        () async {
      final surveys = <SurveyModel>[];
      when(mockHiveUtils.surveys).thenAnswer((_) => surveys);

      final result = await useCase.call();

      expect(result, surveys);
    });
  });
}
