import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:AquaPlan/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('search'), findsOneWidget); // Address değeri

    // Tap the button to trigger location update.
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    // Verify that location and address are updated.
    expect(find.text('Lat:'), findsOneWidget);
    expect(find.text('Long:'), findsOneWidget);
    expect(find.text('ADDRESS'), findsOneWidget);
  });
}
