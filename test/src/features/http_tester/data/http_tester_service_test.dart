import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_http_architecture/src/features/http_workbench/data/services/http_tester_service.dart';

import 'fakes/spy_http_client.dart';

void main() {
  test('GET method uses client.get', () async {
    final client = SpyHttpClient();
    final service = HttpTesterService(client);

    final result = await service.executeRequest(method: 'GET', statusCode: 200);

    expect(result.data, 'get');
    expect(client.lastMethod, 'GET');
  });

  test('POST method uses client.post', () async {
    final client = SpyHttpClient();
    final service = HttpTesterService(client);

    final result = await service.executeRequest(
      method: 'POST',
      statusCode: 200,
    );

    expect(result.data, 'post');
    expect(client.lastMethod, 'POST');
  });

  test('PUT method uses client.put', () async {
    final client = SpyHttpClient();
    final service = HttpTesterService(client);

    final result = await service.executeRequest(method: 'PUT', statusCode: 200);

    expect(result.data, 'put');
    expect(client.lastMethod, 'PUT');
  });

  test('PATCH method uses client.patch', () async {
    final client = SpyHttpClient();
    final service = HttpTesterService(client);

    final result = await service.executeRequest(
      method: 'PATCH',
      statusCode: 200,
    );

    expect(result.data, 'patch');
    expect(client.lastMethod, 'PATCH');
  });

  test('DELETE method uses client.delete', () async {
    final client = SpyHttpClient();
    final service = HttpTesterService(client);

    final result = await service.executeRequest(
      method: 'DELETE',
      statusCode: 200,
    );

    expect(result.data, 'delete');
    expect(client.lastMethod, 'DELETE');
  });

  test('OPTIONS method uses client.options', () async {
    final client = SpyHttpClient();
    final service = HttpTesterService(client);

    final result = await service.executeRequest(
      method: 'OPTIONS',
      statusCode: 200,
    );

    expect(result.data, 'options');
    expect(client.lastMethod, 'OPTIONS');
  });
}
