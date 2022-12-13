import 'package:flutter/material.dart';
import 'package:survey/model/survey_model.dart';
import 'package:survey/page/home/widget/home_surveys_item_widget.dart';

class HomeSurveysPageViewWidget extends StatelessWidget {
  final List<SurveyModel> surveys;
  final VoidCallback loadMoreSurveys;
  final _pageController = PageController();

  HomeSurveysPageViewWidget({
    required this.surveys,
    required this.loadMoreSurveys,
  });

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemCount: surveys.length,
      controller: _pageController,
      itemBuilder: (BuildContext context, int index) {
        if (index + 1 == surveys.length) loadMoreSurveys.call();

        return HomeSurveysItemWidget(
          survey: surveys[index],
          onNextButtonPressed: () => {
            // TODO: Navigate to Survey Detail screen
          },
        );
      },
    );
  }
}