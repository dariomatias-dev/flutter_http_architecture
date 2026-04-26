import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_http_architecture/src/app_widget.dart';

import 'package:flutter_http_architecture/src/features/http_workbench/presentation/screens/http_workbench/http_workbench_screen.dart';

void main() {
  testWidgets('AppWidget loads initial screen correctly', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: AppWidget()));

    await tester.pump();

    expect(find.byType(HttpWorkbenchScreen), findsOneWidget);
  });
}
