import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:survey/constants.dart';
import 'package:survey/di/di.dart';
import 'package:survey/gen/assets.gen.dart';
import 'package:survey/gen/colors.gen.dart';
import 'package:survey/page/resetpassword/reset_password_state.dart';
import 'package:survey/page/resetpassword/reset_password_view_model.dart';
import 'package:survey/resource/dimens.dart';
import 'package:survey/usecase/reset_password_use_case.dart';
import 'package:survey/widget/app_bar_back_button_widget.dart';
import 'package:survey/widget/dimmed_background_widget.dart';
import 'package:survey/widget/loading_indicator_widget.dart';
import 'package:survey/widget/rounded_button_widget.dart';
import 'package:survey/widget/text_input_widget.dart';

final resetPasswordViewModelProvider = StateNotifierProvider.autoDispose<
    ResetPasswordViewModel, ResetPasswordState>((ref) {
  return ResetPasswordViewModel(getIt.get<ResetPasswordUseCase>());
});

class ResetPasswordPage extends ConsumerStatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends ConsumerState<ResetPasswordPage> {
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ref.listen<ResetPasswordState>(resetPasswordViewModelProvider, (
      ResetPasswordState? previousState,
      ResetPasswordState newState,
    ) {
      newState.maybeWhen(
        success: () => _showResetPasswordSuccessFlushbar(),
        apiError: (errorMessage) => _showError(errorMessage),
        invalidInputError: () =>
            _showError(AppLocalizations.of(context)!.resetPasswordInvalidEmail),
        orElse: () {},
      );
    });

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          DimmedBackgroundWidget(
            background: AssetImage(Assets.images.bgOnboarding.path),
            shouldBlur: true,
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimens.space24),
              child: Column(
                children: [
                  const SizedBox(height: Dimens.space120),
                  Assets.images.icNimble.svg(),
                  const SizedBox(height: Dimens.space24),
                  Text(
                    AppLocalizations.of(context)!.resetPasswordDescription,
                    style: Theme.of(context).textTheme.bodyText1?.copyWith(
                          color: Colors.white.withOpacity(0.7),
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: Dimens.space96),
                  TextInputWidget(
                    hintText: AppLocalizations.of(context)!.email,
                    controller: _emailController,
                  ),
                  const SizedBox(height: Dimens.space20),
                  RoundedButtonWidget(
                    buttonText:
                        AppLocalizations.of(context)!.resetPasswordReset,
                    onPressed: () {
                      _hideKeyboard();
                      ref
                          .read(resetPasswordViewModelProvider.notifier)
                          .resetPassword(_emailController.text);
                    },
                    shouldExpandedWidth: true,
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                top: Dimens.space24,
                left: Dimens.space22,
              ),
              child: AppBarBackButtonWidget(),
            ),
          ),
          ref.watch(resetPasswordViewModelProvider).maybeWhen(
                loading: () => const LoadingIndicatorWidget(),
                orElse: () => const SizedBox(),
              )
        ],
      ),
    );
  }

  void _showResetPasswordSuccessFlushbar() {
    Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.GROUNDED,
      duration: Duration(seconds: Constants.snackBarDurationInSecond),
      backgroundColor: ColorName.raisinBlack,
      titleText: Text(
        AppLocalizations.of(context)!.resetPasswordSuccessTitle,
        style: Theme.of(context).textTheme.bodyText2?.copyWith(
              fontWeight: FontWeight.w800,
            ),
      ),
      messageText: Text(
        AppLocalizations.of(context)!.resetPasswordSuccessDescription,
        style: Theme.of(context).textTheme.subtitle1?.copyWith(
              fontWeight: FontWeight.w400,
            ),
      ),
      icon: Assets.images.icNotification.svg(),
    ).show(context);
  }

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
    super.dispose();
  }
}
