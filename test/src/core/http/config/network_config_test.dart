import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_http_architecture/src/core/http/config/network_config.dart';

void main() {
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
