import 'package:equatable/equatable.dart';

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
}
