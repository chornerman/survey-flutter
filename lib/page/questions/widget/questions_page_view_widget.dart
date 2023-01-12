import 'package:flutter/material.dart';
import 'package:survey/model/question_model.dart';
import 'package:survey/page/questions/widget/question_page_widget.dart';

class QuestionsPageViewWidget extends StatelessWidget {
  final List<QuestionModel> questions;

  final _pageController = PageController();

  QuestionsPageViewWidget({required this.questions});

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
            onNextQuestion: () {
              _pageController.animateToPage(
                index + 1,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
              );
            },
            onSubmitSurvey: () {
              // TODO: Submit answers
            },
          );
        });
  }
}
