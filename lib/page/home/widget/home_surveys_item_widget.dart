import 'package:flutter/material.dart';
import 'package:survey/model/survey_model.dart';
import 'package:survey/page/home/home_page_key.dart';
import 'package:survey/resource/dimens.dart';
import 'package:survey/widget/dimmed_background_widget.dart';
import 'package:survey/widget/next_button_widget.dart';

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
    return Stack(
      children: [
        DimmedBackgroundWidget(
          background: Image.network(survey.coverImageUrl).image,
        ),
        Padding(
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
                  style: Theme.of(context).textTheme.headline6,
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
                          ?.copyWith(color: Colors.white70),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: Dimens.space20),
                    child: NextButtonWidget(
                      key: HomePageKey.nbHomeTakeSurvey,
                      onPressed: onNextButtonPressed,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
