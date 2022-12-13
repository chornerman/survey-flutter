import 'package:flutter/material.dart';
import 'package:survey/resource/dimens.dart';

class CustomButtonWidget extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;

  const CustomButtonWidget({
    Key? key,
    required this.buttonText,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: Dimens.space56,
      child: TextButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
          shape: MaterialStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Dimens.space10),
            ),
          ),
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
