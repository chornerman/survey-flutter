import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:survey/model/survey_model.dart';
import 'package:survey/page/completion/completion_page.dart';
import 'package:survey/page/home/home_page.dart';
import 'package:survey/page/questions/questions_page.dart';
import 'package:survey/page/questions/uimodel/questions_ui_model.dart';
import 'package:survey/page/resetpassword/reset_password_page.dart';
import 'package:survey/page/start/start_page.dart';
import 'package:survey/page/surveydetail/survey_detail_page.dart';

const String _routeStart = '/';
const String _routeHome = '/home';
const String _routeResetPassword = '/reset-password';
const String _routeSurveyDetail = '/survey-detail';
const String _routeQuestions = '/questions';
const String _routeCompletion = '/completion';

class Routes {
  static final routes = <String, WidgetBuilder>{
    _routeStart: (BuildContext context) => StartPage(),
    _routeHome: (BuildContext context) => const HomePage(),
    _routeResetPassword: (BuildContext context) => const ResetPasswordPage(),
    _routeSurveyDetail: (BuildContext context) => const SurveyDetailPage(),
    _routeQuestions: (BuildContext context) => const QuestionsPage(),
    _routeCompletion: (BuildContext context) => const CompletionPage(),
  };
}

abstract class AppNavigator {
  void navigateBack(BuildContext context);

  void navigateToHomeAndClearStack(BuildContext context);

  void navigateToResetPassword(BuildContext context);

  void navigateToStartAndClearStack(BuildContext context);

  void navigateToSurveyDetail(BuildContext context, SurveyModel survey);

  void navigateToQuestions(
    BuildContext context,
    QuestionsUiModel questionsUiModel,
  );

  void navigateToCompletionAndQuitCurrentPage(
    BuildContext context,
    String? outroMessage,
  );
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
  void navigateToSurveyDetail(BuildContext context, SurveyModel survey) =>
      Navigator.of(context).pushNamed(
        _routeSurveyDetail,
        arguments: survey,
      );

  @override
  void navigateToQuestions(
    BuildContext context,
    QuestionsUiModel questionsUiModel,
  ) =>
      Navigator.pushReplacementNamed(
        context,
        _routeQuestions,
        arguments: questionsUiModel,
      );

  @override
  void navigateToCompletionAndQuitCurrentPage(
          BuildContext context, String? outroMessage) =>
      Navigator.pushReplacementNamed(
        context,
        _routeCompletion,
        arguments: outroMessage,
      );
}
