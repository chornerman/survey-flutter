import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:survey/api/response/question_response.dart';
import 'package:survey/constants.dart';
import 'package:survey/di/di.dart';
import 'package:survey/model/survey_detail_model.dart';
import 'package:survey/model/survey_model.dart';
import 'package:survey/navigator.dart';
import 'package:survey/page/surveydetail/survey_detail_state.dart';
import 'package:survey/page/surveydetail/survey_detail_view_model.dart';
import 'package:survey/resource/dimens.dart';
import 'package:survey/usecase/get_survey_detail_use_case.dart';
import 'package:survey/widget/app_bar_back_button_widget.dart';
import 'package:survey/widget/dimmed_background_widget.dart';
import 'package:survey/widget/loading_indicator_widget.dart';
import 'package:survey/widget/rounded_button_widget.dart';

final surveyDetailViewModelProvider =
    StateNotifierProvider.autoDispose<SurveyDetailViewModel, SurveyDetailState>(
        (ref) {
  return SurveyDetailViewModel(getIt.get<GetSurveyDetailUseCase>());
});

final _surveyStreamProvider = StreamProvider.autoDispose<SurveyModel>(
    (ref) => ref.watch(surveyDetailViewModelProvider.notifier).survey);

final _surveyDetailStreamProvider =
    StreamProvider.autoDispose<SurveyDetailModel>((ref) =>
        ref.watch(surveyDetailViewModelProvider.notifier).surveyDetail);

class SurveyDetailPage extends ConsumerStatefulWidget {
  const SurveyDetailPage({super.key});

  @override
  _SurveyDetailPageState createState() => _SurveyDetailPageState();
}

class _SurveyDetailPageState extends ConsumerState<SurveyDetailPage> {
  final _appNavigator = getIt.get<AppNavigator>();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      final survey = ModalRoute.of(context)!.settings.arguments as SurveyModel;
      ref.read(surveyDetailViewModelProvider.notifier).getSurveyDetail(survey);
    });
  }

  @override
  Widget build(BuildContext context) {
    final survey = ref.watch(_surveyStreamProvider).value;
    final surveyDetail = ref.watch(_surveyDetailStreamProvider).value;

    ref.listen<SurveyDetailState>(surveyDetailViewModelProvider, (
      SurveyDetailState? previousState,
      SurveyDetailState newState,
    ) {
      newState.maybeWhen(
        retrySuccess: (surveyDetail) => _navigateToQuestions(surveyDetail),
        orElse: () {},
      );
    });

    return ref.watch(surveyDetailViewModelProvider).when(
          init: () => _buildSurveyDetailPage(survey),
          loading: () =>
              _buildSurveyDetailPage(survey, shouldShowLoading: true),
          success: () =>
              _buildSurveyDetailPage(survey, surveyDetail: surveyDetail),
          error: (errorMessage) {
            _showError(errorMessage);
            return _buildSurveyDetailPage(survey);
          },
          retrySuccess: (_) => const SizedBox(),
        );
  }

  Widget _buildSurveyDetailPage(
    SurveyModel? survey, {
    SurveyDetailModel? surveyDetail = null,
    bool shouldShowLoading = false,
  }) {
    final introQuestion = surveyDetail?.questions.firstWhereOrNull(
      (question) => question.displayType == DisplayType.intro,
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          DimmedBackgroundWidget(
            background: Image.network(
              introQuestion?.coverImageUrl ?? survey?.coverImageUrl ?? '',
            ).image,
            opacity: introQuestion?.coverImageOpacity ??
                Constants.defaultDimmedBackgroundOpacity,
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
                            survey?.title ?? '',
                            style: Theme.of(context).textTheme.headline5,
                          ),
                          const SizedBox(height: Dimens.space16),
                          Text(
                            introQuestion?.text ?? survey?.description ?? '',
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
                        if (surveyDetail != null) {
                          _navigateToQuestions(surveyDetail);
                        } else {
                          if (survey != null)
                            ref
                                .read(surveyDetailViewModelProvider.notifier)
                                .getSurveyDetail(survey, isRetry: true);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (shouldShowLoading)
            LoadingIndicatorWidget(shouldIgnoreOtherGestures: true),
        ],
      ),
    );
  }

  void _navigateToQuestions(SurveyDetailModel surveyDetail) =>
      _appNavigator.navigateToQuestions(context, surveyDetail);

  void _showError(String errorMessage) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: const Duration(seconds: Constants.snackBarDurationInSecond),
        content: Text(errorMessage),
      ));
    });
  }
}
