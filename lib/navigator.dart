import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:survey/page/home/home_page.dart';
import 'package:survey/page/login/login_page.dart';
import 'package:survey/page/reset_password/reset_password_page.dart';

const String _routeLogin = 'login';
const String _routeHome = 'home';
const String _routeResetPassword = 'resetPassword';

class Routes {
  static final routes = <String, WidgetBuilder>{
    _routeLogin: (BuildContext context) => const LoginPage(),
    _routeHome: (BuildContext context) => const HomePage(),
    _routeResetPassword: (BuildContext context) => const ResetPasswordPage(),
  };
}

abstract class AppNavigator {
  void navigateBack(BuildContext context);

  void navigateToHome(BuildContext context);

  void navigateToResetPassword(BuildContext context);
}

@Injectable(as: AppNavigator)
class AppNavigatorImpl extends AppNavigator {
  @override
  void navigateBack(BuildContext context) => Navigator.of(context).pop();

  @override
  void navigateToHome(BuildContext context) =>
      Navigator.of(context).pushNamed(_routeHome);

  @override
  void navigateToResetPassword(BuildContext context) =>
      Navigator.of(context).pushNamed(_routeResetPassword);
}
