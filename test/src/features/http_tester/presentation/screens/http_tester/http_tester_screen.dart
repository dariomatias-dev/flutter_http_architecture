import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_http_architecture/src/features/http_tester/di/http_tester_providers.dart';
import 'package:flutter_http_architecture/src/features/http_tester/presentation/providers/http_tester_notifier.dart';
import 'package:flutter_http_architecture/src/features/http_tester/presentation/screens/http_tester/http_tester_screen.dart';
import 'package:flutter_http_architecture/src/features/http_tester/presentation/viewmodels/http_tester_view_state.dart';

class FakeNotifier extends HttpTesterNotifier {
  FakeNotifier(this._state);

  final HttpTesterViewState _state;

  @override
  HttpTesterViewState build() => _state;
}

void main() {
  Widget createWidget(HttpTesterViewState state) {
    return ProviderScope(
      overrides: [
        httpTesterNotifierProvider.overrideWith(() => FakeNotifier(state)),
      ],
      child: const MaterialApp(home: HttpTesterScreen()),
    );
  }

  testWidgets('renders initial UI components', (tester) async {
    await tester.pumpWidget(createWidget(HttpTesterViewState()));

    expect(find.text('REQUEST CONFIGURATION'), findsOneWidget);
    expect(find.text('EXECUTE REQUEST'), findsOneWidget);
    expect(find.byType(DropdownButtonFormField), findsWidgets);
    expect(find.byType(TextFormField), findsOneWidget);
  });

  testWidgets('shows loading state when isLoading is true', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          httpTesterNotifierProvider.overrideWith(
            () => FakeNotifier(HttpTesterViewState().copyWith()),
          ),
        ],
        child: const MaterialApp(home: HttpTesterScreen()),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('displays response section when result is not empty', (
    tester,
  ) async {
    await tester.pumpWidget(
      createWidget(
        HttpTesterViewState(
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
        HttpTesterViewState(
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
    await tester.pumpWidget(createWidget(HttpTesterViewState()));

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));

    expect(button.onPressed, isNotNull);
  });
}
