import 'package:equatable/equatable.dart';
import 'package:survey/api/response/token_response.dart';

class TokenModel extends Equatable {
  final String accessToken;
  final String tokenType;
  final String refreshToken;

  const TokenModel({
    required this.accessToken,
    required this.tokenType,
    required this.refreshToken,
  });

  @override
  List<Object> get props => [accessToken, tokenType, refreshToken];

  factory TokenModel.fromResponse(TokenResponse response) {
    return TokenModel(
      accessToken: response.accessToken,
      tokenType: response.tokenType,
      refreshToken: response.refreshToken,
    );
  }
}
