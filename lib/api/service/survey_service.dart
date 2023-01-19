import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:survey/api/request/submit_survey_request.dart';
import 'package:survey/api/response/survey_detail_response.dart';
import 'package:survey/api/response/surveys_response.dart';

part 'survey_service.g.dart';

abstract class SurveyService {
  Future<SurveysResponse> getSurveys(
    @Path('pageNumber') int pageNumber,
    @Path('pageSize') int pageSize,
  );

  Future<SurveyDetailResponse> getSurveyDetail(
    @Path('surveyId') String surveyId,
  );

  Future<void> submitSurvey(@Body() SubmitSurveyRequest body);
}

@RestApi()
abstract class SurveyServiceImpl extends SurveyService {
  factory SurveyServiceImpl(Dio dio, {String baseUrl}) = _SurveyServiceImpl;

  @GET('/api/v1/surveys?page[number]={pageNumber}&page[size]={pageSize}')
  Future<SurveysResponse> getSurveys(
    @Path('pageNumber') int pageNumber,
    @Path('pageSize') int pageSize,
  );

  @GET('/api/v1/surveys/{surveyId}')
  Future<SurveyDetailResponse> getSurveyDetail(
    @Path('surveyId') String surveyId,
  );

  @POST('/api/v1/responses')
  Future<void> submitSurvey(@Body() SubmitSurveyRequest body);
}
