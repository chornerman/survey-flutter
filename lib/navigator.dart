import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:survey/page/home/home_page.dart';
import 'package:survey/page/resetpassword/reset_password_page.dart';
import 'package:survey/page/start/start_page.dart';
import 'package:survey/page/surveydetail/survey_detail_page.dart';

const String _routeStart = '/';
const String _routeHome = '/home';
const String _routeResetPassword = '/reset-password';
const String _routeSurveyDetail = '/survey-detail';

class Routes {
  static final routes = <String, WidgetBuilder>{
    _routeStart: (BuildContext context) => StartPage(),
    _routeHome: (BuildContext context) => const HomePage(),
    _routeResetPassword: (BuildContext context) => const ResetPasswordPage(),
    _routeSurveyDetail: (BuildContext context) => const SurveyDetailPage(),
  };
}

abstract class AppNavigator {
  void navigateBack(BuildContext context);

  void navigateToHomeAndClearStack(BuildContext context);

  void navigateToResetPassword(BuildContext context);

  void navigateToStartAndClearStack(BuildContext context);

  void navigateToSurveyDetail(BuildContext context, String surveyId);
}

@Injectable(as: AppNavigator)
class AppNavigatorImpl extends AppNavigator {
  @override
  void navigateBack(BuildContext context) => Navigator.of(context).pop();

  @override
  void navigateToHomeAndClearStack(BuildContext context) =>
      Navigator.pushNamedAndRemoveUntil(context, _routeHome, (r) => false);

  @override
  void navigateToResetPassword(BuildContext context) =>
      Navigator.of(context).pushNamed(_routeResetPassword);

  @override
  void navigateToStartAndClearStack(BuildContext context) =>
      Navigator.pushNamedAndRemoveUntil(context, _routeStart, (r) => false);

  @override
  void navigateToSurveyDetail(BuildContext context, String surveyId) =>
      Navigator.of(context).pushNamed(
        _routeSurveyDetail,
        arguments: surveyId,
      );
}
