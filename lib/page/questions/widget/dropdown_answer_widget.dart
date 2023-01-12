import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:survey/model/answer_model.dart';
import 'package:survey/resource/dimens.dart';

class DropdownAnswerWidget extends StatelessWidget {
  final List<AnswerModel> answers;
  final Function(AnswerModel) onSelect;

  const DropdownAnswerWidget({
    Key? key,
    required this.answers,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
}
