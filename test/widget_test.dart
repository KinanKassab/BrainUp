// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mastermath/main.dart';

void main() {
  testWidgets('App shows welcome UI', (WidgetTester tester) async {
    // Build app
    await tester.pumpWidget(const ProviderScope(child: MasterMathApp()));

    // Verify welcome elements exist
    expect(find.text('Quizzles'), findsOneWidget);
    expect(find.text('Play Now'), findsOneWidget);
  });

  testWidgets('Navigates from Welcome to Settings screen', (
    WidgetTester tester,
  ) async {
    // Build app
    await tester.pumpWidget(const ProviderScope(child: MasterMathApp()));

    // Tap Play Now button
    await tester.tap(find.text('Play Now'));
    // Start animation frames
    await tester.pump();
    // Finish transition
    await tester.pump(const Duration(milliseconds: 350));

    // Assert Settings screen title appears
    expect(find.text('Test Settings'), findsOneWidget);
  });
}
