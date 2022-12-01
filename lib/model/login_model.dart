import 'package:equatable/equatable.dart';
import 'package:survey/api/response/login_response.dart';

class LoginModel extends Equatable {
  final String accessToken;
  final String tokenType;
  final String refreshToken;

  const LoginModel({
    required this.accessToken,
    required this.tokenType,
    required this.refreshToken,
  });

  @override
  List<Object> get props => [accessToken, tokenType, refreshToken];

  factory LoginModel.fromResponse(LoginResponse response) {
    return LoginModel(
      accessToken: response.accessToken,
      tokenType: response.tokenType,
      refreshToken: response.refreshToken,
    );
  }
}
