import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:survey/model/survey_model.dart';

const String _surveysKey = 'surveys';

abstract class HiveUtils {
  List<SurveyModel> get surveys;

  void saveSurveys(List<SurveyModel> surveyModels);

  void clear();
}

@Singleton(as: HiveUtils)
class HiveUtilsImpl extends HiveUtils {
  final Box _surveyBox;

  HiveUtilsImpl(this._surveyBox);

  @override
  List<SurveyModel> get surveys =>
      List<SurveyModel>.from(_surveyBox.get(_surveysKey, defaultValue: []));

  @override
  void saveSurveys(List<SurveyModel> surveyModels) async {
    final currentSurveys = surveys;
    currentSurveys.addAll(surveyModels);
    await _surveyBox.put(_surveysKey, currentSurveys);
  }

  @override
  void clear() async {
    await _surveyBox.delete(_surveysKey);
  }
}
