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
        return 'https://survey-api.nimblehq.co';
      default:
        return 'https://nimble-survey-web-staging.herokuapp.com';
    }
  }

  static String get clientId {
    switch (appFlavor) {
      case Flavor.production:
        return '4gg3bokkvPnMxWz7HHTdM_wf1RNg9k8iA6sZ2ZrA7EA';
      default:
        return 'z9iUamZLvRgtVVtRJ8UqItg2vmncGyEi30p1eWEddnA';
    }
  }

  static String get clientSecret {
    switch (appFlavor) {
      case Flavor.production:
        return 'y_GgV-GEjWd3VTzbZBS6tqEco0E68QuqHQv0QND2vKo';
      default:
        return '1vqRNMxq-Yx83A61GNjLb17qxCGKxHDb8EmB3MKdxqA';
    }
  }
}
