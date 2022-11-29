import 'package:email_validator/email_validator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:survey/page/login/login_state.dart';
import 'package:survey/usecase/base/base_use_case.dart';
import 'package:survey/usecase/login_use_case.dart';

class LoginViewModel extends StateNotifier<LoginState> {
  final LoginUseCase _loginUseCase;

  LoginViewModel(this._loginUseCase) : super(const LoginState.init());

  void login(String email, String password) async {
    state = const LoginState.loading();
    if (_validateInputs(email, password)) {
      Result<void> result = await _loginUseCase.call(
        LoginInput(
          email: email,
          password: password,
        ),
      );
      if (result is Success) {
        state = const LoginState.success();
      } else {
        state = LoginState.apiError();
      }
    } else {
      state = const LoginState.invalidInputsError();
    }
  }

  bool _validateInputs(String email, String password) {
    final isEmailValid = EmailValidator.validate(email);
    final isPasswordValid = password.isNotEmpty;
    return isEmailValid && isPasswordValid;
  }
}
