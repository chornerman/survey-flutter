import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:survey/api/exception/network_exceptions.dart';
import 'package:survey/page/resetpassword/reset_password_page.dart';
import 'package:survey/page/resetpassword/reset_password_state.dart';
import 'package:survey/page/resetpassword/reset_password_view_model.dart';
import 'package:survey/usecase/base/base_use_case.dart';

import '../../mock/mock_dependencies.mocks.dart';

void main() {
  group('ResetPasswordViewModelTest', () {
    late MockResetPasswordUseCase mockResetPasswordUseCase;
    late ProviderContainer providerContainer;
    late ResetPasswordViewModel resetPasswordViewModel;

    setUp(() {
      mockResetPasswordUseCase = MockResetPasswordUseCase();

      providerContainer = ProviderContainer(
        overrides: [
          resetPasswordViewModelProvider.overrideWithValue(
              ResetPasswordViewModel(mockResetPasswordUseCase)),
        ],
      );
      addTearDown(providerContainer.dispose);
      resetPasswordViewModel =
          providerContainer.read(resetPasswordViewModelProvider.notifier);
    });

    test('When initializing, it initializes with Init state', () {
      expect(
        providerContainer.read(resetPasswordViewModelProvider),
        const ResetPasswordState.init(),
      );
    });

    test(
        'When calling reset password with Success result, it returns Success state',
        () {
      when(mockResetPasswordUseCase.call(any))
          .thenAnswer((_) async => Success(null));
      final stateStream = resetPasswordViewModel.stream;

      expect(
          stateStream,
          emitsInOrder([
            const ResetPasswordState.loading(),
            const ResetPasswordState.success(),
          ]));

      resetPasswordViewModel.resetPassword('chorny@berlento.com');
    });

    test(
        'When calling reset password with invalid email, it returns InvalidInputError state',
        () {
      final stateStream = resetPasswordViewModel.stream;

      expect(
          stateStream,
          emitsInOrder([
            const ResetPasswordState.loading(),
            const ResetPasswordState.invalidInputError(),
          ]));

      resetPasswordViewModel.resetPassword('Chorny');
    });

    test(
        'When calling reset password with Failed result, it returns ApiError state with corresponding errorMessage',
        () {
      final mockException = MockUseCaseException();
      when(mockException.actualException)
          .thenReturn(NetworkExceptions.badRequest());
      when(mockResetPasswordUseCase.call(any))
          .thenAnswer((_) async => Failed(mockException));
      final stateStream = resetPasswordViewModel.stream;

      expect(
          stateStream,
          emitsInOrder([
            const ResetPasswordState.loading(),
            ResetPasswordState.apiError(
              NetworkExceptions.getErrorMessage(NetworkExceptions.badRequest()),
            ),
          ]));

      resetPasswordViewModel.resetPassword('chorny@berlento.com');
    });
  });
}
