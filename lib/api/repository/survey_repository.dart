import 'package:injectable/injectable.dart';
import 'package:survey/api/exception/network_exceptions.dart';
import 'package:survey/api/service/survey_service.dart';
import 'package:survey/constants.dart';
import 'package:survey/database/hive_utils.dart';
import 'package:survey/model/survey_detail_model.dart';
import 'package:survey/model/survey_model.dart';

abstract class SurveyRepository {
  Future<List<SurveyModel>> getSurveys({
    required int pageNumber,
    required int pageSize,
  });

  Future<SurveyDetailModel> getSurveyDetail({
    required String surveyId,
  });
}

@Singleton(as: SurveyRepository)
class SurveyRepositoryImpl extends SurveyRepository {
  final SurveyService _surveyService;
  final HiveUtils _hiveUtils;

  SurveyRepositoryImpl(this._surveyService, this._hiveUtils);

  @override
  Future<List<SurveyModel>> getSurveys({
    required int pageNumber,
    required int pageSize,
  }) async {
    try {
      final response = await _surveyService.getSurveys(pageNumber, pageSize);
      final surveyModels = response.surveys
          .map((item) => SurveyModel.fromResponse(item))
          .toList();

      final shouldClearCache = pageNumber == Constants.firstSurveysPageNumber;
      _saveSurveysCache(shouldClearCache, surveyModels);

      return surveyModels;
    } catch (exception) {
      throw NetworkExceptions.fromDioException(exception);
    }
  }

  @override
  Future<SurveyDetailModel> getSurveyDetail({
    required String surveyId,
  }) async {
    try {
      final response = await _surveyService.getSurveyDetail(surveyId);
      return SurveyDetailModel.fromResponse(response);
    } catch (exception) {
      throw NetworkExceptions.fromDioException(exception);
    }
  }

  void _saveSurveysCache(
    bool shouldClearCache,
    List<SurveyModel> surveyModels,
  ) {
    if (shouldClearCache) _hiveUtils.clearSurveys();
    _hiveUtils.saveSurveys(surveyModels);
  }
}
