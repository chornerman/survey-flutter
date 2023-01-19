import 'package:flutter_test/flutter_test.dart';
import 'package:survey/api/request/submit_survey_request.dart';
import 'package:survey/api/response/survey_detail_response.dart';
import 'package:survey/api/response/surveys_response.dart';
import 'package:survey/api/service/survey_service.dart';

import 'fake_data.dart';

const getSurveysKey = 'getSurveys';
const getSurveyDetailKey = 'getSurveyDetail';
const submitSurveyKey = 'submitSurvey';

class FakeSurveyService extends Fake implements SurveyService {
  @override
  Future<SurveysResponse> getSurveys(int pageNumber, int pageSize) async {
    final response = FakeData.fakeResponses[getSurveysKey]!;

    if (response.statusCode != successStatusCode) {
      throw fakeDioError(response.statusCode);
    }
    return SurveysResponse.fromJson(response.json);
  }

  @override
  Future<SurveyDetailResponse> getSurveyDetail(String surveyId) async {
    final response = FakeData.fakeResponses[getSurveyDetailKey]!;

    if (response.statusCode != successStatusCode) {
      throw fakeDioError(response.statusCode);
    }
    return SurveyDetailResponse.fromJson(response.json);
  }

  @override
  Future<void> submitSurvey(SubmitSurveyRequest body) async {
    final response = FakeData.fakeResponses[submitSurveyKey]!;

    if (response.statusCode != successStatusCode) {
      throw fakeDioError(response.statusCode);
    }
  }
}
