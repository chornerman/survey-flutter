import 'package:flutter/material.dart';
import 'package:survey/gen/assets.gen.dart';
import 'package:survey/gen/colors.gen.dart';
import 'package:survey/model/survey_model.dart';
import 'package:survey/resource/dimens.dart';

class HomeSurveysItemWidget extends StatelessWidget {
  final SurveyModel survey;
  final VoidCallback onNextButtonPressed;

  const HomeSurveysItemWidget({
    Key? key,
    required this.survey,
    required this.onNextButtonPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: Image.network(survey.coverImageUrl).image,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.5),
            BlendMode.darken,
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Dimens.space20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: const SizedBox.shrink(),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: Dimens.space4),
              child: Text(
                survey.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Text(
                    survey.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        ?.copyWith(color: ColorName.whiteAlpha70),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: Dimens.space20),
                  child: ElevatedButton(
                    child: Assets.images.icArrowRight.svg(),
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      shape: const CircleBorder(),
                      backgroundColor: Colors.white,
                      minimumSize: Size(Dimens.space56, Dimens.space56),
                    ),
                    onPressed: onNextButtonPressed,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
