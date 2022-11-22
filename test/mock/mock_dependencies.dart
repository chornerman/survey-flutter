import 'package:dio/dio.dart';
import 'package:mockito/annotations.dart';
import 'package:survey/api/repository/auth_repository.dart';
import 'package:survey/api/repository/survey_repository.dart';
import 'package:survey/api/service/auth_service.dart';
import 'package:survey/api/service/survey_service.dart';
import 'package:survey/database/hive_utils.dart';
import 'package:survey/database/shared_preferences_utils.dart';
import 'package:survey/usecase/get_cached_surveys_use_case.dart';
import 'package:survey/usecase/get_surveys_use_case.dart';
import 'package:survey/usecase/login_use_case.dart';

@GenerateNiceMocks([
  MockSpec<AuthRepository>(),
  MockSpec<SurveyRepository>(),
  MockSpec<SharedPreferencesUtils>(),
  MockSpec<HiveUtils>(),
  MockSpec<AuthService>(),
  MockSpec<SurveyService>(),
  MockSpec<LoginUseCase>(),
  MockSpec<GetSurveysUseCase>(),
  MockSpec<GetCachedSurveysUseCase>(),
  MockSpec<DioError>(),
])
void main() {}
