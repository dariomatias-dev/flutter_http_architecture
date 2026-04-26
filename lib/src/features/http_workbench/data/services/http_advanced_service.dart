import 'package:flutter_http_architecture/src/core/http/client/http_client.dart';
import 'package:flutter_http_architecture/src/core/http/models/api_response.dart';
import 'package:flutter_http_architecture/src/core/http/options/http_request_options.dart';

class HttpAdvancedService {
  final HttpClient _client;

  HttpAdvancedService(this._client);

  Future<ApiResponse<T?>> request<T>({
    required String method,
    required String url,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    dynamic body,
    int? maxRetries,
  }) async {
    final options = HttpRequestOptions(
      maxRetries: maxRetries,
      retryable: true,
      headers: headers,
    );

    return switch (method.toUpperCase()) {
      'GET' => _client.get<T>(
        url,
        queryParameters: queryParameters,
        options: options,
      ),
      'POST' => _client.post<T>(
        url,
        data: body,
        queryParameters: queryParameters,
        options: options,
      ),
      'PUT' => _client.put<T>(
        url,
        data: body,
        queryParameters: queryParameters,
        options: options,
      ),
      'PATCH' => _client.patch<T>(
        url,
        data: body,
        queryParameters: queryParameters,
        options: options,
      ),
      'DELETE' => _client.delete<T>(
        url,
        data: body,
        queryParameters: queryParameters,
        options: options,
      ),
      'OPTIONS' => _client.options<T>(
        url,
        data: body,
        queryParameters: queryParameters,
        options: options,
      ),
      _ => throw UnimplementedError('Method $method not supported'),
    };
  }
}
