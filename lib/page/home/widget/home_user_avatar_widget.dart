import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:survey/gen/colors.gen.dart';
import 'package:survey/resource/dimens.dart';

class HomeUserAvatarWidget extends StatelessWidget {
  final String? userAvatarUrl;

  const HomeUserAvatarWidget({
    Key? key,
    required this.userAvatarUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: userAvatarUrl ?? "",
      imageBuilder: (context, imageProvider) => CircleAvatar(
        backgroundImage: imageProvider,
        backgroundColor: ColorName.chineseBlack,
        radius: Dimens.homeUserAvatarSize / 2,
      ),
      errorWidget: (context, url, error) => _buildPlaceHolderUserAvatar(),
    );
  }

  Widget _buildPlaceHolderUserAvatar() {
    return CircleAvatar(
      child: Icon(Icons.person, color: Colors.white38),
      backgroundColor: ColorName.chineseBlack,
      radius: Dimens.homeUserAvatarSize / 2,
    );
  }
}
