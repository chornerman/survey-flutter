import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:survey/constants.dart';
import 'package:survey/di/di.dart';
import 'package:survey/gen/assets.gen.dart';
import 'package:survey/navigator.dart';
import 'package:survey/page/login/login_state.dart';
import 'package:survey/page/login/login_view_model.dart';
import 'package:survey/page/login/widget/login_text_input_forgot_password_widget.dart';
import 'package:survey/resource/dimens.dart';
import 'package:survey/usecase/login_use_case.dart';
import 'package:survey/widget/circular_progress_bar_widget.dart';
import 'package:survey/widget/onboarding_background_widget.dart';
import 'package:survey/widget/rounded_button_widget.dart';
import 'package:survey/widget/text_input_widget.dart';

final loginViewModelProvider =
    StateNotifierProvider.autoDispose<LoginViewModel, LoginState>((ref) {
  return LoginViewModel(getIt.get<LoginUseCase>());
});

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _appNavigator = getIt.get<AppNavigator>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ref.listen<LoginState>(loginViewModelProvider, (
      LoginState? previousLoginState,
      LoginState newLoginState,
    ) {
      newLoginState.maybeWhen(
        success: () => _navigateToHome(),
        apiError: (errorMessage) => _showError(errorMessage),
        invalidInputsError: () =>
            _showError(AppLocalizations.of(context)!.loginInvalidEmailPassword),
        orElse: () {},
      );
    });

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          OnboardingBackgroundWidget(
            background: AssetImage(Assets.images.bgOnboarding.path),
            shouldBlur: true,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: Dimens.space24),
            decoration: BoxDecoration(color: Colors.black.withOpacity(0.4)),
            child: SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: Dimens.space120),
                  Assets.images.icNimble.svg(),
                  const SizedBox(height: Dimens.space110),
                  TextInputWidget(
                    hintText: AppLocalizations.of(context)!.email,
                    controller: _emailController,
                  ),
                  const SizedBox(height: Dimens.space20),
                  TextInputWidget(
                    hintText: AppLocalizations.of(context)!.loginPassword,
                    isPasswordInput: true,
                    controller: _passwordController,
                    endWidget: LoginTextInputForgotPasswordWidget(
                      onPressed: () {
                        _navigateToResetPassword();
                      },
                    ),
                  ),
                  const SizedBox(height: Dimens.space20),
                  RoundedButtonWidget(
                    buttonText: AppLocalizations.of(context)!.login,
                    onPressed: () {
                      _hideKeyboard();
                      ref.read(loginViewModelProvider.notifier).login(
                            _emailController.text,
                            _passwordController.text,
                          );
                    },
                  ),
                ],
              ),
            ),
          ),
          ref.watch(loginViewModelProvider).maybeWhen(
                loading: () => const CircularProgressBarWidget(),
                orElse: () => const SizedBox(),
              )
        ],
      ),
    );
  }

  void _navigateToHome() => _appNavigator.navigateToHome(context);

  void _navigateToResetPassword() =>
      _appNavigator.navigateToResetPassword(context);

  void _showError(String errorMessage) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: Constants.snackBarDurationInSecond),
      content: Text(errorMessage),
    ));
  }

  void _hideKeyboard() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
