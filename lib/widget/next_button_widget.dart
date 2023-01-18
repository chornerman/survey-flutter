import 'package:flutter/material.dart';
import 'package:survey/gen/assets.gen.dart';
import 'package:survey/resource/dimens.dart';

class NextButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;

  const NextButtonWidget({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Assets.images.icArrowNext.svg(),
      style: ElevatedButton.styleFrom(
        elevation: 0,
        shape: const CircleBorder(),
        backgroundColor: Colors.white,
        minimumSize: Size(Dimens.nextButtonSize, Dimens.nextButtonSize),
      ),
      onPressed: onPressed,
    );
  }
}
