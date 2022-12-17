import 'package:flutter/material.dart';
import 'package:survey/resource/dimens.dart';

class RoundedButtonWidget extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  final bool shouldExpandedWidth;

  const RoundedButtonWidget({
    Key? key,
    required this.buttonText,
    required this.onPressed,
    this.shouldExpandedWidth = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: shouldExpandedWidth ? double.infinity : null,
      height: Dimens.roundedButtonHeight,
      child: TextButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
          shape: MaterialStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(Dimens.roundedButtonBorderRadius),
            ),
          ),
          padding: MaterialStateProperty.all<EdgeInsets>(
              EdgeInsets.symmetric(horizontal: Dimens.space20)),
        ),
        onPressed: onPressed,
        child: Text(
          buttonText,
          style: Theme.of(context).textTheme.button,
        ),
      ),
    );
  }
}
