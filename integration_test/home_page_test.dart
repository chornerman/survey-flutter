import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:intl/intl.dart';
import 'package:survey/navigator.dart';
import 'package:survey/page/home/home_page.dart';
import 'package:survey/page/home/home_page_key.dart';
import 'package:survey/page/home/home_view_model.dart';
import 'package:survey/page/surveydetail/survey_detail_page.dart';

import 'fake_service/fake_data.dart';
import 'fake_service/fake_survey_service.dart';
import 'fake_service/fake_user_service.dart';
import 'utils/file_utils.dart';
import 'utils/integration_test_utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('HomePageTest', () {
    late Finder huaHome;
    late Finder nbHomeTakeSurvey;

    late Map<String, dynamic> surveysJson;
    late Map<String, dynamic> userJson;

    setUpAll(() async {
      await IntegrationTestUtils.prepareTestEnvVariables();
    });

    setUp(() async {
      huaHome = find.byKey(HomePageKey.huaHome);
      nbHomeTakeSurvey = find.byKey(HomePageKey.nbHomeTakeSurvey);

      surveysJson = await FileUtils.loadFile('mock_response/surveys.json');
      userJson = await FileUtils.loadFile('mock_response/user.json');
    });

    testWidgets('When starting, it shows date text correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(IntegrationTestUtils.prepareTestApp(HomePage()));

      await tester.pumpAndSettle();
      expect(
          find.text(DateFormat(homeCurrentDatePattern)
              .format(clock.now())
              .toUpperCase()),
          findsOneWidget);
      expect(
          find.byWidgetPredicate((widget) =>
              widget is Text &&
              (widget.data == 'Today' || widget.data == 'วันนี้')),
          findsOneWidget);
    });

    testWidgets('When loading surveys successfully, it shows surveys correctly',
        (WidgetTester tester) async {
      FakeData.addSuccessResponse(getSurveysKey, surveysJson);
      FakeData.addSuccessResponse(getUserKey, userJson);
      await tester.pumpWidget(IntegrationTestUtils.prepareTestApp(HomePage()));

      await tester.pumpAndSettle();
      final firstSurvey = surveysJson['data'][0];
      expect(find.text(firstSurvey['title']), findsOneWidget);
      expect(find.text(firstSurvey['description']), findsOneWidget);

      // Swipe to next page
      await tester.flingFrom(Offset(100, 300), Offset(-100, 0), 500);

      await tester.pumpAndSettle();
      final secondSurvey = surveysJson['data'][1];
      expect(find.text(secondSurvey['title']), findsOneWidget);
      expect(find.text(secondSurvey['description']), findsOneWidget);
    });

    testWidgets(
        'When loading surveys failed, it shows the corresponding error message',
        (WidgetTester tester) async {
      FakeData.addErrorResponse(getSurveysKey);
      FakeData.addSuccessResponse(getUserKey, userJson);
      await tester.pumpWidget(IntegrationTestUtils.prepareTestApp(HomePage()));

      await tester.pumpAndSettle();
      expect(find.text('Bad request'), findsOneWidget);
    });

    testWidgets(
        'When getting user failed, it shows the corresponding error message',
        (WidgetTester tester) async {
      FakeData.addSuccessResponse(getSurveysKey, surveysJson);
      FakeData.addErrorResponse(getUserKey);
      await tester.pumpWidget(IntegrationTestUtils.prepareTestApp(HomePage()));

      await tester.pumpAndSettle();
      expect(find.text('Bad request'), findsOneWidget);
    });

    testWidgets(
        'When tapping on the user avatar, it opens the drawer with correct user name',
        (WidgetTester tester) async {
      FakeData.addSuccessResponse(getUserKey, userJson);
      await tester.pumpWidget(IntegrationTestUtils.prepareTestApp(HomePage()));

      await tester.pumpAndSettle();
      await tester.tap(huaHome);

      await tester.pumpAndSettle();
      expect(find.text(userJson['data']['name']), findsOneWidget);
    });

    testWidgets(
        'When tapping on Take Survey button, it navigates to Survey Detail page',
        (WidgetTester tester) async {
      FakeData.addSuccessResponse(getSurveysKey, surveysJson);
      FakeData.addSuccessResponse(getUserKey, userJson);
      await tester.pumpWidget(IntegrationTestUtils.prepareTestApp(
        HomePage(),
        routes: <String, WidgetBuilder>{
          routeSurveyDetail: (BuildContext context) => const SurveyDetailPage(),
        },
      ));

      await tester.pumpAndSettle();
      await tester.tap(nbHomeTakeSurvey);

      await tester.pumpAndSettle();
      expect(find.byType(SurveyDetailPage), findsOneWidget);
    });
  });
}
