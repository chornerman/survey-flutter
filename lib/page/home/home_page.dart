import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:survey/model/survey_model.dart';
import 'package:survey/page/home/home_state.dart';
import 'package:survey/page/home/home_view_model.dart';
import 'package:survey/page/home/widget/home_header_widget.dart';
import 'package:survey/page/home/widget/home_surveys_item_widget.dart';

final homeViewModelProvider =
    StateNotifierProvider.autoDispose<HomeViewModel, HomeState>((ref) {
  return HomeViewModel();
});

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // TODO: Integrate with real API
        HomeSurveysItemWidget(
          survey: SurveyModel(
              id: "id",
              title:
                  "Career training and development Working from home Check-In",
              description:
                  "We would like to know what are your goals and skills you wanted. Building a workplace culture that prioritizes belonging and inclusion.",
              coverImageUrl:
                  "https://dhdbhh0jsld0o.cloudfront.net/m/1ea51560991bcb7d00d0_l"),
          onNextButtonPressed: () => {},
        ),
        SafeArea(
          child: HomeHeaderWidget(
              currentDate:
                  ref.read(homeViewModelProvider.notifier).getCurrentDate()),
        ),
      ],
    );
  }
}
