import 'package:flutter/material.dart';
import 'package:survey/gen/colors.gen.dart';
import 'package:survey/resource/dimens.dart';

class MultipleChoicesAnswerWidget extends StatefulWidget {
  final List<MultipleChoicesItemModel> items;
  final ValueChanged<List<MultipleChoicesItemModel>> onItemsChanged;

  MultipleChoicesAnswerWidget({
    required this.items,
    required this.onItemsChanged,
  });

  @override
  _MultipleChoicesAnswerWidgetState createState() =>
      _MultipleChoicesAnswerWidgetState();
}

class _MultipleChoicesAnswerWidgetState
    extends State<MultipleChoicesAnswerWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Dimens.questionsMultipleChoicesAnswerHeight,
      child: ListView.separated(
        itemCount: widget.items.length,
        itemBuilder: (context, index) {
          return _buildMultipleChoicesItem(
              context: context,
              index: index,
              onTap: () {
                setState(() {
                  widget.items[index].isSelected =
                      !widget.items[index].isSelected;
                });
                widget.onItemsChanged(
                    widget.items.where((item) => item.isSelected).toList());
              });
        },
        separatorBuilder: (context, index) => const Divider(
          color: Colors.white,
          height: Dimens.questionsMultipleChoicesAnswerSeparatorHeight,
        ),
      ),
    );
  }

  Widget _buildMultipleChoicesItem({
    required BuildContext context,
    required int index,
    required VoidCallback onTap,
  }) {
    final isSelected = widget.items[index].isSelected;

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Dimens.space24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                widget.items[index].text,
                style: TextStyle(
                    color: Colors.white.withOpacity(isSelected ? 1 : 0.5),
                    fontSize: 20.0,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w400),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: Dimens.space8),
              width: Dimens.questionsMultipleChoicesAnswerCheckboxSize,
              height: Dimens.questionsMultipleChoicesAnswerCheckboxSize,
              decoration: isSelected
                  ? BoxDecoration(shape: BoxShape.circle, color: Colors.white)
                  : BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        width: Dimens
                            .questionsMultipleChoicesAnswerCheckboxBorderWidth,
                        color: ColorName.gainsboro,
                      ),
                    ),
              child: isSelected
                  ? Icon(
                      Icons.check_rounded,
                      size:
                          Dimens.questionsMultipleChoicesAnswerCheckboxIconSize,
                      color: ColorName.chineseBlack,
                    )
                  : const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}

class MultipleChoicesItemModel {
  final String id;
  final String text;
  bool isSelected = false;

  MultipleChoicesItemModel(this.id, this.text);

  @override
  String toString() => text;
}
