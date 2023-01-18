import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:survey/model/survey_detail_model.dart';

part 'survey_detail_state.freezed.dart';

@freezed
class SurveyDetailState with _$SurveyDetailState {
  const factory SurveyDetailState.init() = _Init;

  const factory SurveyDetailState.loading() = _Loading;

  const factory SurveyDetailState.success() = _Success;

  const factory SurveyDetailState.retrySuccess(SurveyDetailModel surveyDetail) =
      _RetrySuccess;

  const factory SurveyDetailState.error(String errorMessage) = _Error;
}
