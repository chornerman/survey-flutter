import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:survey/navigator.dart';
import 'package:survey/page/home/home_page.dart';
import 'package:survey/page/home/home_page_key.dart';
import 'package:survey/page/questions/questions_page.dart';
import 'package:survey/page/questions/questions_page_key.dart';
import 'package:survey/page/questions/widget/answer_widget.dart';
import 'package:survey/page/surveycompletion/survey_completion_page.dart';
import 'package:survey/page/surveydetail/survey_detail_page.dart';
import 'package:survey/page/surveydetail/survey_detail_page_key.dart';

import 'fake_service/fake_data.dart';
import 'fake_service/fake_survey_service.dart';
import 'fake_service/fake_user_service.dart';
import 'utils/file_utils.dart';
import 'utils/integration_test_utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('TakeSurveyFlowTest', () {
    late Finder ibQuestionsQuitSurvey;
    late Finder nbQuestionsNext;
    late Finder rbQuestionsSubmitSurvey;
    late Finder tbQuestionsQuitSurveyDialogPositive;
    late Finder tbQuestionsQuitSurveyDialogNegative;
    late Finder rbSurveyDetailStartSurvey;
    late Finder nbHomeTakeSurvey;
    late Widget homeWidget;

    late Map<String, dynamic> surveyDetailJson;
    late Map<String, dynamic> surveysJson;
    late Map<String, dynamic> userJson;

    setUpAll(() async {
      await IntegrationTestUtils.prepareTestEnvVariables();
    });

    setUp(() async {
      ibQuestionsQuitSurvey =
          find.byKey(QuestionsPageKey.ibQuestionsQuitSurvey);
      nbQuestionsNext = find.byKey(QuestionsPageKey.nbQuestionsNext);
      rbQuestionsSubmitSurvey =
          find.byKey(QuestionsPageKey.rbQuestionsSubmitSurvey);
      tbQuestionsQuitSurveyDialogPositive =
          find.byKey(QuestionsPageKey.tbQuestionsQuitSurveyDialogPositive);
      tbQuestionsQuitSurveyDialogNegative =
          find.byKey(QuestionsPageKey.tbQuestionsQuitSurveyDialogNegative);
      rbSurveyDetailStartSurvey =
          find.byKey(SurveyDetailPageKey.rbSurveyDetailStartSurvey);
      nbHomeTakeSurvey = find.byKey(HomePageKey.nbHomeTakeSurvey);

      homeWidget = IntegrationTestUtils.prepareTestApp(
        HomePage(),
        routes: <String, WidgetBuilder>{
          routeSurveyDetail: (BuildContext context) => const SurveyDetailPage(),
          routeQuestions: (BuildContext context) => const QuestionsPage(),
          routeSurveyCompletion: (BuildContext context) =>
              const SurveyCompletionPage(),
        },
      );

      surveyDetailJson =
          await FileUtils.loadFile('mock_response/survey_detail.json');
      surveysJson = await FileUtils.loadFile('mock_response/surveys.json');
      userJson = await FileUtils.loadFile('mock_response/user.json');

      FakeData.addSuccessResponse(getSurveyDetailKey, surveyDetailJson);
      FakeData.addSuccessResponse(getSurveysKey, surveysJson);
      FakeData.addSuccessResponse(getUserKey, userJson);
    });

    testWidgets('When starting, it shows questions correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(homeWidget);

      await tester.pumpAndSettle();
      await tester.tap(nbHomeTakeSurvey);

      await tester.pumpAndSettle();
      await tester.tap(rbSurveyDetailStartSurvey);

      await tester.pumpAndSettle();
      // Skip intro question
      final firstQuestion = surveyDetailJson['data']['questions'][1];
      expect(find.text(firstQuestion['text']), findsOneWidget);
    });

    testWidgets(
        'When answering all questions and submitting survey successfully, it navigates to Survey Completion page then automatically returns to Home page',
        (WidgetTester tester) async {
      FakeData.addSuccessResponse(submitSurveyKey, {});
      await tester.pumpWidget(homeWidget);

      await tester.pumpAndSettle();
      await tester.tap(nbHomeTakeSurvey);

      await tester.pumpAndSettle();
      await tester.tap(rbSurveyDetailStartSurvey);

      await _answerAllQuestions(
          tester, nbQuestionsNext, rbQuestionsSubmitSurvey);

      await tester.pumpAndSettle();
      expect(find.byType(SurveyCompletionPage), findsOneWidget);
      final outroQuestion = surveyDetailJson['data']['questions'][12];
      expect(find.text(outroQuestion['text']), findsOneWidget);

      // Wait for the Survey Completion page to close itself
      await tester.pump(Duration(milliseconds: 2500));
      expect(find.byType(HomePage), findsOneWidget);
    });

    testWidgets(
        'When answering all questions and submitting survey failed, it shows the corresponding error message',
        (WidgetTester tester) async {
      FakeData.addErrorResponse(submitSurveyKey);
      await tester.pumpWidget(homeWidget);

      await tester.pumpAndSettle();
      await tester.tap(nbHomeTakeSurvey);

      await tester.pumpAndSettle();
      await tester.tap(rbSurveyDetailStartSurvey);

      await _answerAllQuestions(
          tester, nbQuestionsNext, rbQuestionsSubmitSurvey);

      await tester.pumpAndSettle();
      expect(find.text('Bad request'), findsOneWidget);
    });

    testWidgets(
        'When tapping on the Quit Survey dialog positive button, it navigates back to the Home page',
        (WidgetTester tester) async {
      await tester.pumpWidget(homeWidget);

      await tester.pumpAndSettle();
      await tester.tap(nbHomeTakeSurvey);

      await tester.pumpAndSettle();
      await tester.tap(rbSurveyDetailStartSurvey);

      await tester.pumpAndSettle();
      await tester.tap(ibQuestionsQuitSurvey);

      await tester.pumpAndSettle();
      await tester.tap(tbQuestionsQuitSurveyDialogPositive);

      await tester.pumpAndSettle();
      expect(find.byType(HomePage), findsOneWidget);
    });

    testWidgets(
        'When tapping on the Quit Survey dialog negative button, it dismisses the Quit Survey dialog',
        (WidgetTester tester) async {
      await tester.pumpWidget(homeWidget);

      await tester.pumpAndSettle();
      await tester.tap(nbHomeTakeSurvey);

      await tester.pumpAndSettle();
      await tester.tap(rbSurveyDetailStartSurvey);

      await tester.pumpAndSettle();
      await tester.tap(ibQuestionsQuitSurvey);

      await tester.pumpAndSettle();
      await tester.tap(tbQuestionsQuitSurveyDialogNegative);

      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsNothing);
    });
  });
}

Future<void> _answerAllQuestions(
  WidgetTester tester,
  Finder nextQuestionButton,
  Finder submitSurveyButton,
) async {
  // Skip intro question

  // 2nd question: Icons rating bar
  await tester.pumpAndSettle();
  await tester.tapAt(tester.getCenter(find.byType(AnswerWidget)));
  await tester.pumpAndSettle();
  await tester.tap(nextQuestionButton);

  // 3rd question: Icons rating bar
  await tester.pumpAndSettle();
  await tester.tapAt(tester.getCenter(find.byType(AnswerWidget)));
  await tester.pumpAndSettle();
  await tester.tap(nextQuestionButton);

  // 4th question: Icons rating bar
  await tester.pumpAndSettle();
  await tester.tapAt(tester.getCenter(find.byType(AnswerWidget)));
  await tester.pumpAndSettle();
  await tester.tap(nextQuestionButton);

  // 5th question: Icons rating bar
  await tester.pumpAndSettle();
  await tester.tapAt(tester.getCenter(find.byType(AnswerWidget)));
  await tester.pumpAndSettle();
  await tester.tap(nextQuestionButton);

  // 6th question: Icons rating bar
  await tester.pumpAndSettle();
  await tester.tapAt(tester.getCenter(find.byType(AnswerWidget)));
  await tester.pumpAndSettle();
  await tester.tap(nextQuestionButton);

  // 7th question: Smiley rating bar
  await tester.pumpAndSettle();
  await tester.tap(nextQuestionButton);

  // 8th question: Multiple choices
  await tester.pumpAndSettle();
  await tester.tap(nextQuestionButton);

  // 9th question: Number rating bar
  await tester.pumpAndSettle();
  await tester.tap(find.text('8'));
  await tester.pumpAndSettle();
  await tester.tap(nextQuestionButton);

  // 10th question: Text area
  await tester.pumpAndSettle();
  await tester.enterText(find.byType(TextFormField), 'textArea');
  await tester.pump(Duration(milliseconds: 100));
  await tester.tap(nextQuestionButton);

  // 11th question: Text fields
  await tester.pumpAndSettle();
  await tester.enterText(find.byType(TextFormField).at(0), 'textField1');
  await tester.pump(Duration(milliseconds: 100));
  await tester.enterText(find.byType(TextFormField).at(1), 'textField2');
  await tester.pump(Duration(milliseconds: 100));
  await tester.enterText(find.byType(TextFormField).at(2), 'textField3');

  // 12th question: Dropdown
  await tester.pump(Duration(milliseconds: 100));
  await tester.tap(nextQuestionButton);

  // Skip outro question

  // Submit survey
  await tester.pumpAndSettle();
  await tester.tap(submitSurveyButton);
}
