# GymBro
Manage Workout and Workout Sets

## Structure

- The main configuration is navigation, app state, and theme for the app.
- Navigation maps all screens for easier navigation.
- App State is used as storage for workouts, while we could use SQLite for more data or Firebase for syncing with other devices.
- In the schema folder, I placed all structs(Workout and Workout Set) and enums(Exercise).
- I have decided to store Exercise as an enum cause of consistency and future localization.
- The screens folder contains screens and widgets in the widgets folder
- Every Screen has a widget and model because the screen is stateful.
- Models contain methods and page states as other controllers.
- Widgets that are common or they are stateless are contained in only one file.
- Utils are used across the app and they are separated as general, model, schema, and serialization.

## Packages

- auto_size_text: For responsive text
- collection: For collections/lists
- dropdown_button2: For Exercise dropdown
- font_awesome_flutter: For Icons
- go_router: For navigating
- intl: For date util functions
- page_transition: For screen transitions
- provider: For app state
- shared_preferences: For data persistence
- timeago: For date util functions

## Getting Started

Projects are built to run on the Flutter _stable_ release.

## Integration Tests

To test on a real iOS / Android device, first connect the device and run the following command from the root of the project:

```bash
flutter test test/integration/test.dart
```

To test on a web browser, first launch `chromedriver` as follows:
```bash
chromedriver --port=4444
```

Then from the root of the project, run the following command:
```bash
flutter drive \                                                               
  --driver=test/integration/test.dart \
  --target=test/integration/driver.dart \
  -d chrome
```

Find more information about running Flutter integration tests [here](https://docs.flutter.dev/cookbook/testing/integration/introduction#5-run-the-integration-test).

Refer to this guide for instructions on running the tests on [Firebase Test Lab](https://github.com/flutter/flutter/tree/main/packages/integration_test#firebase-test-lab).
