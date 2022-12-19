import 'package:equatable/equatable.dart';
import 'package:survey/api/response/question_response.dart';
import 'package:survey/model/answer_model.dart';

class QuestionModel extends Equatable {
  final String id;
  final String text;
  final int displayOrder;
  final DisplayType displayType;
  final String imageUrl;
  final String coverImageUrl;
  final double coverImageOpacity;
  final List<AnswerModel> answers;

  QuestionModel({
    required this.id,
    required this.text,
    required this.displayOrder,
    required this.displayType,
    required this.imageUrl,
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
        imageUrl,
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
      imageUrl: response.imageUrl ?? '',
      coverImageOpacity: response.coverImageOpacity ?? 0,
      coverImageUrl: response.getHdCoverImageUrl(),
      answers: response.answers
          .map((answer) => AnswerModel.fromResponse(answer))
          .toList(),
    );
  }
}
