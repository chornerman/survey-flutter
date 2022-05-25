import 'package:flutter/material.dart';

import 'app_config.dart';
import 'main.dart';

void main() {
  var configuredApp = const AppConfig(
    appName: 'Survey Staging',
    flavorName: 'staging',
    endpoint: 'https://nimble-survey-web-staging.herokuapp.com/',
    child: MyApp(),
  );

  runApp(configuredApp);
}
