import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:survey/gen/colors.gen.dart';
import 'package:survey/resource/dimens.dart';

class HomeHeaderWidget extends StatelessWidget {
  final String currentDate;
  final String? userAvatarUrl;

  const HomeHeaderWidget({
    Key? key,
    required this.currentDate,
    required this.userAvatarUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Padding(
          padding: const EdgeInsets.all(Dimens.space20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentDate,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  const SizedBox(height: Dimens.space4),
                  Text(
                    AppLocalizations.of(context)!.homeToday,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ],
              ),
              const Expanded(child: const SizedBox.shrink()),
              CircleAvatar(
                backgroundImage: userAvatarUrl != null
                    ? Image.network(userAvatarUrl!).image
                    : null,
                child: userAvatarUrl == null
                    ? Icon(Icons.person, color: Colors.white38)
                    : null,
                backgroundColor: ColorName.chineseBlack,
                radius: Dimens.homeUserAvatarSize / 2,
              )
            ],
          ),
        ),
      ],
    );
  }
}
