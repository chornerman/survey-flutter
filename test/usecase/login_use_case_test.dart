import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:survey/model/login_model.dart';
import 'package:survey/usecase/base/base_use_case.dart';
import 'package:survey/usecase/login_use_case.dart';

import '../../test/mock/mock_dependencies.mocks.dart';

void main() {
  group('LoginUseCaseTest', () {
    late MockAuthRepository mockRepository;
    late MockSharedPreferencesUtils mockSharedPreferences;
    late LoginUseCase useCase;

    setUp(() {
      mockRepository = MockAuthRepository();
      mockSharedPreferences = MockSharedPreferencesUtils();
      useCase = LoginUseCase(mockRepository, mockSharedPreferences);
    });

    test(
        'When executing use case with valid email and password, it returns Success result',
        () async {
      when(mockRepository.login(
        email: anyNamed('email'),
        password: anyNamed('password'),
      )).thenAnswer((_) async => const LoginModel(
            accessToken: "accessToken",
            tokenType: "tokenType",
            refreshToken: "refreshToken",
          ));

      final result =
          await useCase.call(LoginInput(email: 'email', password: 'password'));

      expect(result, isA<Success>());
      verify(mockSharedPreferences.saveAccessToken("accessToken")).called(1);
      verify(mockSharedPreferences.saveTokenType("tokenType")).called(1);
      verify(mockSharedPreferences.saveRefreshToken("refreshToken")).called(1);
    });

    test(
        'When executing use case with incorrect email or password, it returns Failed result',
        () async {
      final exception = Exception();
      when(mockRepository.login(
        email: anyNamed('email'),
        password: anyNamed('password'),
      )).thenAnswer((_) => Future.error(exception));

      final result =
          await useCase.call(LoginInput(email: 'email', password: 'password'));

      expect(result, isA<Failed>());
      expect((result as Failed).exception.actualException, exception);
    });
  });
}
