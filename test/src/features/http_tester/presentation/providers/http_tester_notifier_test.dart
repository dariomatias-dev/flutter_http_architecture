import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_http_architecture/src/features/http_tester/di/http_tester_providers.dart';

void main() {
  test('updates method', () {
    final container = ProviderContainer();
    final notifier = container.read(httpTesterNotifierProvider.notifier);

    notifier.updateMethod('POST');

    expect(container.read(httpTesterNotifierProvider).value!.method, 'POST');
  });

  test('updates status code', () {
    final container = ProviderContainer();
    final notifier = container.read(httpTesterNotifierProvider.notifier);

    notifier.updateStatus(404);

    expect(container.read(httpTesterNotifierProvider).value!.statusCode, 404);
  });

  test('updates retry count', () {
    final container = ProviderContainer();
    final notifier = container.read(httpTesterNotifierProvider.notifier);

    notifier.updateRetryCount(3);

    expect(container.read(httpTesterNotifierProvider).value!.maxRetries, 3);
  });
}
