import 'package:injectable/injectable.dart';
import 'package:survey/database/hive_utils.dart';
import 'package:survey/model/survey_model.dart';
import 'package:survey/usecase/base/base_use_case.dart';

@Injectable()
class GetCachedSurveysUseCase extends SimpleUseCase<List<SurveyModel>> {
  final HiveUtils _hiveUtils;

  GetCachedSurveysUseCase(this._hiveUtils);

  @override
  List<SurveyModel> call() => _hiveUtils.surveys;
}
