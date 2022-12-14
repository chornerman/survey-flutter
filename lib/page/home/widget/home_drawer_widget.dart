import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:survey/gen/colors.gen.dart';
import 'package:survey/page/home/widget/home_user_avatar_widget.dart';
import 'package:survey/resource/dimens.dart';

class HomeDrawerWidget extends StatelessWidget {
  const HomeDrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: Dimens.homeDrawerWidthFactor,
      child: Drawer(
        backgroundColor: ColorName.eerieBlack90,
        elevation: 0,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
              top: Dimens.space50,
              bottom: Dimens.space20,
              left: Dimens.space20,
              right: Dimens.space20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: Dimens.space8),
                      child: Text(
                        // TODO: Display user name from API
                        AppLocalizations.of(context)!.homeUser,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.headline5,
                      ),
                    ),
                  ),
                  // TODO: Display user avatar from API
                  HomeUserAvatarWidget(userAvatarUrl: null),
                ]),
                const SizedBox(height: Dimens.space20),
                Container(
                  width: double.infinity,
                  height: Dimens.homeDrawerSeparatorHeight,
                  color: Colors.white,
                ),
                const SizedBox(height: Dimens.space35),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    AppLocalizations.of(context)!.homeLogout,
                    style: Theme.of(context).textTheme.bodyText1?.copyWith(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 20.0,
                        ),
                  ),
                ),
                const Expanded(child: const SizedBox.shrink()),
                Text(
                  // TODO: Display version number
                  'v0.1.0 (1562903885)',
                  style: Theme.of(context).textTheme.caption?.copyWith(
                        color: Colors.white.withOpacity(0.5),
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
