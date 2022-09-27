import 'package:flutter/material.dart';
import 'package:survey/dimens.dart';
import 'package:survey/gen/colors.gen.dart';

class LoginButtonWidget extends StatelessWidget {
  final String buttonText;

  const LoginButtonWidget({
    Key? key,
    required this.buttonText,
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
        onPressed: () {
          // TODO: Define in integration part
        },
        child: Text(
          buttonText,
          style: const TextStyle(
            color: ColorName.chineseBlack,
            fontSize: 17,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
