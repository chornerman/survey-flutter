import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:survey/api/exception/network_exceptions.dart';
import 'package:survey/usecase/base/base_use_case.dart';
import 'package:survey/usecase/get_user_use_case.dart';

import '../../test/mock/mock_dependencies.mocks.dart';

void main() {
  group('GetUserUseCaseTest', () {
    late MockUserRepository mockRepository;
    late GetUserUseCase useCase;

    setUp(() {
      mockRepository = MockUserRepository();
      useCase = GetUserUseCase(mockRepository);
    });

    test(
        'When executing use case and repository returns success, it returns Success result with corresponding data',
        () async {
      final userModel = MockUserModel();
      when(mockRepository.getUser()).thenAnswer((_) async => userModel);

      final result = await useCase.call();

      expect(result, isA<Success>());
      expect((result as Success).value, userModel);
    });

    test(
        'When executing use case and repository returns error, it returns Failed result',
        () async {
      final exception = NetworkExceptions.badRequest();
      when(mockRepository.getUser()).thenAnswer((_) => Future.error(exception));

      final result = await useCase.call();

      expect(result, isA<Failed>());
      expect((result as Failed).exception.actualException, exception);
    });
  });
}
