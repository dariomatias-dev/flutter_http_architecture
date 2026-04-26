import 'package:flutter_http_architecture/src/core/http/client/http_client.dart';
import 'package:flutter_http_architecture/src/core/http/models/api_response.dart';
import 'package:flutter_http_architecture/src/core/http/options/http_request_options.dart';

class HttpTesterService {
  final HttpClient _client;

  HttpTesterService(this._client);

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

    switch (method.toUpperCase()) {
      case 'POST':
        return _client.post(
          path,
          data: data,
          queryParameters: queryParameters,
          options: options,
        );
      case 'PUT':
        return _client.put(
          path,
          data: data,
          queryParameters: queryParameters,
          options: options,
        );
      case 'PATCH':
        return _client.patch(
          path,
          data: data,
          queryParameters: queryParameters,
          options: options,
        );
      case 'DELETE':
        return _client.delete(
          path,
          data: data,
          queryParameters: queryParameters,
          options: options,
        );
      case 'OPTIONS':
        return _client.options(
          path,
          data: data,
          queryParameters: queryParameters,
          options: options,
        );
      default:
        return _client.get(
          path,
          queryParameters: queryParameters,
          options: options,
        );
    }
  }
}
