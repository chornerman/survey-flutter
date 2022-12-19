import 'package:json_annotation/json_annotation.dart';
import 'package:survey/api/response/converter/response_converter.dart';

part 'answer_response.g.dart';

@JsonSerializable()
class AnswerResponse {
  final String id;
  final String? text;
  final int displayOrder;
  final String displayType;

  AnswerResponse({
    required this.id,
    required this.text,
    required this.displayOrder,
    required this.displayType,
  });

  factory AnswerResponse.fromJson(Map<String, dynamic> json) =>
      _$AnswerResponseFromJson(fromDataJsonApi(json));
}
