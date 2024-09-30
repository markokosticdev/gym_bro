import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:gym_bro/configs/state.dart';
import 'package:gym_bro/configs/theme.dart';
import 'package:gym_bro/main.dart';

import 'package:provider/provider.dart';

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await AppTheme.initialize();
  });

  setUp(() async {
    AppState.reset();
    final appState = AppState();
    await appState.initializePersistedState();
  });

  testWidgets('CreateWorkoutTest', (WidgetTester tester) async {
    _overrideOnError();

    await tester.pumpWidget(ChangeNotifierProvider(
      create: (context) => AppState(),
      child: const MyApp(),
    ));

    await tester.tap(find.byKey(const ValueKey('createWorkout')));
    await tester.pumpAndSettle(const Duration(milliseconds: 200));
    expect(find.byKey(const ValueKey('saveWorkout')), findsOneWidget);
  });
}

void _overrideOnError() {
  final originalOnError = FlutterError.onError!;
  FlutterError.onError = (errorDetails) {
    if (_shouldIgnoreError(errorDetails.toString())) {
      return;
    }
    originalOnError(errorDetails);
  };
}

bool _shouldIgnoreError(String error) {
  if (error.contains('ImageCodecException')) {
    return true;
  }

  if (error.contains('overflowed by')) {
    return true;
  }

  if (error.contains('No host specified in URI') ||
      error.contains('EXCEPTION CAUGHT BY IMAGE RESOURCE SERVICE')) {
    return true;
  }

  if (error.contains('setState() called after dispose()')) {
    return true;
  }

  return false;
}
