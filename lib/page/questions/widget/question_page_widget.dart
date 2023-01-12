import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:survey/model/question_model.dart';
import 'package:survey/page/questions/widget/answer_widget.dart';
import 'package:survey/resource/dimens.dart';
import 'package:survey/widget/dimmed_background_widget.dart';
import 'package:survey/widget/next_button_widget.dart';
import 'package:survey/widget/rounded_button_widget.dart';

class QuestionPageWidget extends StatelessWidget {
  final QuestionModel question;
  final int questionNumber;
  final int totalQuestions;
  final VoidCallback onNextQuestion;
  final VoidCallback onSubmitSurvey;

  const QuestionPageWidget({
    Key? key,
    required this.question,
    required this.questionNumber,
    required this.totalQuestions,
    required this.onNextQuestion,
    required this.onSubmitSurvey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLastQuestion = questionNumber == totalQuestions;

    return Stack(
      children: [
        DimmedBackgroundWidget(
          background: Image.network(question.coverImageUrl).image,
          opacity: question.coverImageOpacity,
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
              top: Dimens.space80,
              bottom: Dimens.space20,
              left: Dimens.space20,
              right: Dimens.space20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$questionNumber/$totalQuestions',
                  style: Theme.of(context).textTheme.bodyText2?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: Colors.white.withOpacity(0.5),
                      ),
                ),
                const SizedBox(height: Dimens.space8),
                Text(
                  question.text,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headline5,
                ),
                const Expanded(child: const SizedBox.shrink()),
                Align(
                  alignment: Alignment.center,
                  child: AnswerWidget(question: question),
                ),
                const Expanded(child: const SizedBox.shrink()),
                Align(
                  alignment: Alignment.centerRight,
                  child: isLastQuestion
                      ? RoundedButtonWidget(
                          buttonText:
                              AppLocalizations.of(context)!.questionsSubmit,
                          onPressed: () => onSubmitSurvey.call(),
                        )
                      : NextButtonWidget(
                          onPressed: () => onNextQuestion.call(),
                        ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
