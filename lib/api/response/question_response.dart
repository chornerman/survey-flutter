import 'package:json_annotation/json_annotation.dart';
import 'package:survey/api/response/answer_response.dart';
import 'package:survey/api/response/converter/response_converter.dart';

part 'question_response.g.dart';

enum DisplayType {
  star,
  heart,
  smiley,
  choice,
  nps,
  textarea,
  textfield,
  dropdown,
  money,
  slider,
  intro,
  outro,
  unknown,
}

@JsonSerializable()
class QuestionResponse {
  final String id;
  final String? text;
  final int? displayOrder;
  final DisplayType? displayType;
  final String? imageUrl;
  final String? coverImageUrl;
  final double? coverImageOpacity;
  final List<AnswerResponse> answers;

  QuestionResponse({
    required this.id,
    required this.text,
    required this.displayOrder,
    required this.displayType,
    required this.imageUrl,
    required this.coverImageUrl,
    required this.coverImageOpacity,
    required this.answers,
  });

  factory QuestionResponse.fromJson(Map<String, dynamic> json) =>
      _$QuestionResponseFromJson(fromDataJsonApi(json));

  String getHdCoverImageUrl() {
    if (coverImageUrl != null) {
      return "${coverImageUrl}l";
    } else {
      return "";
    }
  }
}
