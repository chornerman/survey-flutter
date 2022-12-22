import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:survey/constants.dart';
import 'package:survey/di/di.dart';
import 'package:survey/gen/assets.gen.dart';
import 'package:survey/gen/colors.gen.dart';
import 'package:survey/model/question_model.dart';
import 'package:survey/navigator.dart';
import 'package:survey/page/questions/questions_state.dart';
import 'package:survey/page/questions/questions_view_model.dart';
import 'package:survey/page/questions/uimodel/questions_ui_model.dart';
import 'package:survey/page/questions/widget/questions_page_view_widget.dart';
import 'package:survey/resource/dimens.dart';
import 'package:survey/usecase/submit_survey_use_case.dart';
import 'package:survey/widget/loading_indicator_widget.dart';

final questionsViewModelProvider =
    StateNotifierProvider.autoDispose<QuestionsViewModel, QuestionsState>(
        (ref) {
  return QuestionsViewModel(getIt.get<SubmitSurveyUseCase>());
});

final _questionsStreamProvider =
    StreamProvider.autoDispose<List<QuestionModel>>(
        (ref) => ref.watch(questionsViewModelProvider.notifier).questions);

class QuestionsPage extends ConsumerStatefulWidget {
  const QuestionsPage({super.key});

  @override
  _QuestionsPageState createState() => _QuestionsPageState();
}

class _QuestionsPageState extends ConsumerState<QuestionsPage> {
  final _appNavigator = getIt.get<AppNavigator>();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      final uiModel =
          ModalRoute.of(context)!.settings.arguments as QuestionsUiModel;
      ref.read(questionsViewModelProvider.notifier).getQuestions(uiModel);
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<QuestionsState>(questionsViewModelProvider, (
      QuestionsState? previousState,
      QuestionsState newState,
    ) {
      newState.maybeWhen(
        submitSurveySuccess: (outroMessage) => _appNavigator
            .navigateToCompletionAndQuitCurrentPage(context, outroMessage),
        orElse: () {},
      );
    });

    final questions = ref.watch(_questionsStreamProvider).value ?? [];
    return ref.watch(questionsViewModelProvider).when(
          init: () => const SizedBox(),
          loading: () => _buildQuestionPage(questions, shouldShowLoading: true),
          initSuccess: () => _buildQuestionPage(questions),
          submitSurveySuccess: (outroMessage) => const SizedBox(),
          error: (errorMessage) {
            _showError(errorMessage);
            return _buildQuestionPage(questions);
          },
        );
  }

  Widget _buildQuestionPage(
    List<QuestionModel> questions, {
    bool shouldShowLoading = false,
  }) {
    return WillPopScope(
      onWillPop: () async {
        showQuitSurveyDialog();
        return true;
      },
      child: Scaffold(
        body: Stack(
          children: [
            QuestionsPageViewWidget(
              questions: questions,
              submitSurvey: () {
                ref.read(questionsViewModelProvider.notifier).submitSurvey();
              },
            ),
            SafeArea(
              child: Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: Dimens.space20,
                    right: Dimens.space20,
                  ),
                  child: IconButton(
                    icon: Assets.images.icClose.svg(),
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    onPressed: () => showQuitSurveyDialog(),
                  ),
                ),
              ),
            ),
            if (shouldShowLoading)
              LoadingIndicatorWidget(shouldIgnoreOtherGestures: true),
          ],
        ),
      ),
    );
  }

  void showQuitSurveyDialog() {
    _hideKeyboard();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ColorName.eerieBlack90,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(Dimens.questionsQuitSurveyDialogBorderRadius),
          ),
        ),
        title: Text(
          AppLocalizations.of(context)!.questionsQuitSurveyDialogTitle,
          style: Theme.of(context)
              .textTheme
              .bodyText1
              ?.copyWith(fontWeight: FontWeight.w800),
        ),
        content: Text(
          AppLocalizations.of(context)!.questionsQuitSurveyDialogDescription,
          style: Theme.of(context)
              .textTheme
              .subtitle1
              ?.copyWith(fontWeight: FontWeight.w400),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              // Close the dialog
              _appNavigator.navigateBack(context);
              // Navigate back to the Home page
              _appNavigator.navigateBack(context);
            },
            child: Text(
              AppLocalizations.of(context)!
                  .questionsQuitSurveyDialogPositiveButtonText,
              style: Theme.of(context).textTheme.button?.copyWith(
                    fontWeight: FontWeight.w400,
                    color: Colors.blueAccent,
                  ),
            ),
          ),
          TextButton(
            onPressed: () => _appNavigator.navigateBack(context),
            child: Text(
              AppLocalizations.of(context)!
                  .questionsQuitSurveyDialogNegativeButtonText,
              style: Theme.of(context)
                  .textTheme
                  .button
                  ?.copyWith(color: Colors.blueAccent),
            ),
          ),
        ],
      ),
    );
  }

  void _showError(String errorMessage) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: const Duration(seconds: Constants.snackBarDurationInSecond),
        content: Text(errorMessage),
      ));
    });
  }

  void _hideKeyboard() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }
}
