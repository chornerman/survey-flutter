import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:survey/api/service/auth_service.dart';
import 'package:survey/database/hive.dart';
import 'package:survey/di/di.dart';
import 'package:survey/resource/app_theme.dart';

import '../fake_service/fake_auth_service.dart';

class IntegrationTestUtils {
  IntegrationTestUtils._();

  static ProviderScope prepareTestApp(
    Widget homeWidget, {
    Map<String, WidgetBuilder> routes = const {},
  }) {
    return ProviderScope(
      child: MaterialApp(
        theme: AppTheme.defaultTheme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: homeWidget,
        routes: routes,
      ),
    );
  }

  static Future<void> prepareTestEnvVariables() async {
    FlutterConfig.loadValueForTesting({
      'API_ENDPOINT': 'API_ENDPOINT',
      'CLIENT_ID': 'CLIENT_ID',
      'CLIENT_SECRET': 'CLIENT_SECRET',
    });

    await initHive();
    await configureDependencies();

    getIt.allowReassignment = true;
    getIt.registerSingleton<AuthService>(FakeAuthService());
  }
}
