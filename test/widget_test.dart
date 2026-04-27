// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:daily_schedule/main.dart';

void main() {
  testWidgets('welcome screen navigates to day selector', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('WELCOME!'), findsOneWidget);
    expect(find.text('Mulai sekarang'), findsOneWidget);

    await tester.tap(find.text('Mulai sekarang'));
    await tester.pumpAndSettle();

    expect(find.text('YOUR SCHEDULE'), findsOneWidget);
    expect(find.text('Senin'), findsOneWidget);
  });
}
