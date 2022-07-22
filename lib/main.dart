import 'package:flutter/material.dart';
import 'package:survey/fonts.dart';
import 'package:survey/pages/login/login_page.dart';

import 'flavors.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: F.appName,
      theme: ThemeData(fontFamily: Fonts.neuzeit),
      home: const Scaffold(
        resizeToAvoidBottomInset: false,
        body: LoginPage(),
      ),
    );
  }
}
