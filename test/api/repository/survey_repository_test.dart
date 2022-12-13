import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:survey/api/repository/survey_repository.dart';
import 'package:survey/api/response/surveys_response.dart';

import '../../mock/mock_dependencies.mocks.dart';
import '../../utils/file_utils.dart';

void main() {
  group("SurveyRepositoryTest", () {
    late MockSurveyService mockSurveyService;
    late MockHiveUtils mockHiveUtils;
    late SurveyRepository repository;

    setUp(() async {
      mockSurveyService = MockSurveyService();
      mockHiveUtils = MockHiveUtils();
      repository = SurveyRepositoryImpl(
        mockSurveyService,
        mockHiveUtils,
      );
    });

    test(
        'When calling getSurveys successfully, it returns corresponding mapped result',
        () async {
      final surveysJson =
          await FileUtils.loadFile('test/mock/mock_response/surveys.json');
      final response = SurveysResponse.fromJson(surveysJson);

      when(mockSurveyService.getSurveys(any, any))
          .thenAnswer((_) async => response);
      final result = await repository.getSurveys(pageNumber: 1, pageSize: 2);

      expect(result.length, 2);
      expect(result[0].title, "Scarlett Bangkok");
      expect(result[1].title, "ibis Bangkok Riverside");

      verify(mockHiveUtils.saveSurveys(result)).called(1);
    });

    test('When calling getSurveys failed, it returns error', () async {
      when(mockSurveyService.getSurveys(any, any)).thenThrow(MockDioError());

      result() => repository.getSurveys(pageNumber: 1, pageSize: 2);

      expect(result, throwsA(isA<Exception>()));
    });
  });
}
