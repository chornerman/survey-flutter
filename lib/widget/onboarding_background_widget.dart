import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:survey/gen/assets.gen.dart';

class OnboardingBackgroundWidget extends StatelessWidget {
  final bool shouldBlur;
  final Widget content;

  const OnboardingBackgroundWidget({
    Key? key,
    required this.shouldBlur,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(Assets.images.bgOnboarding.path),
          fit: BoxFit.cover,
        ),
      ),
      child: shouldBlur
          ? BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
              child: content,
            )
          : content,
    );
  }
}
