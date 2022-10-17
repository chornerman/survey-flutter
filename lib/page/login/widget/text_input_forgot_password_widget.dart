import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:survey/di/di.dart';
import 'package:survey/navigator.dart';

class TextInputForgotPasswordWidget extends StatelessWidget {
  TextInputForgotPasswordWidget({Key? key}) : super(key: key);

  final _appNavigator = getIt.get<AppNavigator>();

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => navigateToResetPassword(context),
      style: TextButton.styleFrom(
        minimumSize: Size.zero,
        padding: EdgeInsets.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        AppLocalizations.of(context)!.loginForgotPassword,
        style: TextStyle(
          fontSize: 15,
          color: Colors.white.withOpacity(0.3),
        ),
      ),
    );
  }

  void navigateToResetPassword(BuildContext context) =>
      _appNavigator.navigateToResetPassword(context);
}
