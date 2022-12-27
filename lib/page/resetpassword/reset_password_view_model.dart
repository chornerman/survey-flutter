import 'package:email_validator/email_validator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:survey/page/resetpassword/reset_password_state.dart';
import 'package:survey/usecase/base/base_use_case.dart';
import 'package:survey/usecase/reset_password_use_case.dart';

class ResetPasswordViewModel extends StateNotifier<ResetPasswordState> {
  final ResetPasswordUseCase _resetPasswordUseCase;

  ResetPasswordViewModel(this._resetPasswordUseCase)
      : super(const ResetPasswordState.init());

  void resetPassword(String email) async {
    state = const ResetPasswordState.loading();
    if (EmailValidator.validate(email)) {
      Result<void> result = await _resetPasswordUseCase.call(email);
      if (result is Success) {
        state = const ResetPasswordState.success();
      } else {
        state =
            ResetPasswordState.apiError((result as Failed).getErrorMessage());
      }
    } else {
      state = const ResetPasswordState.invalidInputError();
    }
  }
}
