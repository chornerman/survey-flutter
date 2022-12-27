import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:survey/gen/assets.gen.dart';
import 'package:survey/resource/dimens.dart';
import 'package:survey/widget/app_bar_back_button_widget.dart';
import 'package:survey/widget/onboarding_background_widget.dart';
import 'package:survey/widget/rounded_button_widget.dart';
import 'package:survey/widget/text_input_widget.dart';

class ResetPasswordPage extends StatelessWidget {
  const ResetPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                  ),
                  const SizedBox(height: Dimens.space20),
                  RoundedButtonWidget(
                    buttonText:
                        AppLocalizations.of(context)!.resetPasswordReset,
                    onPressed: () {
                      // TODO: Call reset password use case
                    },
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: Dimens.space24, left: Dimens.space22),
            child: AppBarBackButtonWidget(),
          ),
        ],
      ),
    );
  }
}
