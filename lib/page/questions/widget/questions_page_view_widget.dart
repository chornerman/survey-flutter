import 'package:flutter/material.dart';
import 'package:survey/model/question_model.dart';
import 'package:survey/page/questions/widget/questions_item_widget.dart';

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
          final questionNumber = index + 1;
          final isLastQuestion = questionNumber == totalQuestions;

          return QuestionsItemWidget(
            question: questions[index],
            questionNumber: questionNumber,
            totalQuestions: totalQuestions,
            onButtonPressed: () {
              if (isLastQuestion) {
                // TODO: Submit answers
              } else {
                _pageController.animateToPage(
                  index + 1,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                );
              }
            },
          );
        });
  }
}
