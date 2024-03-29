import 'package:flutter/material.dart';
import 'package:survey/model/question_model.dart';
import 'package:survey/page/questions/widget/question_page_widget.dart';

class QuestionsPageViewWidget extends StatelessWidget {
  final List<QuestionModel> questions;
  final VoidCallback onSubmitSurveyPressed;

  final _pageController = PageController();

  QuestionsPageViewWidget({
    Key? key,
    required this.questions,
    required this.onSubmitSurveyPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final totalQuestions = questions.length;

    return PageView.builder(
        itemCount: totalQuestions,
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return QuestionPageWidget(
            question: questions[index],
            questionNumber: index + 1,
            totalQuestions: totalQuestions,
            onNextQuestionPressed: () {
              _hideKeyboard(context);
              _pageController.animateToPage(
                index + 1,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
              );
            },
            onSubmitSurveyPressed: () {
              _hideKeyboard(context);
              onSubmitSurveyPressed.call();
            },
          );
        });
  }

  void _hideKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }
}
