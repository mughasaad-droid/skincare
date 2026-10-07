// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:skinn/main.dart';

void main() {
  testWidgets('Splash screen smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SkinnApp());

    // Verify that splash screen shows the gif (Image widget).
    expect(find.byType(Image), findsOneWidget);
    
    // Wait for 4 seconds (plus some buffer)
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();

    // Verify that we are now on the welcome screen.
    expect(find.text('LOGIN'), findsOneWidget);
    expect(find.text('SIGN UP'), findsOneWidget);
  });
}
