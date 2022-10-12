import 'package:flutter_config/flutter_config.dart';

class EnvVariables {
  static String get apiEndpoint {
    return FlutterConfig.get('API_ENDPOINT');
  }

  static String get clientId {
    return FlutterConfig.get('CLIENT_ID');
  }

  static String get clientSecret {
    return FlutterConfig.get('CLIENT_SECRET');
  }
}
