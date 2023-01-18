import 'package:equatable/equatable.dart';
import 'package:survey/api/response/survey_detail_response.dart';
import 'package:survey/model/question_model.dart';

class SurveyDetailModel extends Equatable {
  final String id;
  final List<QuestionModel> questions;

  SurveyDetailModel({
    required this.id,
    required this.questions,
  });

  @override
  List<Object?> get props => [questions];

  factory SurveyDetailModel.fromResponse(SurveyDetailResponse response) {
    return SurveyDetailModel(
      id: response.id,
      questions: response.questions
          .map((question) => QuestionModel.fromResponse(question))
          .toList(),
    );
  }
}
