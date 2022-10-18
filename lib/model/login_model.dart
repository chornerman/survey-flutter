class LoginModel {
  final String accessToken;
  final String tokenType;
  final String refreshToken;

  LoginModel({
    required this.accessToken,
    required this.tokenType,
    required this.refreshToken,
  });
}
