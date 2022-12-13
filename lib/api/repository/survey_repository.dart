import 'package:injectable/injectable.dart';
import 'package:survey/api/service/survey_service.dart';
import 'package:survey/database/hive_utils.dart';
import 'package:survey/model/survey_model.dart';

const _firstSurveysPageNumber = 1;

abstract class SurveyRepository {
  Future<List<SurveyModel>> getSurveys({
    required int pageNumber,
    required int pageSize,
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
    final response = await _surveyService.getSurveys(pageNumber, pageSize);
    final surveyModels =
        response.surveys.map((item) => SurveyModel.fromResponse(item)).toList();

    _saveSurveysCache(pageNumber, surveyModels);

    return surveyModels;
  }

  void _saveSurveysCache(int pageNumber, List<SurveyModel> surveyModels) {
    if (pageNumber == _firstSurveysPageNumber) _hiveUtils.clearSurveys();
    _hiveUtils.saveSurveys(surveyModels);
  }
}