import 'package:flutter/material.dart';
import 'package:survey/database/shared_preferences_utils.dart';
import 'package:survey/di/di.dart';
import 'package:survey/page/home/home_page.dart';
import 'package:survey/page/login/login_page.dart';

class StartPage extends StatelessWidget {
  StartPage({super.key});

  final _sharedPreferencesUtils = getIt.get<SharedPreferencesUtils>();

  @override
  Widget build(BuildContext context) {
    if (_sharedPreferencesUtils.isLoggedIn) {
      return HomePage();
    } else {
      return LoginPage();
    }
  }
}
