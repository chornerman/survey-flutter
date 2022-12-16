import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:survey/api/exception/network_exceptions.dart';
import 'package:survey/model/token_model.dart';
import 'package:survey/usecase/base/base_use_case.dart';
import 'package:survey/usecase/refresh_token_use_case.dart';

import '../../test/mock/mock_dependencies.mocks.dart';

void main() {
  group('RefreshTokenUseCaseTest', () {
    late MockAuthRepository mockRepository;
    late MockSharedPreferencesUtils mockSharedPreferences;
    late RefreshTokenUseCase useCase;

    setUp(() {
      mockRepository = MockAuthRepository();
      mockSharedPreferences = MockSharedPreferencesUtils();
      useCase = RefreshTokenUseCase(mockRepository, mockSharedPreferences);
    });

    test(
        'When executing use case and repository returns success, it returns Success result with corresponding data',
        () async {
      final tokenModel = const TokenModel(
        accessToken: 'accessToken',
        tokenType: 'tokenType',
        refreshToken: 'refreshToken',
      );
      when(mockRepository.refreshToken(refreshToken: anyNamed('refreshToken')))
          .thenAnswer((_) async => tokenModel);

      final result = await useCase.call();

      expect(result, isA<Success>());
      expect((result as Success).value, tokenModel);
      verify(mockSharedPreferences.saveAccessToken(tokenModel.accessToken))
          .called(1);
      verify(mockSharedPreferences.saveTokenType(tokenModel.tokenType))
          .called(1);
      verify(mockSharedPreferences.saveRefreshToken(tokenModel.refreshToken))
          .called(1);
    });

    test(
        'When executing use case and repository returns error, it returns Failed result',
        () async {
      final exception = NetworkExceptions.badRequest();
      when(mockRepository.refreshToken(refreshToken: anyNamed('refreshToken')))
          .thenAnswer((_) => Future.error(exception));

      final result = await useCase.call();

      expect(result, isA<Failed>());
      expect((result as Failed).exception.actualException, exception);
    });
  });
}
