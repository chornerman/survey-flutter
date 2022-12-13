import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:survey/di/di.dart';
import 'package:survey/gen/assets.gen.dart';
import 'package:survey/navigator.dart';
import 'package:survey/page/login/login_state.dart';
import 'package:survey/page/login/login_view_model.dart';
import 'package:survey/page/login/widget/text_input_forgot_password_widget.dart';
import 'package:survey/resource/dimens.dart';
import 'package:survey/usecase/login_use_case.dart';
import 'package:survey/widget/circular_progress_bar_widget.dart';
import 'package:survey/widget/custom_button_widget.dart';
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
        apiError: (error) =>
            _showError(AppLocalizations.of(context)!.loginError),
        invalidInputsError: () =>
            _showError(AppLocalizations.of(context)!.loginInvalidEmailPassword),
        orElse: () {},
      );
    });

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(Assets.images.bgLogin.path),
              fit: BoxFit.cover,
            ),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 30,
              sigmaY: 30,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: Dimens.space24),
              decoration: BoxDecoration(color: Colors.black.withOpacity(0.4)),
              child: SafeArea(
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: Dimens.space120),
                      child: Assets.images.icNimble.svg(),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: Dimens.space110),
                      child: TextInputWidget(
                        hintText: AppLocalizations.of(context)!.loginEmail,
                        controller: _emailController,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: Dimens.space20),
                      child: TextInputWidget(
                        hintText: AppLocalizations.of(context)!.loginPassword,
                        isPasswordInput: true,
                        controller: _passwordController,
                        endWidget: TextInputForgotPasswordWidget(
                          onPressed: () {
                            _navigateToResetPassword();
                          },
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: Dimens.space20),
                      child: CustomButtonWidget(
                        buttonText: AppLocalizations.of(context)!.login,
                        onPressed: () {
                          _hideKeyboard();
                          ref.read(loginViewModelProvider.notifier).login(
                                _emailController.text,
                                _passwordController.text,
                              );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        ref.watch(loginViewModelProvider).maybeWhen(
              loading: () => const CircularProgressBarWidget(),
              orElse: () => const SizedBox(),
            )
      ],
    );
  }

  void _navigateToHome() => _appNavigator.navigateToHome(context);

  void _navigateToResetPassword() =>
      _appNavigator.navigateToResetPassword(context);

  void _showError(String errorMessage) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 2),
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
