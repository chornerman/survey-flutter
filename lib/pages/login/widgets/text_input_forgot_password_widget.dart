import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TextInputForgotPasswordWidget extends StatelessWidget {
  const TextInputForgotPasswordWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        // TODO: Define in integration part
      },
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
}
