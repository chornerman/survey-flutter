import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:survey/resource/dimens.dart';
import 'package:survey/widget/app_bar_back_button_widget.dart';
import 'package:survey/widget/dimmed_background_widget.dart';
import 'package:survey/widget/rounded_button_widget.dart';

class SurveyDetailPage extends StatelessWidget {
  const SurveyDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Retrieve surveyId
    // final surveyId = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          DimmedBackgroundWidget(
            // TODO: Display survey's background image
            background: Image.network(
                    'https://upload.wikimedia.org/wikipedia/en/2/27/Bliss_%28Windows_XP%29.png')
                .image,
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(
                top: Dimens.space24,
                bottom: Dimens.space20,
                left: Dimens.space20,
                right: Dimens.space20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppBarBackButtonWidget(),
                  const SizedBox(height: Dimens.space30),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            // TODO: Display survey's title
                            'Title',
                            style: Theme.of(context).textTheme.headline5,
                          ),
                          const SizedBox(height: Dimens.space16),
                          Text(
                            // TODO: Display survey's description
                            'Description',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                ?.copyWith(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: Dimens.space20),
                  Align(
                    alignment: Alignment.centerRight,
                    child: RoundedButtonWidget(
                      buttonText:
                          AppLocalizations.of(context)!.surveyDetailStartSurvey,
                      onPressed: () {
                        // TODO: Navigate to Questions screen
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
