import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:survey/api/response/surveys_response.dart';

part 'survey_service.g.dart';

@RestApi()
abstract class SurveyService {
  factory SurveyService(Dio dio, {String baseUrl}) = _SurveyService;

  @GET('/api/v1/surveys?page[number]={pageNumber}&page[size]={pageSize}')
  Future<SurveysResponse> getSurveys(
    @Path('pageNumber') int pageNumber,
    @Path('pageSize') int pageSize,
  );
}
