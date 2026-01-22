import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ssc26/main.dart';

void main() {
  testWidgets('SSC26 app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SSC26App());

    // Verify that the app launches
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
