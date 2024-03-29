import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lottie/lottie.dart';
import 'package:survey/di/di.dart';
import 'package:survey/gen/assets.gen.dart';
import 'package:survey/gen/colors.gen.dart';
import 'package:survey/navigator.dart';
import 'package:survey/resource/dimens.dart';

const _surveyCompletionPageDurationInSecond = 2;

class SurveyCompletionPage extends StatefulWidget {
  const SurveyCompletionPage({super.key});

  @override
  State<SurveyCompletionPage> createState() => _SurveyCompletionPageState();
}

class _SurveyCompletionPageState extends State<SurveyCompletionPage>
    with TickerProviderStateMixin {
  final _appNavigator = getIt.get<AppNavigator>();

  late final AnimationController _animationController =
      AnimationController(vsync: this)
        ..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            // Wait for 2 seconds after animation is completed before navigating back to the Home screen
            Timer(Duration(seconds: _surveyCompletionPageDurationInSecond), () {
              _appNavigator.navigateBack(context);
            });
          }
        });

  @override
  Widget build(BuildContext context) {
    final outroMessage = ModalRoute.of(context)!.settings.arguments as String?;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Dimens.space24),
      color: ColorName.chineseBlack,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Expanded(child: const SizedBox.shrink()),
          Lottie.asset(
            Assets.lotties.surveyCompleted,
            width: Dimens.surveyCompletionSurveyCompletedLottieSize,
            height: Dimens.surveyCompletionSurveyCompletedLottieSize,
            fit: BoxFit.fill,
            controller: _animationController,
            onLoaded: (composition) {
              _animationController
                ..duration = composition.duration
                ..forward();
            },
          ),
          Text(
            outroMessage ??
                AppLocalizations.of(context)!.surveyCompletionDefaultText,
            style: Theme.of(context).textTheme.headline6,
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const Expanded(child: const SizedBox.shrink()),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
