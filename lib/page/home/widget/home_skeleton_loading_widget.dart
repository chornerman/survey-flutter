import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:survey/resource/dimens.dart';

class HomeSkeletonLoadingWidget extends StatelessWidget {
  const HomeSkeletonLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final dividedScreenWidth = screenWidth / 10;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(Dimens.space20),
        child: Shimmer.fromColors(
          baseColor: Colors.white12,
          highlightColor: Colors.white30,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SafeArea(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSkeleton(dividedScreenWidth * 3),
                        const SizedBox(height: Dimens.space14),
                        _buildSkeleton(dividedScreenWidth * 2.5),
                      ],
                    ),
                    const Expanded(child: const SizedBox.shrink()),
                    _buildSkeleton(
                      Dimens.homeUserAvatarSize,
                      height: Dimens.homeUserAvatarSize,
                      borderRadius: Dimens.homeUserAvatarSize / 2,
                    )
                  ],
                ),
              ),
              const Expanded(child: const SizedBox.shrink()),
              _buildSkeleton(dividedScreenWidth),
              const SizedBox(height: Dimens.space16),
              _buildSkeleton(dividedScreenWidth * 7),
              const SizedBox(height: Dimens.space8),
              _buildSkeleton(dividedScreenWidth * 3),
              const SizedBox(height: Dimens.space16),
              _buildSkeleton(dividedScreenWidth * 8.5),
              const SizedBox(height: Dimens.space8),
              _buildSkeleton(dividedScreenWidth * 6),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSkeleton(
    double width, {
    double height = Dimens.homeSkeletonLoadingTextHeight,
    double borderRadius = Dimens.homeSkeletonLoadingTextBorderRadius,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: Colors.white,
      ),
    );
  }
}
