import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:survey/api/exception/network_exceptions.dart';
import 'package:survey/usecase/base/base_use_case.dart';
import 'package:survey/usecase/reset_password_use_case.dart';

import '../../test/mock/mock_dependencies.mocks.dart';

void main() {
  group('ResetPasswordUseCaseTest', () {
    late MockAuthRepository mockRepository;
    late ResetPasswordUseCase useCase;

    final email = 'chorny@berlento.com';

    setUp(() {
      mockRepository = MockAuthRepository();
      useCase = ResetPasswordUseCase(mockRepository);
    });

    test(
        'When executing use case and repository returns success, it returns Success result',
        () async {
      when(mockRepository.resetPassword(email: email))
          .thenAnswer((_) async => null);

      final result = await useCase.call(email);

      expect(result, isA<Success>());
    });

    test(
        'When executing use case and repository returns error, it returns Failed result',
        () async {
      final exception = NetworkExceptions.badRequest();
      when(mockRepository.resetPassword(email: email))
          .thenAnswer((_) => Future.error(exception));

      final result = await useCase.call(email);

      expect(result, isA<Failed>());
      expect((result as Failed).exception.actualException, exception);
    });
  });
}
