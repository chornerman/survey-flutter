import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:survey/assets.dart';
import 'package:survey/dimens.dart';
import 'package:survey/pages/login/widgets/login_button_widget.dart';
import 'package:survey/pages/login/widgets/text_input_widget.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(Assets.loginBackground),
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
                child: SvgPicture.asset(Assets.nimbleIcon),
              ),
              Container(
                margin: const EdgeInsets.only(top: Dimens.space110),
                child: const TextInputWidget(hintText: "Email"),
              ),
              Container(
                margin: const EdgeInsets.only(top: Dimens.space20),
                child: const TextInputWidget(
                  hintText: "Password",
                  isPasswordInput: true,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: Dimens.space20),
                child: const LoginButtonWidget(buttonText: "Log in"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
