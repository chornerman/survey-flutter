import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:survey/resource/dimens.dart';

class TextAreaAnswerWidget extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const TextAreaAnswerWidget({
    Key? key,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: Theme.of(context).textTheme.bodyText1,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(
            Dimens.textInputBorderRadius,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: Dimens.space12,
          vertical: Dimens.space20,
        ),
        fillColor: Colors.white.withOpacity(0.2),
        filled: true,
        hintText: AppLocalizations.of(context)!.textAreaAnswerHint,
        hintStyle: Theme.of(context).textTheme.bodyText1?.copyWith(
              color: Colors.white.withOpacity(0.3),
            ),
      ),
      onChanged: onChanged,
      textInputAction: TextInputAction.newline,
      maxLines: 10,
    );
  }
}
