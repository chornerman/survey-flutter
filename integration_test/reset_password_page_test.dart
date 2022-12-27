import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:survey/navigator.dart';
import 'package:survey/page/login/login_page.dart';
import 'package:survey/page/login/login_page_key.dart';
import 'package:survey/page/resetpassword/reset_password_page.dart';
import 'package:survey/page/resetpassword/reset_password_page_key.dart';

import 'fake_service/fake_auth_service.dart';
import 'fake_service/fake_data.dart';
import 'utils/integration_test_utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('ResetPasswordPageTest', () {
    late Finder abbbResetPassword;
    late Finder sltiResetPasswordEmail;
    late Finder rbResetPassword;
    late Finder tbLoginForgotPassword;

    setUpAll(() async {
      await IntegrationTestUtils.prepareTestEnvVariables();
    });

    setUp(() async {
      abbbResetPassword = find.byKey(ResetPasswordPageKey.abbbResetPassword);
      sltiResetPasswordEmail =
          find.byKey(ResetPasswordPageKey.sltiResetPasswordEmail);
      rbResetPassword = find.byKey(ResetPasswordPageKey.rbResetPassword);
      tbLoginForgotPassword = find.byKey(LoginPageKey.tbLoginForgotPassword);
    });

    testWidgets('When starting, it shows the Reset Password page correctly',
        (WidgetTester tester) async {
      await tester
          .pumpWidget(IntegrationTestUtils.prepareTestApp(ResetPasswordPage()));

      await tester.pumpAndSettle();
      expect(abbbResetPassword, findsOneWidget);
      expect(sltiResetPasswordEmail, findsOneWidget);
      expect(rbResetPassword, findsOneWidget);
    });

    testWidgets(
        'When resetting password successfully, it shows the success Flushbar',
        (WidgetTester tester) async {
      FakeData.addSuccessResponse(resetPasswordKey, {});
      await tester
          .pumpWidget(IntegrationTestUtils.prepareTestApp(ResetPasswordPage()));

      await tester.pumpAndSettle();
      await tester.enterText(sltiResetPasswordEmail, 'chorny@berlento.com');
      await tester.tap(rbResetPassword);

      // Wait for Flushbar animation
      await tester.pump(Duration(milliseconds: 500));
      expect(
          find.byWidgetPredicate((widget) =>
              widget is Flushbar &&
              ((widget.titleText as Text).data == 'Check your email.' ||
                  (widget.titleText as Text).data == 'ตรวจสอบอีเมลล์ของคุณ')),
          findsOneWidget);
    });

    testWidgets(
        'When resetting password with invalid email, it shows the corresponding error message',
        (WidgetTester tester) async {
      await tester
          .pumpWidget(IntegrationTestUtils.prepareTestApp(ResetPasswordPage()));

      await tester.pumpAndSettle();
      await tester.enterText(sltiResetPasswordEmail, 'chorny');
      await tester.tap(rbResetPassword);

      await tester.pumpAndSettle();
      expect(
          find.byWidgetPredicate((widget) =>
              widget is Text &&
              (widget.data == 'Invalid email' ||
                  widget.data == 'อีเมลล์ไม่ถูกต้อง')),
          findsOneWidget);
    });

    testWidgets(
        'When resetting password failed, it shows the corresponding error message',
        (WidgetTester tester) async {
      FakeData.addErrorResponse(resetPasswordKey);
      await tester
          .pumpWidget(IntegrationTestUtils.prepareTestApp(ResetPasswordPage()));

      await tester.pumpAndSettle();
      await tester.enterText(sltiResetPasswordEmail, 'chorny@berlento.com');
      await tester.tap(rbResetPassword);

      await tester.pumpAndSettle();
      expect(find.text('Bad request'), findsOneWidget);
    });

    testWidgets(
        'When tapping on the app bar back button, it navigates back to the Login page',
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
      await tester.tap(abbbResetPassword);

      await tester.pumpAndSettle();
      expect(find.byType(LoginPage), findsOneWidget);
    });
  });
}
