import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:survey/api/exception/network_exceptions.dart';
import 'package:survey/api/repository/survey_repository.dart';
import 'package:survey/api/response/survey_detail_response.dart';
import 'package:survey/api/response/surveys_response.dart';
import 'package:survey/model/survey_detail_model.dart';
import 'package:survey/model/survey_model.dart';

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
        'When calling getSurveys on the first page successfully, it returns corresponding mapped result and clear surveys cache',
        () async {
      final surveysJson =
          await FileUtils.loadFile('test/mock/mock_response/surveys.json');
      final response = SurveysResponse.fromJson(surveysJson);
      when(mockSurveyService.getSurveys(any, any))
          .thenAnswer((_) async => response);

      final result = await repository.getSurveys(pageNumber: 1, pageSize: 2);

      expect(result.length, 2);
      expect(result[0], SurveyModel.fromResponse(response.surveys[0]));
      expect(result[1], SurveyModel.fromResponse(response.surveys[1]));
      verify(mockHiveUtils.clearSurveys()).called(1);
      verify(mockHiveUtils.saveSurveys(result)).called(1);
    });

    test(
        'When calling getSurveys not on the first page successfully, it returns corresponding mapped result',
        () async {
      final surveysJson =
          await FileUtils.loadFile('test/mock/mock_response/surveys.json');
      final response = SurveysResponse.fromJson(surveysJson);
      when(mockSurveyService.getSurveys(any, any))
          .thenAnswer((_) async => response);

      final result = await repository.getSurveys(pageNumber: 2, pageSize: 2);

      expect(result.length, 2);
      expect(result[0], SurveyModel.fromResponse(response.surveys[0]));
      expect(result[1], SurveyModel.fromResponse(response.surveys[1]));
      verify(mockHiveUtils.saveSurveys(result)).called(1);
    });

    test('When calling getSurveys failed, it returns NetworkExceptions error',
        () async {
      when(mockSurveyService.getSurveys(any, any)).thenThrow(MockDioError());

      result() => repository.getSurveys(pageNumber: 1, pageSize: 2);

      expect(result, throwsA(isA<NetworkExceptions>()));
    });

    test(
        'When calling getSurveyDetail successfully, it returns corresponding mapped result',
        () async {
      final surveyDetailJson = await FileUtils.loadFile(
          'test/mock/mock_response/survey_detail.json');
      final response = SurveyDetailResponse.fromJson(surveyDetailJson);
      when(mockSurveyService.getSurveyDetail(any))
          .thenAnswer((_) async => response);

      final result = await repository.getSurveyDetail(surveyId: 'surveyId');

      expect(result, SurveyDetailModel.fromResponse(response));
    });

    test(
        'When calling getSurveyDetail failed, it returns NetworkExceptions error',
        () async {
      when(mockSurveyService.getSurveyDetail(any)).thenThrow(MockDioError());

      result() => repository.getSurveyDetail(surveyId: 'surveyId');

      expect(result, throwsA(isA<NetworkExceptions>()));
    });

    test('When calling submit survey successfully, it returns empty result',
        () async {
      when(mockSurveyService.submitSurvey(any)).thenAnswer((_) async => null);

      await repository.submitSurvey(surveyId: 'surveyId', questions: []);
    });

    test(
        'When calling submit survey failed, it returns NetworkExceptions error',
        () async {
      when(mockSurveyService.submitSurvey(any)).thenThrow(MockDioError());

      result() => repository.submitSurvey(surveyId: 'surveyId', questions: []);

      expect(result, throwsA(isA<NetworkExceptions>()));
    });
  });
}
