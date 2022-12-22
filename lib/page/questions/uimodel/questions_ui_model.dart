import 'package:equatable/equatable.dart';
import 'package:survey/model/question_model.dart';

class QuestionsUiModel extends Equatable {
  final String surveyId;
  final List<QuestionModel> questions;

  QuestionsUiModel({
    required this.surveyId,
    required this.questions,
  });

  @override
  List<Object?> get props => [surveyId, questions];
}
