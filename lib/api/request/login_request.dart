import 'package:json_annotation/json_annotation.dart';

part 'login_request.g.dart';

@JsonSerializable()
class LoginRequest {
  String grantType;
  String email;
  String password;
  String clientId;
  String clientSecret;

  LoginRequest({
    required this.grantType,
    required this.email,
    required this.password,
    required this.clientId,
    required this.clientSecret,
  });

  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}
