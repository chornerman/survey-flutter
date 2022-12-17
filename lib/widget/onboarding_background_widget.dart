import 'dart:ui';

import 'package:flutter/material.dart';

class OnboardingBackgroundWidget extends StatelessWidget {
  final ImageProvider background;
  final bool shouldBlur;

  const OnboardingBackgroundWidget({
    Key? key,
    required this.background,
    required this.shouldBlur,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(image: background, fit: BoxFit.cover),
      ),
      child: shouldBlur
          ? BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
              child: const SizedBox(),
            )
          : const SizedBox(),
    );
  }
}
