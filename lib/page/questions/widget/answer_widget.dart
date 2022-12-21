import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:survey/api/response/question_response.dart';
import 'package:survey/gen/assets.gen.dart';
import 'package:survey/model/answer_model.dart';
import 'package:survey/model/question_model.dart';
import 'package:survey/model/submit_survey_question_model.dart';
import 'package:survey/page/questions/questions_page.dart';
import 'package:survey/page/questions/widget/answer/dropdown_answer_widget.dart';
import 'package:survey/page/questions/widget/answer/multiple_choices_answer_widget.dart';
import 'package:survey/page/questions/widget/answer/number_rating_bar_answer_widget.dart';
import 'package:survey/page/questions/widget/answer/smiley_rating_bar_answer_widget.dart';
import 'package:survey/resource/dimens.dart';

class AnswerWidget extends ConsumerStatefulWidget {
  final QuestionModel question;

  AnswerWidget({required this.question}) : super();

  @override
  _AnswerWidgetState createState() => _AnswerWidgetState();
}

class _AnswerWidgetState extends ConsumerState<AnswerWidget> {
  @override
  Widget build(BuildContext context) {
    switch (widget.question.displayType) {
      case DisplayType.dropdown:
        return _buildDropdownAnswer(
          context: context,
          answers: widget.question.answers,
          onSelect: (answer) => saveDropdownAnswer(answer),
        );
      case DisplayType.star:
        return _buildIconsRatingBarAnswer(
          activeIcon: Assets.images.icStarActive,
          inactiveIcon: Assets.images.icStarInactive,
          itemCount: widget.question.answers.length,
          onRatingUpdate: (rating) => _saveRatingBarsAnswer(rating),
        );
      case DisplayType.heart:
        return _buildIconsRatingBarAnswer(
          activeIcon: Assets.images.icHeartActive,
          inactiveIcon: Assets.images.icHeartInactive,
          itemCount: widget.question.answers.length,
          onRatingUpdate: (rating) => _saveRatingBarsAnswer(rating),
        );
      case DisplayType.smiley:
        return _buildSmileyRatingBarAnswer(
          onRatingUpdate: (rating) => _saveRatingBarsAnswer(rating),
        );
      case DisplayType.nps:
        return _buildNumberRatingBarAnswer(
          itemCount: widget.question.answers.length,
          onRatingUpdate: (rating) => _saveRatingBarsAnswer(rating),
        );
      case DisplayType.choice:
        return _buildMultipleChoicesAnswer(
          answers: widget.question.answers,
          onItemsChanged: (items) => _saveMultipleChoicesAnswer(
            items
                .map((item) =>
                    SubmitSurveyAnswerModel(id: item.id, answer: item.text))
                .toList(),
          ),
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
    return DropdownAnswerWidget(answers: answers, onSelect: onSelect);
  }

  Widget _buildIconsRatingBarAnswer({
    required AssetGenImage activeIcon,
    required AssetGenImage inactiveIcon,
    required int itemCount,
    required Function onRatingUpdate,
  }) {
    return RatingBar(
      itemCount: itemCount,
      ratingWidget: RatingWidget(
        full: activeIcon.image(
          width: Dimens.questionsIconsRatingBarAnswerIconSize,
          height: Dimens.questionsIconsRatingBarAnswerIconSize,
        ),
        half: const SizedBox(),
        empty: inactiveIcon.image(
          width: Dimens.questionsIconsRatingBarAnswerIconSize,
          height: Dimens.questionsIconsRatingBarAnswerIconSize,
        ),
      ),
      itemPadding: const EdgeInsets.symmetric(horizontal: Dimens.space10),
      glow: false,
      onRatingUpdate: (rating) => onRatingUpdate(rating.toInt()),
    );
  }

  Widget _buildSmileyRatingBarAnswer({
    required Function onRatingUpdate,
  }) {
    // Select default value
    onRatingUpdate(ref.read(selectedEmojiIndexProvider.notifier).state + 1);

    return SmileyRatingBarAnswerWidget(
      onRatingUpdate: (rating) => onRatingUpdate(rating.toInt()),
    );
  }

  Widget _buildNumberRatingBarAnswer({
    required int itemCount,
    required Function onRatingUpdate,
  }) {
    return NumberRatingBarAnswerWidget(
      itemCount: itemCount,
      onRatingUpdate: (rating) => onRatingUpdate(rating.toInt()),
      glow: false,
    );
  }

  Widget _buildMultipleChoicesAnswer({
    required List<AnswerModel> answers,
    required Function(List<MultipleChoicesItemModel>) onItemsChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimens.space60),
      child: MultipleChoicesAnswerWidget(
        items: answers
            .map((answer) => MultipleChoicesItemModel(answer.id, answer.text))
            .toList(),
        onItemsChanged: (items) => onItemsChanged(items),
      ),
    );
  }

  void saveDropdownAnswer(AnswerModel answer) {
    ref
        .read(questionsViewModelProvider.notifier)
        .saveDropdownAnswer(widget.question.id, answer);
  }

  void _saveRatingBarsAnswer(int rating) {
    ref
        .read(questionsViewModelProvider.notifier)
        .saveRatingBarsAnswer(widget.question.id, rating);
  }

  void _saveMultipleChoicesAnswer(List<SubmitSurveyAnswerModel> answers) {
    ref
        .read(questionsViewModelProvider.notifier)
        .saveMultipleChoicesAnswer(widget.question.id, answers);
  }
}
