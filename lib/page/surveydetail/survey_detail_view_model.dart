import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/subjects.dart';
import 'package:survey/model/survey_detail_model.dart';
import 'package:survey/model/survey_model.dart';
import 'package:survey/page/surveydetail/survey_detail_state.dart';
import 'package:survey/usecase/base/base_use_case.dart';
import 'package:survey/usecase/get_survey_detail_use_case.dart';

class SurveyDetailViewModel extends StateNotifier<SurveyDetailState> {
  final GetSurveyDetailUseCase _getSurveyDetailUseCase;

  SurveyDetailViewModel(this._getSurveyDetailUseCase)
      : super(const SurveyDetailState.init());

  final BehaviorSubject<SurveyModel> _survey = BehaviorSubject();

  Stream<SurveyModel> get survey => _survey.stream;

  final BehaviorSubject<SurveyDetailModel> _surveyDetail = BehaviorSubject();

  Stream<SurveyDetailModel> get surveyDetail => _surveyDetail.stream;

  void getSurveyDetail(SurveyModel survey, {isRetry = false}) async {
    if (!isRetry) _survey.add(survey);
    state = const SurveyDetailState.loading();
    Result<SurveyDetailModel> result =
        await _getSurveyDetailUseCase.call(survey.id);
    if (result is Success<SurveyDetailModel>) {
      final surveyDetail = result.value;
      if (!isRetry) {
        _surveyDetail.add(surveyDetail);
        state = SurveyDetailState.success();
      } else {
        state = SurveyDetailState.retrySuccess(surveyDetail);
      }
    } else {
      state = SurveyDetailState.error((result as Failed).getErrorMessage());
    }
  }

  @override
  void dispose() async {
    await _survey.close();
    await _surveyDetail.close();
    super.dispose();
  }
}
