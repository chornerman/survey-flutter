import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:survey/navigator.dart';
import 'package:survey/page/home/home_page.dart';
import 'package:survey/page/home/home_page_key.dart';
import 'package:survey/page/questions/questions_page.dart';
import 'package:survey/page/surveydetail/survey_detail_page.dart';
import 'package:survey/page/surveydetail/survey_detail_page_key.dart';

import 'fake_service/fake_data.dart';
import 'fake_service/fake_survey_service.dart';
import 'fake_service/fake_user_service.dart';
import 'utils/file_utils.dart';
import 'utils/integration_test_utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('SurveyDetailPageTest', () {
    late Finder abbbSurveyDetail;
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
      abbbSurveyDetail = find.byKey(SurveyDetailPageKey.abbbSurveyDetail);
      rbSurveyDetailStartSurvey =
          find.byKey(SurveyDetailPageKey.rbSurveyDetailStartSurvey);
      nbHomeTakeSurvey = find.byKey(HomePageKey.nbHomeTakeSurvey);

      homeWidget = IntegrationTestUtils.prepareTestApp(
        HomePage(),
        routes: <String, WidgetBuilder>{
          routeSurveyDetail: (BuildContext context) => const SurveyDetailPage(),
          routeQuestions: (BuildContext context) => const QuestionsPage(),
        },
      );

      surveyDetailJson =
          await FileUtils.loadFile('mock_response/survey_detail.json');
      surveysJson = await FileUtils.loadFile('mock_response/surveys.json');
      userJson = await FileUtils.loadFile('mock_response/user.json');

      FakeData.addSuccessResponse(getSurveysKey, surveysJson);
      FakeData.addSuccessResponse(getUserKey, userJson);
    });

    testWidgets(
        'When getting survey detail successfully, it shows survey detail correctly',
        (WidgetTester tester) async {
      FakeData.addSuccessResponse(getSurveyDetailKey, surveyDetailJson);
      await tester.pumpWidget(homeWidget);

      await tester.pumpAndSettle();
      await tester.tap(nbHomeTakeSurvey);

      await tester.pumpAndSettle();
      expect(find.text(surveysJson['data'][0]['title']), findsOneWidget);
      expect(find.text(surveyDetailJson['data']['questions'][0]['text']),
          findsOneWidget);
    });

    testWidgets(
        'When getting survey detail failed, it shows the corresponding error message',
        (WidgetTester tester) async {
      FakeData.addErrorResponse(getSurveyDetailKey);
      await tester.pumpWidget(homeWidget);

      await tester.pumpAndSettle();
      await tester.tap(nbHomeTakeSurvey);

      await tester.pumpAndSettle();
      expect(find.text('Bad request'), findsOneWidget);
    });

    testWidgets(
        'When tapping on Start Survey button, it navigates to Questions page',
        (WidgetTester tester) async {
      FakeData.addSuccessResponse(getSurveyDetailKey, surveyDetailJson);
      await tester.pumpWidget(homeWidget);

      await tester.pumpAndSettle();
      await tester.tap(nbHomeTakeSurvey);

      await tester.pumpAndSettle();
      await tester.tap(rbSurveyDetailStartSurvey);

      await tester.pumpAndSettle();
      expect(find.byType(QuestionsPage), findsOneWidget);
    });

    testWidgets(
        'When tapping on the app bar back button, it navigates back to the Home page',
        (WidgetTester tester) async {
      await tester.pumpWidget(homeWidget);

      await tester.pumpAndSettle();
      await tester.tap(nbHomeTakeSurvey);

      await tester.pumpAndSettle();
      await tester.tap(abbbSurveyDetail);

      await tester.pumpAndSettle();
      expect(find.byType(HomePage), findsOneWidget);
    });
  });
}
