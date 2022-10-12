import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:survey/api/request/login_request.dart';
import 'package:survey/api/response/login_response.dart';

part 'auth_service.g.dart';

@RestApi()
abstract class AuthService {
  factory AuthService(Dio dio, {String baseUrl}) = _AuthService;

  @POST('/api/v1/oauth/token')
  Future<LoginResponse> login(
    @Body() LoginRequest body,
  );
}
