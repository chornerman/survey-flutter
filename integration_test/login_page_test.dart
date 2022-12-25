import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:survey/navigator.dart';
import 'package:survey/page/home/home_page.dart';
import 'package:survey/page/login/login_page.dart';
import 'package:survey/page/login/login_page_key.dart';
import 'package:survey/page/resetpassword/reset_password_page.dart';

import 'fake_service/fake_auth_service.dart';
import 'fake_service/fake_data.dart';
import 'utils/file_utils.dart';
import 'utils/integration_test_utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('LoginPageTest', () {
    late Finder sltiLoginEmail;
    late Finder sltiLoginPassword;
    late Finder rbLogin;
    late Finder tbLoginForgotPassword;

    setUpAll(() async {
      await IntegrationTestUtils.prepareTestEnvVariables();
    });

    setUp(() async {
      sltiLoginEmail = find.byKey(LoginPageKey.sltiLoginEmail);
      sltiLoginPassword = find.byKey(LoginPageKey.sltiLoginPassword);
      rbLogin = find.byKey(LoginPageKey.rbLogin);
      tbLoginForgotPassword = find.byKey(LoginPageKey.tbLoginForgotPassword);
    });

    testWidgets('When starting, it shows the Login page correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(IntegrationTestUtils.prepareTestApp(LoginPage()));

      await tester.pumpAndSettle();
      expect(sltiLoginEmail, findsOneWidget);
      expect(sltiLoginPassword, findsOneWidget);
      expect(rbLogin, findsOneWidget);
    });

    testWidgets('When logging in successfully, it navigates to Home page',
        (WidgetTester tester) async {
      final tokenJson = await FileUtils.loadFile('mock_response/token.json');
      FakeData.addSuccessResponse(loginKey, tokenJson);
      await tester.pumpWidget(IntegrationTestUtils.prepareTestApp(
        LoginPage(),
        routes: <String, WidgetBuilder>{
          routeHome: (BuildContext context) => const HomePage()
        },
      ));

      await tester.pumpAndSettle();
      await tester.enterText(sltiLoginEmail, 'chorny@berlento.com');
      await tester.enterText(sltiLoginPassword, '12345678');
      await tester.tap(rbLogin);

      await tester.pumpAndSettle();
      expect(find.byType(HomePage), findsOneWidget);
    });

    testWidgets(
        'When logging in with invalid email or password, it shows the corresponding error message',
        (WidgetTester tester) async {
      await tester.pumpWidget(IntegrationTestUtils.prepareTestApp(LoginPage()));

      await tester.pumpAndSettle();
      await tester.enterText(sltiLoginEmail, 'chorny');
      await tester.enterText(sltiLoginPassword, '12345678');
      await tester.tap(rbLogin);

      await tester.pumpAndSettle();
      expect(
          find.byWidgetPredicate((widget) =>
              widget is Text &&
              (widget.data == 'Invalid email or password' ||
                  widget.data == 'อีเมลล์หรือรหัสผ่านไม่ถูกต้อง')),
          findsOneWidget);
    });

    testWidgets(
        'When logging in fails, it shows the corresponding error message',
        (WidgetTester tester) async {
      FakeData.addErrorResponse(loginKey);
      await tester.pumpWidget(IntegrationTestUtils.prepareTestApp(LoginPage()));

      await tester.pumpAndSettle();
      await tester.enterText(sltiLoginEmail, 'chorny@berlento.com');
      await tester.enterText(sltiLoginPassword, '12345678');
      await tester.tap(rbLogin);

      await tester.pumpAndSettle();
      expect(find.text('Bad request'), findsOneWidget);
    });

    testWidgets(
        'When tapping on forgot password, it navigates to Reset Password page',
        (WidgetTester tester) async {
      await tester.pumpWidget(IntegrationTestUtils.prepareTestApp(
        LoginPage(),
        routes: <String, WidgetBuilder>{
          routeResetPassword: (BuildContext context) =>
              const ResetPasswordPage()
        },
      ));

      await tester.pumpAndSettle();
      await tester.tap(tbLoginForgotPassword);

      await tester.pumpAndSettle();
      expect(find.byType(ResetPasswordPage), findsOneWidget);
    });
  });
}
