import 'package:flutter_http_architecture/src/core/http/client/http_client.dart';
import 'package:flutter_http_architecture/src/core/http/models/api_response.dart';
import 'package:flutter_http_architecture/src/core/http/options/http_request_options.dart';

class SpyHttpClient implements HttpClient {
  String? lastMethod;
  String? lastPath;
  Object? lastData;
  Map<String, dynamic>? lastQueryParameters;
  HttpRequestOptions? lastOptions;
  bool closed = false;

  ApiResponse<T?> _record<T>(
    String method,
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    HttpRequestOptions? options,
  }) {
    lastMethod = method;
    lastPath = path;
    lastData = data;
    lastQueryParameters = queryParameters;
    lastOptions = options;

    return ApiResponse(data: method.toLowerCase() as T, statusCode: 200);
  }

  @override
  Future<ApiResponse<T?>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    HttpRequestOptions? options,
    cancelToken,
  }) async {
    return _record<T>(
      'GET',
      path,
      queryParameters: queryParameters,
      options: options,
    );
  }

  @override
  Future<ApiResponse<T?>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    HttpRequestOptions? options,
    onSendProgress,
    onReceiveProgress,
    cancelToken,
  }) async {
    return _record<T>(
      'POST',
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  @override
  Future<ApiResponse<T?>> put<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    HttpRequestOptions? options,
    onSendProgress,
    onReceiveProgress,
    cancelToken,
  }) async {
    return _record<T>(
      'PUT',
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  @override
  Future<ApiResponse<T?>> patch<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    HttpRequestOptions? options,
    onSendProgress,
    onReceiveProgress,
    cancelToken,
  }) async {
    return _record<T>(
      'PATCH',
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  @override
  Future<ApiResponse<T?>> delete<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    HttpRequestOptions? options,
    cancelToken,
  }) async {
    return _record<T>(
      'DELETE',
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  @override
  Future<ApiResponse<T?>> options<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    HttpRequestOptions? options,
    cancelToken,
  }) async {
    return _record<T>(
      'OPTIONS',
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  @override
  void close({bool force = false}) {
    closed = true;
  }
}
