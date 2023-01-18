import 'package:equatable/equatable.dart';
import 'package:survey/api/response/question_response.dart';
import 'package:survey/constants.dart';
import 'package:survey/model/answer_model.dart';

class QuestionModel extends Equatable {
  final String id;
  final String text;
  final int displayOrder;
  final DisplayType displayType;
  final String coverImageUrl;
  final double coverImageOpacity;
  final List<AnswerModel> answers;

  QuestionModel({
    required this.id,
    required this.text,
    required this.displayOrder,
    required this.displayType,
    required this.coverImageOpacity,
    required this.coverImageUrl,
    required this.answers,
  });

  @override
  List<Object?> get props => [
        id,
        text,
        displayOrder,
        displayType,
        coverImageOpacity,
        coverImageUrl,
        answers,
      ];

  factory QuestionModel.fromResponse(QuestionResponse response) {
    return QuestionModel(
      id: response.id,
      text: response.text ?? '',
      displayOrder: response.displayOrder ?? 0,
      displayType: response.displayType ?? DisplayType.unknown,
      coverImageOpacity: response.coverImageOpacity ??
          Constants.defaultDimmedBackgroundOpacity,
      coverImageUrl: response.getHdCoverImageUrl(),
      answers: response.answers
          .map((answer) => AnswerModel.fromResponse(answer))
          .toList(),
    );
  }
}
