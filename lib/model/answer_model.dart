import 'package:equatable/equatable.dart';
import 'package:survey/api/response/answer_response.dart';

class AnswerModel extends Equatable {
  final String id;
  final String text;
  final int displayOrder;
  final String displayType;

  AnswerModel({
    required this.id,
    required this.text,
    required this.displayOrder,
    required this.displayType,
  });

  @override
  List<Object?> get props => [id, text, displayOrder, displayType];

  factory AnswerModel.fromResponse(AnswerResponse response) {
    return AnswerModel(
      id: response.id,
      text: response.text ?? '',
      displayOrder: response.displayOrder,
      displayType: response.displayType,
    );
  }
}
