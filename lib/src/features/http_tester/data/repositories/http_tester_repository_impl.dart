import 'package:flutter_http_architecture/src/core/http/client/http_client.dart';
import 'package:flutter_http_architecture/src/core/http/models/api_response.dart';
import 'package:flutter_http_architecture/src/core/http/options/http_request_options.dart';

import 'package:flutter_http_architecture/src/features/http_tester/domain/repositories/http_tester_repository.dart';

class HttpTesterRepositoryImpl implements HttpTesterRepository {
  final HttpClient _client;

  HttpTesterRepositoryImpl(this._client);

  @override
  Future<ApiResponse<dynamic>> executeRequest({
    required String method,
    required int statusCode,
    int maxRetries = 0,
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    final path = '/status/$statusCode';
    final options = HttpRequestOptions(
      maxRetries: maxRetries,
      retryDelay: const Duration(seconds: 2),
      retryable: true,
    );

    return switch (method.toUpperCase()) {
      'POST' => _client.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      ),
      'PUT' => _client.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      ),
      'PATCH' => _client.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      ),
      'DELETE' => _client.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      ),
      'OPTIONS' => _client.options(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      ),
      _ => _client.get(
        path,
        queryParameters: queryParameters,
        options: options,
      ),
    };
  }
}
