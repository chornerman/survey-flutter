import 'package:json_annotation/json_annotation.dart';

part 'reset_password_request.g.dart';

@JsonSerializable()
class ResetPasswordRequest {
  final ResetPasswordUserRequest user;
  final String clientId;
  final String clientSecret;

  ResetPasswordRequest({
    required this.user,
    required this.clientId,
    required this.clientSecret,
  });

  factory ResetPasswordRequest.fromJson(Map<String, dynamic> json) =>
      _$ResetPasswordRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ResetPasswordRequestToJson(this);
}

@JsonSerializable()
class ResetPasswordUserRequest {
  final String email;

  ResetPasswordUserRequest({
    required this.email,
  });

  factory ResetPasswordUserRequest.fromJson(Map<String, dynamic> json) =>
      _$ResetPasswordUserRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ResetPasswordUserRequestToJson(this);
}
