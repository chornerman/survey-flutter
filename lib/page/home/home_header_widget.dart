import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:survey/resource/dimens.dart';

class HomeHeaderWidget extends StatelessWidget {
  final String currentDate;

  const HomeHeaderWidget({
    Key? key,
    required this.currentDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
      ],
    );
  }
}
