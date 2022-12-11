import 'package:flutter/material.dart';
import 'package:survey/di/di.dart';
import 'package:survey/gen/assets.gen.dart';
import 'package:survey/navigator.dart';

class AppBarBackButtonWidget extends StatelessWidget {
  AppBarBackButtonWidget({super.key});

  final _appNavigator = getIt.get<AppNavigator>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: IconButton(
        icon: Assets.images.icBackArrow.svg(),
        padding: EdgeInsets.zero,
        constraints: BoxConstraints(),
        onPressed: () => _appNavigator.navigateBack(context),
      ),
    );
  }
}
