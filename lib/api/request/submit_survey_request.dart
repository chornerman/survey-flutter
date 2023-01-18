import 'package:json_annotation/json_annotation.dart';
import 'package:survey/model/submit_survey_question_model.dart';

part 'submit_survey_request.g.dart';

@JsonSerializable()
class SubmitSurveyRequest {
  final String surveyId;
  final List<SubmitSurveyQuestionRequest> questions;

  SubmitSurveyRequest({
    required this.surveyId,
    required this.questions,
  });

  factory SubmitSurveyRequest.fromJson(Map<String, dynamic> json) =>
      _$SubmitSurveyRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SubmitSurveyRequestToJson(this);
}

@JsonSerializable()
class SubmitSurveyQuestionRequest {
  final String id;
  final List<SubmitSurveyAnswerRequest> answers;

  SubmitSurveyQuestionRequest({
    required this.id,
    required this.answers,
  });

  factory SubmitSurveyQuestionRequest.fromModel(
      SubmitSurveyQuestionModel model) {
    return SubmitSurveyQuestionRequest(
      id: model.id,
      answers: model.answers
          .map((answer) => SubmitSurveyAnswerRequest.fromModel(answer))
          .toList(),
    );
  }

  factory SubmitSurveyQuestionRequest.fromJson(Map<String, dynamic> json) =>
      _$SubmitSurveyQuestionRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SubmitSurveyQuestionRequestToJson(this);
}

@JsonSerializable()
class SubmitSurveyAnswerRequest {
  final String id;
  final String answer;

  SubmitSurveyAnswerRequest({
    required this.id,
    required this.answer,
  });

  factory SubmitSurveyAnswerRequest.fromModel(SubmitSurveyAnswerModel model) {
    return SubmitSurveyAnswerRequest(
      id: model.id,
      answer: model.answer,
    );
  }

  factory SubmitSurveyAnswerRequest.fromJson(Map<String, dynamic> json) =>
      _$SubmitSurveyAnswerRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SubmitSurveyAnswerRequestToJson(this);
}
