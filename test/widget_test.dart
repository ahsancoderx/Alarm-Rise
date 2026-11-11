import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Ahsan App smoke test', (WidgetTester tester) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(),
        home: Scaffold(
          appBar: AppBar(
            title: Text('Ahsan App'),
          ),
          body: Center(
            child: Text('Hello, World!'),
          ),
        ),
      ),
    );

    // Check that the AppBar title exists.
    expect(find.text('Ahsan App'), findsOneWidget);

    // Check that Hello, World! exists.
    expect(find.text('Hello, World!'), findsOneWidget);
  });
}