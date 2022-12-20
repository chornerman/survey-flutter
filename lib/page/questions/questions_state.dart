import 'package:freezed_annotation/freezed_annotation.dart';

part 'questions_state.freezed.dart';

@freezed
class QuestionsState with _$QuestionsState {
  const factory QuestionsState.init() = _Init;

  const factory QuestionsState.success() = _Success;
}
