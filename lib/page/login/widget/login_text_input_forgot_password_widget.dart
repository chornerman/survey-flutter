import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginTextInputForgotPasswordWidget extends StatelessWidget {
  final VoidCallback onPressed;

  const LoginTextInputForgotPasswordWidget({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        minimumSize: Size.zero,
        padding: EdgeInsets.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        AppLocalizations.of(context)!.loginForgotPassword,
        style: Theme.of(context).textTheme.bodyText2?.copyWith(
              color: Colors.white.withOpacity(0.3),
            ),
      ),
    );
  }
}
