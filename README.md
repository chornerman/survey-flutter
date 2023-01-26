# Survey

Nimble Flutter internal certification

## Prerequisite

- Flutter 3.3
- [Recommended] [Flutter Version Management (fvm)](https://fvm.app/)

## Getting Started

### Set up the project
To set up this project locally, follow the steps below:
- Create `.env` files inside the project's root directory and add the required environment variables into them. Take a look at the `.env.sample` to see the list of all required environment variables
  - To set up the **staging** environment, create `.env.staging`
  - To set up the **production** environment, create `.env`
- Generate Flutter files using the below command:
```
fvm flutter packages pub run build_runner build --delete-conflicting-outputs
```

### Run the app

#### Staging
To run the staging flavor app, use the below command:
```
fvm flutter run --flavor staging
```

#### Production
To run the production flavor app, use the below command:
```
fvm flutter run --flavor production
```

### Run tests

#### Unit tests
To run all unit tests, use the below command:
```
fvm flutter test
```

#### Integration tests
To run integration tests with an emulator, use the below command:
```
fvm flutter drive --driver=integration_test_driver/integration_test_driver.dart --flavor staging --target=integration_test/{test_file}.dart
```

## Screenshots

- Onboarding

<img src="https://user-images.githubusercontent.com/13492460/214794037-4ba23ac8-5957-4a5b-9d0b-54e6cad06c35.gif" width="180" height="375"/> <img src="https://user-images.githubusercontent.com/13492460/214794075-e59a8bee-212e-409e-b2d6-677d52f5844d.gif" width="180" height="375"/>

- Home

<img src="https://user-images.githubusercontent.com/13492460/214794101-ce4e5652-cc47-4574-b40b-d0fec3608f9a.gif" width="180" height="375"/>

- Taking survey

<img src="https://user-images.githubusercontent.com/13492460/214794121-3ba82c8c-2e61-427a-8d6a-cedb56d353bc.gif" width="180" height="375"/>
