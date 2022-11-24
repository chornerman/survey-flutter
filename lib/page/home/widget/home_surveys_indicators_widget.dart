import 'package:flutter/material.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';
import 'package:survey/resource/dimens.dart';

class HomeSurveysIndicatorsWidget extends StatelessWidget {
  final int surveysAmount;
  final ValueNotifier<int> currentSurveysPage;

  const HomeSurveysIndicatorsWidget({
    Key? key,
    required this.surveysAmount,
    required this.currentSurveysPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: currentSurveysPage,
      builder: (context, int currentSurveysPage, child) =>
          _buildSurveysIndicator(currentSurveysPage, surveysAmount),
    );
  }

  Widget _buildSurveysIndicator(int currentSurveysPage, int surveysAmount) {
    if (currentSurveysPage > surveysAmount) {
      this.currentSurveysPage.value = surveysAmount - 1;
      return const SizedBox();
    } else {
      return Column(
        children: [
          const Expanded(child: const SizedBox.shrink()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimens.space15),
            child: PageViewDotIndicator(
              currentItem: currentSurveysPage,
              count: surveysAmount,
              selectedColor: Colors.white,
              unselectedColor: Colors.white.withOpacity(0.2),
              size: const Size(
                Dimens.homeSurveysIndicatorsSize,
                Dimens.homeSurveysIndicatorsSize,
              ),
              unselectedSize: const Size(
                Dimens.homeSurveysIndicatorsSize,
                Dimens.homeSurveysIndicatorsSize,
              ),
              margin: const EdgeInsets.symmetric(horizontal: Dimens.space5),
              padding: EdgeInsets.zero,
              alignment: Alignment.centerLeft,
              fadeEdges: false,
            ),
          ),
          const SizedBox(height: Dimens.space170),
        ],
      );
    }
  }
}
