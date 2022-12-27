import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:survey/api/exception/network_exceptions.dart';
import 'package:survey/usecase/base/base_use_case.dart';
import 'package:survey/usecase/logout_use_case.dart';

import '../../test/mock/mock_dependencies.mocks.dart';

void main() {
  group('LogoutUseCaseTest', () {
    late MockAuthRepository mockRepository;
    late MockSharedPreferencesUtils mockSharedPreferencesUtils;
    late MockHiveUtils mockHiveUtils;
    late LogoutUseCase useCase;

    setUp(() {
      mockRepository = MockAuthRepository();
      mockSharedPreferencesUtils = MockSharedPreferencesUtils();
      mockHiveUtils = MockHiveUtils();
      useCase = LogoutUseCase(
        mockRepository,
        mockSharedPreferencesUtils,
        mockHiveUtils,
      );
    });

    test(
        'When executing use case and repository returns success, it returns Success result',
        () async {
      when(mockRepository.logout(token: anyNamed('token')))
          .thenAnswer((_) async => null);

      final result = await useCase.call();

      expect(result, isA<Success>());
      verify(mockSharedPreferencesUtils.clear()).called(1);
      verify(mockHiveUtils.clearSurveys()).called(1);
    });

    test(
        'When executing use case and repository returns error, it returns Failed result',
        () async {
      final exception = NetworkExceptions.badRequest();
      when(mockRepository.logout(token: anyNamed('token')))
          .thenAnswer((_) => Future.error(exception));

      final result = await useCase.call();

      expect(result, isA<Failed>());
      expect((result as Failed).exception.actualException, exception);
    });
  });
}
