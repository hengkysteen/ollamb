import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:ollamb/src/app.dart';
import 'package:ollamb/src/core/dm.dart';
import 'package:ollamb/src/features/model_list/model_list_view.dart';
import 'package:ollamb/src/features/splash/splash_view.dart';
import 'package:ollamb/src/ui/pages/main_page.dart';

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await DM.init();
  });

  testWidgets("App Flow", (t) async {
    await init(t);
    await modelList(t);
  });
}

Future<void> init(WidgetTester t) async {
  // Initialize and render the app
  await t.pumpWidget(const App());
  await t.pump();
  // Ensure the SplashView is displayed first
  expect(find.byType(SplashView), findsOneWidget);
  // Wait for the transition to complete (max 1 second)
  await t.pumpAndSettle(const Duration(seconds: 1));
  // Verify that MainPage is displayed after SplashView
  expect(find.byType(MainPage), findsOneWidget);
  // wait for 2 seconds (optional, for observation)
  sleep(const Duration(seconds: 2));
}

Future<void> modelList(WidgetTester t) async {
  // Find the button using its key
  final modelListButton = find.byKey(const Key('MODEL_LIST_BUTTON'));
  expect(modelListButton, findsOneWidget); // Ensure the button exists
  // Tap the button
  await t.tap(modelListButton);
  await t.pumpAndSettle(); // Wait for the modal to appear
  // Verify that the ModelListView modal appears
  expect(find.byType(ModelListView), findsOneWidget);
  // wait for 2 seconds (optional, for observation)
  sleep(const Duration(seconds: 2));
  await t.runAsync(() async => Navigator.of(t.element(find.byType(ModelListView))).pop());
  await t.pumpAndSettle();
  // wait for 2 seconds (optional, for observation)
  sleep(const Duration(seconds: 2));
}
