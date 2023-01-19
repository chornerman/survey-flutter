import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:survey/api/response/user_response.dart';

part 'user_service.g.dart';

abstract class UserService {
  Future<UserResponse> getUser();
}

@RestApi()
abstract class UserServiceImpl extends UserService {
  factory UserServiceImpl(Dio dio, {String baseUrl}) = _UserServiceImpl;

  @GET('/api/v1/me')
  Future<UserResponse> getUser();
}
