import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:survey/di/di.dart';
import 'package:survey/model/survey_model.dart';
import 'package:survey/navigator.dart';
import 'package:survey/page/home/home_page.dart';
import 'package:survey/page/home/widget/home_surveys_item_widget.dart';

class HomeSurveysPageViewWidget extends ConsumerWidget {
  final List<SurveyModel> surveys;
  final VoidCallback loadMoreSurveys;
  final ValueNotifier<int> currentSurveysPage;

  final _appNavigator = getIt.get<AppNavigator>();

  final _pageController = PageController();

  HomeSurveysPageViewWidget({
    required this.surveys,
    required this.loadMoreSurveys,
    required this.currentSurveysPage,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<void>>(jumpToFirstSurveysPageStreamProvider,
        (oldValue, newValue) {
      _pageController.jumpToPage(0);
    });

    if (currentSurveysPage.value > surveys.length - 1) {
      currentSurveysPage.value = surveys.length - 1;
    }

    return PageView.builder(
      itemCount: surveys.length,
      controller: _pageController,
      itemBuilder: (BuildContext context, int index) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (index + 1 == surveys.length) loadMoreSurveys.call();
        });
        return HomeSurveysItemWidget(
          survey: surveys[index],
          onNextButtonPressed: () =>
              _appNavigator.navigateToSurveyDetail(context, surveys[index].id),
        );
      },
      onPageChanged: (int index) {
        currentSurveysPage.value = index;
      },
    );
  }
}
