import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_http_architecture/src/core/http/client/http_client.dart';
import 'package:flutter_http_architecture/src/core/http/models/api_response.dart';
import 'package:flutter_http_architecture/src/features/http_tester/data/repositories/http_tester_repository_impl.dart';

class FakeHttpClient implements HttpClient {
  @override
  Future<ApiResponse<T?>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    options,
    cancelToken,
  }) async {
    return ApiResponse<T?>(
      data: 'get' as T,
      statusCode: 200,
      headers: {'method': 'get'},
    );
  }

  @override
  Future<ApiResponse<T?>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    options,
    onSendProgress,
    onReceiveProgress,
    cancelToken,
  }) async {
    return ApiResponse<T?>(data: 'post' as T, statusCode: 201);
  }

  @override
  Future<ApiResponse<T?>> put<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    options,
    onSendProgress,
    onReceiveProgress,
    cancelToken,
  }) async {
    return ApiResponse<T?>(data: 'put' as T, statusCode: 200);
  }

  @override
  Future<ApiResponse<T?>> patch<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    options,
    onSendProgress,
    onReceiveProgress,
    cancelToken,
  }) async {
    return ApiResponse<T?>(data: 'patch' as T, statusCode: 200);
  }

  @override
  Future<ApiResponse<T?>> delete<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    options,
    cancelToken,
  }) async {
    return ApiResponse<T?>(data: 'delete' as T, statusCode: 200);
  }

  @override
  Future<ApiResponse<T?>> options<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    options,
    cancelToken,
  }) async {
    return ApiResponse<T?>(data: 'options' as T, statusCode: 200);
  }
}

void main() {
  test('GET method uses client.get', () async {
    final repo = HttpTesterRepositoryImpl(FakeHttpClient());

    final result = await repo.executeRequest(method: 'GET', statusCode: 200);

    expect(result.data, 'get');
  });

  test('POST method uses client.post', () async {
    final repo = HttpTesterRepositoryImpl(FakeHttpClient());

    final result = await repo.executeRequest(
      method: 'POST',
      statusCode: 201,
      data: {'test': true},
    );

    expect(result.data, 'post');
  });

  test('PUT method uses client.put', () async {
    final repo = HttpTesterRepositoryImpl(FakeHttpClient());

    final result = await repo.executeRequest(method: 'PUT', statusCode: 200);

    expect(result.data, 'put');
  });

  test('PATCH method uses client.patch', () async {
    final repo = HttpTesterRepositoryImpl(FakeHttpClient());

    final result = await repo.executeRequest(method: 'PATCH', statusCode: 200);

    expect(result.data, 'patch');
  });

  test('DELETE method uses client.delete', () async {
    final repo = HttpTesterRepositoryImpl(FakeHttpClient());

    final result = await repo.executeRequest(method: 'DELETE', statusCode: 200);

    expect(result.data, 'delete');
  });

  test('OPTIONS method uses client.options', () async {
    final repo = HttpTesterRepositoryImpl(FakeHttpClient());

    final result = await repo.executeRequest(
      method: 'OPTIONS',
      statusCode: 200,
    );

    expect(result.data, 'options');
  });
}
