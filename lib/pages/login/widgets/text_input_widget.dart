import 'package:flutter/material.dart';
import 'package:survey/dimens.dart';

class TextInputWidget extends StatelessWidget {
  final String hintText;
  final bool isPasswordInput;
  final Widget? endWidget;

  const TextInputWidget({
    Key? key,
    required this.hintText,
    this.isPasswordInput = false,
    this.endWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Dimens.space56,
      padding: const EdgeInsets.symmetric(horizontal: Dimens.space12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(Dimens.space12),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: TextFormField(
              obscureText: isPasswordInput,
              enableSuggestions: !isPasswordInput,
              autocorrect: !isPasswordInput,
              style: const TextStyle(
                fontSize: 17,
                color: Colors.white,
              ),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(
                  fontSize: 17,
                  color: Colors.white.withOpacity(0.2),
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          if (endWidget != null) Expanded(flex: 0, child: endWidget!),
        ],
      ),
    );
  }
}
