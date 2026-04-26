import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_http_architecture/src/features/http_workbench/di/http_workbench_providers.dart';
import 'package:flutter_http_architecture/src/features/http_workbench/presentation/screens/http_simple/http_simple_screen.dart';
import 'package:flutter_http_architecture/src/features/http_workbench/presentation/viewmodels/http_simple_view_state.dart';

import '../../../data/fakes/fake_http_tester_notifier.dart';

void main() {
  Widget createWidget(HttpSimpleViewState state) {
    return ProviderScope(
      overrides: [
        httpSimpleNotifierProvider.overrideWith(FakeHttpTesterNotifier.new),
      ],
      child: const MaterialApp(home: HttpSimpleScreen()),
    );
  }

  testWidgets('renders initial UI components', (tester) async {
    await tester.pumpWidget(createWidget(HttpSimpleViewState()));

    expect(find.text('REQUEST CONFIGURATION'), findsOneWidget);
    expect(find.text('EXECUTE REQUEST'), findsOneWidget);
    expect(find.byType(DropdownButtonFormField), findsWidgets);
    expect(find.byType(TextFormField), findsOneWidget);
  });

  testWidgets('displays response section when result is not empty', (
    tester,
  ) async {
    await tester.pumpWidget(
      createWidget(
        HttpSimpleViewState(
          result: 'SUCCESS\nCode: 200\nData: ok',
          headers: '{ "content-type": "json" }',
          duration: '120ms',
          actualRetries: 1,
        ),
      ),
    );

    expect(find.text('METRICS & PERFORMANCE'), findsOneWidget);
    expect(find.text('RESPONSE BODY'), findsOneWidget);
    expect(find.text('HEADERS'), findsOneWidget);
    expect(find.textContaining('SUCCESS'), findsOneWidget);
  });

  testWidgets('displays retry and latency metrics', (tester) async {
    await tester.pumpWidget(
      createWidget(
        HttpSimpleViewState(
          result: 'ok',
          headers: '{}',
          duration: '250ms',
          actualRetries: 3,
        ),
      ),
    );

    expect(find.text('Latency'), findsOneWidget);
    expect(find.text('Retry Count'), findsOneWidget);
    expect(find.text('250ms'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
  });

  testWidgets('button exists and is enabled when not loading', (tester) async {
    await tester.pumpWidget(createWidget(HttpSimpleViewState()));

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));

    expect(button.onPressed, isNotNull);
  });
}
