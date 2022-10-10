import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:survey/dimens.dart';
import 'package:survey/gen/assets.gen.dart';
import 'package:survey/pages/login/widgets/login_button_widget.dart';
import 'package:survey/pages/login/widgets/text_input_forgot_password_widget.dart';
import 'package:survey/pages/login/widgets/text_input_widget.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: Dimens.space20),
                child: TextInputWidget(
                  hintText: AppLocalizations.of(context)!.loginPassword,
                  isPasswordInput: true,
                  endWidget: const TextInputForgotPasswordWidget(),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: Dimens.space20),
                child: LoginButtonWidget(
                  buttonText: AppLocalizations.of(context)!.login,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
