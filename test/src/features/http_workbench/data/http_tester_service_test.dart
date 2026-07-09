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

  test('unknown method falls back to client.get', () async {
    final client = SpyHttpClient();
    final service = HttpTesterService(client);

    final result = await service.executeRequest(
      method: 'FOO',
      statusCode: 200,
    );

    expect(result.data, 'get');
    expect(client.lastMethod, 'GET');
  });

  test('method is case-insensitive', () async {
    final client = SpyHttpClient();
    final service = HttpTesterService(client);

    await service.executeRequest(method: 'post', statusCode: 200);

    expect(client.lastMethod, 'POST');
  });

  test('builds path from status code', () async {
    final client = SpyHttpClient();
    final service = HttpTesterService(client);

    await service.executeRequest(method: 'GET', statusCode: 404);

    expect(client.lastPath, '/status/404');
  });

  test('forwards retry options and query parameters', () async {
    final client = SpyHttpClient();
    final service = HttpTesterService(client);

    await service.executeRequest(
      method: 'GET',
      statusCode: 200,
      maxRetries: 3,
      queryParameters: {'q': 'value'},
    );

    expect(client.lastOptions?.maxRetries, 3);
    expect(client.lastOptions?.retryable, true);
    expect(client.lastQueryParameters, {'q': 'value'});
  });

  test('forwards body data on write methods', () async {
    final client = SpyHttpClient();
    final service = HttpTesterService(client);

    await service.executeRequest(
      method: 'POST',
      statusCode: 200,
      data: {'name': 'test'},
    );

    expect(client.lastData, {'name': 'test'});
  });
}
