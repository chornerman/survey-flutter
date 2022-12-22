import 'package:freezed_annotation/freezed_annotation.dart';

part 'questions_state.freezed.dart';

@freezed
class QuestionsState with _$QuestionsState {
  const factory QuestionsState.init() = _Init;

  const factory QuestionsState.loading() = _Loading;

  const factory QuestionsState.initSuccess() = _InitSuccess;

  const factory QuestionsState.submitSurveySuccess(String? outroMessage) =
      _SubmitSurveySuccess;

  const factory QuestionsState.error(String errorMessage) = _Error;
}
