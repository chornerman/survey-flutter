import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:survey/api/repository/auth_repository.dart';
import 'package:survey/api/response/login_response.dart';
import 'package:survey/model/login_model.dart';

import '../../mock/mock_dependencies.mocks.dart';

void main() {
  FlutterConfig.loadValueForTesting({
    'CLIENT_ID': 'CLIENT_ID',
    'CLIENT_SECRET': 'CLIENT_SECRET',
  });

  group("AuthRepositoryTest", () {
    late MockAuthService mockAuthService;
    late AuthRepository repository;

    setUp(() async {
      mockAuthService = MockAuthService();
      repository = AuthRepositoryImpl(mockAuthService);
    });

    test(
        'When calling login successfully, it returns corresponding mapped result',
        () async {
      final response = LoginResponse(
        accessToken: 'accessToken',
        tokenType: 'tokenType',
        expiresIn: 0,
        refreshToken: 'refreshToken',
        createdAt: 0,
      );
      const expected = LoginModel(
        accessToken: 'accessToken',
        tokenType: 'tokenType',
        refreshToken: 'refreshToken',
      );
      when(mockAuthService.login(any)).thenAnswer((_) async => response);

      final result = await repository.login(
        email: "email",
        password: "password",
      );

      expect(result, expected);
    });

    test('When calling login failed, it returns error', () async {
      when(mockAuthService.login(any)).thenThrow(MockDioError());

      result() => repository.login(email: "email", password: "password");

      expect(result, throwsA(isA<Exception>()));
    });
  });
}
