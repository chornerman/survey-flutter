import 'package:dio/dio.dart';
import 'package:mockito/annotations.dart';
import 'package:survey/api/repository/auth_repository.dart';
import 'package:survey/api/service/auth_service.dart';
import 'package:survey/usecase/login_use_case.dart';
import 'package:survey/utils/shared_preferences_utils.dart';

@GenerateNiceMocks([
  MockSpec<AuthRepository>(),
  MockSpec<SharedPreferencesUtils>(),
  MockSpec<AuthService>(),
  MockSpec<LoginUseCase>(),
  MockSpec<DioError>(),
])
void main() {}
