import 'package:flutter/material.dart';

import 'app_config.dart';
import 'main.dart';

void main() {
  var configuredApp = const AppConfig(
    appName: 'Survey',
    flavorName: 'production',
    endpoint: 'https://survey-api.nimblehq.co/',
    child: MyApp(),
  );

  runApp(configuredApp);
}
