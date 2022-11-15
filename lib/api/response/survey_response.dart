import 'package:json_annotation/json_annotation.dart';
import 'package:survey/api/response/converter/response_converter.dart';
import 'package:survey/model/survey_model.dart';

part 'survey_response.g.dart';

@JsonSerializable()
class SurveyResponse {
  final String id;
  String? title;
  String? description;
  bool? isActive;
  String? coverImageUrl;
  String? createdAt;
  String? surveyType;

  SurveyResponse({
    required this.id,
    this.title,
    this.description,
    this.isActive,
    this.coverImageUrl,
    this.createdAt,
    this.surveyType,
  });

  factory SurveyResponse.fromJson(Map<String, dynamic> json) =>
      _$SurveyResponseFromJson(fromDataJsonApi(json));

  SurveyModel toSurveyModel() => SurveyModel(
        id: id,
        title: title ?? "",
        description: description ?? "",
        coverImageUrl: getHdCoverImageUrl(),
      );

  String getHdCoverImageUrl() {
    if (coverImageUrl != null) {
      return "${coverImageUrl}l";
    } else {
      return "";
    }
  }
}
