import 'package:flutter/material.dart';
import 'package:survey/resource/dimens.dart';

class TextInputWidget extends StatelessWidget {
  final String hintText;
  final TextInputAction textInputAction;
  final bool isPasswordInput;
  final TextEditingController? controller;
  final Widget? endWidget;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;

  const TextInputWidget({
    Key? key,
    required this.hintText,
    required this.textInputAction,
    this.isPasswordInput = false,
    this.controller,
    this.endWidget,
    this.onChanged,
    this.keyboardType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Dimens.textInputHeight,
      padding: const EdgeInsets.symmetric(horizontal: Dimens.space12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(Dimens.textInputBorderRadius),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: TextFormField(
              controller: controller,
              obscureText: isPasswordInput,
              enableSuggestions: !isPasswordInput,
              autocorrect: !isPasswordInput,
              style: Theme.of(context).textTheme.bodyText1,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: Theme.of(context).textTheme.bodyText1?.copyWith(
                      color: Colors.white.withOpacity(0.3),
                    ),
                border: InputBorder.none,
              ),
              onChanged: onChanged,
              textInputAction: textInputAction,
              keyboardType: keyboardType,
            ),
          ),
          if (endWidget != null) Expanded(flex: 0, child: endWidget!),
        ],
      ),
    );
  }
}
