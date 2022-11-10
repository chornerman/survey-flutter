import 'package:json_annotation/json_annotation.dart';

part 'login_request.g.dart';

@JsonSerializable()
class LoginRequest {
  final String grantType;
  final String email;
  final String password;
  final String clientId;
  final String clientSecret;

  LoginRequest({
    required this.grantType,
    required this.email,
    required this.password,
    required this.clientId,
    required this.clientSecret,
  });

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);

  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}
