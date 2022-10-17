import 'package:json_annotation/json_annotation.dart';
import 'package:survey/api/response/converter/response_converter.dart';

part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse {
  String accessToken;
  String tokenType;
  DateTime expiresIn;
  String refreshToken;
  DateTime createdAt;

  LoginResponse({
    required this.accessToken,
    required this.tokenType,
    required this.expiresIn,
    required this.refreshToken,
    required this.createdAt,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(fromJsonApi(json));

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}
