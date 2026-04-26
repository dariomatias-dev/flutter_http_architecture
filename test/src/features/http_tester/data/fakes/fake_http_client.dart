import 'package:flutter_http_architecture/src/core/http/client/http_client.dart';
import 'package:flutter_http_architecture/src/core/http/models/api_response.dart';

class FakeHttpClient implements HttpClient {
  final ApiResponse<dynamic> Function(String method, String path)?
  responseBuilder;

  FakeHttpClient({this.responseBuilder});

  ApiResponse<dynamic> _build(String method, String path) {
    return responseBuilder?.call(method, path) ??
        ApiResponse(data: null, statusCode: 200);
  }

  @override
  Future<ApiResponse<T?>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    options,
    cancelToken,
  }) async {
    return _build('GET', path) as ApiResponse<T?>;
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
    return _build('POST', path) as ApiResponse<T?>;
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
    return _build('PUT', path) as ApiResponse<T?>;
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
    return _build('PATCH', path) as ApiResponse<T?>;
  }

  @override
  Future<ApiResponse<T?>> delete<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    options,
    cancelToken,
  }) async {
    return _build('DELETE', path) as ApiResponse<T?>;
  }

  @override
  Future<ApiResponse<T?>> options<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    options,
    cancelToken,
  }) async {
    return _build('OPTIONS', path) as ApiResponse<T?>;
  }
}
