import 'package:json_annotation/json_annotation.dart';
import 'package:survey/api/response/converter/response_converter.dart';

part 'token_response.g.dart';

@JsonSerializable()
class TokenResponse {
  final String accessToken;
  final String tokenType;
  final int expiresIn;
  final String refreshToken;
  final int createdAt;

  TokenResponse({
    required this.accessToken,
    required this.tokenType,
    required this.expiresIn,
    required this.refreshToken,
    required this.createdAt,
  });

  factory TokenResponse.fromJson(Map<String, dynamic> json) =>
      _$TokenResponseFromJson(fromDataJsonApi(json));
}
