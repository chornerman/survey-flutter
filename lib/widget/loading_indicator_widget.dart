import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:survey/resource/dimens.dart';

class LoadingIndicatorWidget extends StatelessWidget {
  final bool shouldIgnoreOtherGestures;

  const LoadingIndicatorWidget({
    Key? key,
    required this.shouldIgnoreOtherGestures,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return shouldIgnoreOtherGestures
        ? Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.transparent,
            child: _buildLoadingIndicator(),
          )
        : _buildLoadingIndicator();
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: Container(
        padding: EdgeInsets.all(Dimens.space12),
        width: Dimens.circularProgressBarBackgroundSize,
        height: Dimens.circularProgressBarBackgroundSize,
        color: Colors.black54,
        child: LoadingIndicator(
          indicatorType: Indicator.lineSpinFadeLoader,
          colors: const [Colors.white],
        ),
      ),
    );
  }
}
