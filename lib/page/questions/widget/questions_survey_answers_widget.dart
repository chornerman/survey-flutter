import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:survey/api/response/question_response.dart';
import 'package:survey/model/answer_model.dart';
import 'package:survey/model/question_model.dart';
import 'package:survey/page/questions/questions_page.dart';
import 'package:survey/resource/dimens.dart';

class QuestionsSurveyAnswersWidget extends ConsumerStatefulWidget {
  final QuestionModel question;

  QuestionsSurveyAnswersWidget({required this.question}) : super();

  @override
  _QuestionsSurveyAnswersWidgetState createState() =>
      _QuestionsSurveyAnswersWidgetState();
}

class _QuestionsSurveyAnswersWidgetState
    extends ConsumerState<QuestionsSurveyAnswersWidget> {
  @override
  Widget build(BuildContext context) {
    switch (widget.question.displayType) {
      case DisplayType.dropdown:
        return _buildDropdownAnswer(
          context: context,
          answers: widget.question.answers,
          onSelect: (answer) => saveDropdownAnswer(answer),
        );
      default:
        return const SizedBox();
    }
  }

  Widget _buildDropdownAnswer({
    required BuildContext context,
    required List<AnswerModel> answers,
    required Function(AnswerModel) onSelect,
  }) {
    // Select first answer by default
    onSelect(answers.first);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimens.space80),
      child: Picker(
        adapter: PickerDataAdapter<String>(
          pickerdata: answers.map((answer) => answer.text).toList(),
        ),
        textStyle: Theme.of(context).textTheme.bodyText1?.copyWith(
              fontSize: 20.0,
              color: Colors.white.withOpacity(0.5),
            ),
        selectedTextStyle:
            Theme.of(context).textTheme.headline6?.copyWith(fontSize: 20.0),
        selectionOverlay: DecoratedBox(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Colors.white,
                width: Dimens.questionsDropdownAnswerSeparatorWidth,
              ),
              bottom: BorderSide(
                color: Colors.white,
                width: Dimens.questionsDropdownAnswerSeparatorWidth,
              ),
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        containerColor: Colors.transparent,
        itemExtent: 65,
        hideHeader: true,
        onSelect: (picker, index, selected) {
          onSelect(answers[selected.first]);
        },
      ).makePicker(),
    );
  }

  void saveDropdownAnswer(AnswerModel answer) {
    ref
        .read(questionsViewModelProvider.notifier)
        .saveDropdownAnswer(widget.question.id, answer);
  }
}
