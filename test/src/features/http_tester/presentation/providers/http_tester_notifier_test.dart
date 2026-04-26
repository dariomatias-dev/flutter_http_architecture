import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_http_architecture/src/features/http_workbench/di/http_workbench_providers.dart';

void main() {
  test('updates method', () {
    final container = ProviderContainer();

    addTearDown(container.dispose);

    final notifier = container.read(httpSimpleNotifierProvider.notifier);

    notifier.updateMethod('POST');

    expect(container.read(httpSimpleNotifierProvider).value!.method, 'POST');
  });

  test('updates status code', () {
    final container = ProviderContainer();

    addTearDown(container.dispose);

    final notifier = container.read(httpSimpleNotifierProvider.notifier);

    notifier.updateStatus(404);

    expect(container.read(httpSimpleNotifierProvider).value!.statusCode, 404);
  });

  test('updates retry count', () {
    final container = ProviderContainer();

    addTearDown(container.dispose);

    final notifier = container.read(httpSimpleNotifierProvider.notifier);

    notifier.updateRetryCount(3);

    expect(container.read(httpSimpleNotifierProvider).value!.maxRetries, 3);
  });
}
