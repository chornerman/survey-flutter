import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:survey/constants.dart';
import 'package:survey/resource/dimens.dart';

final selectedEmojiIndexProvider = StateProvider.autoDispose<int>(
    (_) => Constants.defaultSmileyRatingBarIndex);
const _emojis = ['😡', '😕', '😐', '🙂', '😄'];

class SmileyRatingBarAnswerWidget extends ConsumerWidget {
  final Function onRatingUpdate;

  const SmileyRatingBarAnswerWidget({
    required this.onRatingUpdate,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity,
      height: Dimens.questionsSmileyRatingBarAnswerHeight,
      alignment: Alignment.center,
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: _emojis.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => _onEmojiSelected(ref, index),
              child: Padding(
                padding: const EdgeInsets.all(Dimens.space10),
                child: Consumer(
                  builder: (context, widgetRef, child) {
                    final selectedIndex = ref.watch(selectedEmojiIndexProvider);
                    return _buildSmileyRatingBar(context, index, selectedIndex);
                  },
                ),
              ),
            );
          }),
    );
  }

  Widget _buildSmileyRatingBar(
    BuildContext context,
    int index,
    int selectedIndex,
  ) {
    final selectedStyle = Theme.of(context).textTheme.headline5;
    final unselectedStyle =
        selectedStyle?.copyWith(color: Colors.black.withOpacity(0.5));
    final style = index == selectedIndex ? selectedStyle : unselectedStyle;

    return Text(_emojis[index], style: style);
  }

  void _onEmojiSelected(WidgetRef ref, int selectedIndex) {
    final selectedIndexState = ref.read(selectedEmojiIndexProvider.notifier);
    final previousIndex = selectedIndexState.state;

    if (previousIndex == selectedIndex) return;

    selectedIndexState.state = selectedIndex;
    onRatingUpdate(selectedIndex + 1);
  }
}
