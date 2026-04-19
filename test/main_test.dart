import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import 'package:flutter_http_architecture/src/app_widget.dart';

void main() {
  testWidgets('main app starts without crashing', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: AppWidget()));
    await tester.pump();

    expect(find.byType(MaterialApp), findsOneWidget);
  });

  testWidgets('AppWidget loads initial screen correctly', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: AppWidget()));
    await tester.pump();

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
