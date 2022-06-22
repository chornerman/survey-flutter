enum Flavor {
  production,
  staging,
}

class F {
  static Flavor? appFlavor;

  static String get appName {
    switch (appFlavor) {
      case Flavor.production:
        return 'Survey';
      default:
        return 'Survey Staging';
    }
  }

  static String get apiEndpoint {
    switch (appFlavor) {
      case Flavor.production:
        return 'https://survey-api.nimblehq.co/';
      default:
        return 'https://nimble-survey-web-staging.herokuapp.com/';
    }
  }
}
