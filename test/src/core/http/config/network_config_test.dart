import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_http_architecture/src/core/http/config/network_config.dart';

void main() {
  test('applies default values when omitted', () {
    const config = NetworkConfig();

    expect(config.baseUrl, isNull);
    expect(config.connectTimeout, const Duration(seconds: 10));
    expect(config.receiveTimeout, const Duration(seconds: 10));
    expect(config.defaultHeaders, {'Content-Type': 'application/json'});
  });

  test('copyWith without arguments keeps all fields', () {
    const config = NetworkConfig(
      baseUrl: 'https://example.com',
      connectTimeout: Duration(seconds: 3),
      receiveTimeout: Duration(seconds: 4),
      defaultHeaders: {'X-Api-Key': 'abc'},
    );

    final copy = config.copyWith();

    expect(copy.baseUrl, config.baseUrl);
    expect(copy.connectTimeout, config.connectTimeout);
    expect(copy.receiveTimeout, config.receiveTimeout);
    expect(copy.defaultHeaders, config.defaultHeaders);
  });

  test('copyWith updates multiple fields at once', () {
    const config = NetworkConfig(baseUrl: 'https://example.com');

    final updated = config.copyWith(
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 30),
    );

    expect(updated.baseUrl, 'https://example.com');
    expect(updated.connectTimeout, const Duration(seconds: 20));
    expect(updated.receiveTimeout, const Duration(seconds: 30));
  });

  test('copyWith updates only provided fields', () {
    const config = NetworkConfig(
      baseUrl: 'https://example.com',
      connectTimeout: Duration(seconds: 5),
      receiveTimeout: Duration(seconds: 5),
      defaultHeaders: {'Content-Type': 'application/json'},
    );

    final updated = config.copyWith(baseUrl: 'https://api.example.com');

    expect(updated.baseUrl, 'https://api.example.com');
    expect(updated.connectTimeout, config.connectTimeout);
    expect(updated.receiveTimeout, config.receiveTimeout);
    expect(updated.defaultHeaders, config.defaultHeaders);
  });
}
