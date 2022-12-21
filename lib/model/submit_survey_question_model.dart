import 'package:equatable/equatable.dart';
import 'package:survey/model/answer_model.dart';

class SubmitSurveyQuestionModel extends Equatable {
  final String id;
  final List<SubmitSurveyAnswerModel> answers;

  SubmitSurveyQuestionModel({
    required this.id,
    required this.answers,
  });

  @override
  List<Object?> get props => [id, answers];
}

//ignore: must_be_immutable
class SubmitSurveyAnswerModel extends Equatable {
  final String id;
  String answer;

  SubmitSurveyAnswerModel({
    required this.id,
    required this.answer,
  });

  @override
  List<Object?> get props => [id, answer];

  factory SubmitSurveyAnswerModel.fromAnswerModel(AnswerModel answer) {
    return SubmitSurveyAnswerModel(
      id: answer.id,
      answer: answer.text,
    );
  }
}
