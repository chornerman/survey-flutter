import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:survey/page/login/login_page.dart';
import 'package:survey/page/login/login_state.dart';
import 'package:survey/page/login/login_view_model.dart';
import 'package:survey/usecase/base/base_use_case.dart';

import '../../mock/mock_dependencies.mocks.dart';

void main() {
  group('LoginViewModelTest', () {
    late MockLoginUseCase mockLoginUseCase;
    late ProviderContainer providerContainer;

    setUp(() {
      mockLoginUseCase = MockLoginUseCase();
      providerContainer = ProviderContainer(
        overrides: [
          loginViewModelProvider
              .overrideWithValue(LoginViewModel(mockLoginUseCase)),
        ],
      );
      addTearDown(providerContainer.dispose);
    });

    test('When initializing, it initializes with Init state', () {
      expect(
        providerContainer.read(loginViewModelProvider),
        const LoginState.init(),
      );
    });

    test('When calling login with Success result, it returns Success state',
        () {
      when(mockLoginUseCase.call(any)).thenAnswer((_) async => Success(null));
      final stateStream =
          providerContainer.read(loginViewModelProvider.notifier).stream;

      expect(
          stateStream,
          emitsInOrder([
            const LoginState.loading(),
            const LoginState.success(),
          ]));
      providerContainer
          .read(loginViewModelProvider.notifier)
          .login('chorny@berlento.com', '12345678');
    });

    test(
        'When calling login with invalid email or password, it returns InvalidInputsError state',
        () {
      final stateStream =
          providerContainer.read(loginViewModelProvider.notifier).stream;

      expect(
          stateStream,
          emitsInOrder([
            const LoginState.loading(),
            const LoginState.invalidInputsError(),
          ]));
      providerContainer
          .read(loginViewModelProvider.notifier)
          .login('Chorny', '');
    });

    test('When calling login with Failed result, it returns ApiError state',
        () {
      final exception = UseCaseException(Exception());
      when(mockLoginUseCase.call(any))
          .thenAnswer((_) async => Failed(exception));
      final stateStream =
          providerContainer.read(loginViewModelProvider.notifier).stream;

      expect(
          stateStream,
          emitsInOrder([
            const LoginState.loading(),
            LoginState.apiError(exception),
          ]));
      providerContainer
          .read(loginViewModelProvider.notifier)
          .login('chorny@berlento.com', '12345678');
    });
  });
}
