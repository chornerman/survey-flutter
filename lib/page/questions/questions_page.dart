import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:survey/di/di.dart';
import 'package:survey/gen/assets.gen.dart';
import 'package:survey/gen/colors.gen.dart';
import 'package:survey/model/question_model.dart';
import 'package:survey/model/survey_detail_model.dart';
import 'package:survey/navigator.dart';
import 'package:survey/page/questions/questions_state.dart';
import 'package:survey/page/questions/questions_view_model.dart';
import 'package:survey/page/questions/widget/questions_page_view_widget.dart';
import 'package:survey/resource/dimens.dart';

final questionsViewModelProvider =
    StateNotifierProvider.autoDispose<QuestionsViewModel, QuestionsState>(
        (ref) {
  return QuestionsViewModel();
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
      final surveyDetail =
          ModalRoute.of(context)!.settings.arguments as SurveyDetailModel;
      ref.read(questionsViewModelProvider.notifier).getQuestions(surveyDetail);
    });
  }

  @override
  Widget build(BuildContext context) {
    final questions = ref.watch(_questionsStreamProvider).value ?? [];
    return ref.watch(questionsViewModelProvider).when(
        init: () => const SizedBox(),
        success: () => _buildQuestionPage(questions));
  }

  Widget _buildQuestionPage(List<QuestionModel> questions) {
    return WillPopScope(
      onWillPop: () async {
        showQuitSurveyDialog();
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            QuestionsPageViewWidget(questions: questions),
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
          ],
        ),
      ),
    );
  }

  void showQuitSurveyDialog() {
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
}
