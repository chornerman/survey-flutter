import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:survey/api/request/login_request.dart';
import 'package:survey/api/request/logout_request.dart';
import 'package:survey/api/request/refresh_token_request.dart';
import 'package:survey/api/request/reset_password_request.dart';
import 'package:survey/api/response/token_response.dart';

part 'auth_service.g.dart';

@RestApi()
abstract class AuthService {
  factory AuthService(Dio dio, {String baseUrl}) = _AuthService;

  @POST('/api/v1/oauth/token')
  Future<TokenResponse> login(
    @Body() LoginRequest body,
  );

  @POST('/api/v1/oauth/revoke')
  Future<void> logout(
    @Body() LogoutRequest body,
  );

  @POST('/api/v1/oauth/token')
  Future<TokenResponse> refreshToken(
    @Body() RefreshTokenRequest body,
  );

  @POST('/api/v1/passwords')
  Future<void> resetPassword(
    @Body() ResetPasswordRequest body,
  );
}
