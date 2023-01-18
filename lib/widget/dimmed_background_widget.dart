import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:survey/constants.dart';

class DimmedBackgroundWidget extends StatelessWidget {
  final ImageProvider background;
  final double opacity;
  final bool shouldBlur;

  const DimmedBackgroundWidget({
    Key? key,
    required this.background,
    this.opacity = Constants.defaultDimmedBackgroundOpacity,
    this.shouldBlur = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: background,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(opacity),
            BlendMode.darken,
          ),
          fit: BoxFit.cover,
        ),
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
