import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registro_ponto_frontend/features/counter/presentation/views/counter_page.dart';

void main() {
  testWidgets('Counter increments and decrements', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: CounterPage()),
      ),
    );

    expect(find.text('0'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    expect(find.text('1'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.remove));
    await tester.pump();
    expect(find.text('0'), findsOneWidget);
  });
}
