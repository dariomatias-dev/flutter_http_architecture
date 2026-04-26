import 'package:flutter_http_architecture/src/core/http/client/http_client.dart';
import 'package:flutter_http_architecture/src/core/http/models/api_response.dart';

class SpyHttpClient implements HttpClient {
  String? lastMethod;

  @override
  Future<ApiResponse<T?>> get<T>(
    String path, {
    queryParameters,
    options,
    cancelToken,
  }) async {
    lastMethod = 'GET';
    return ApiResponse(data: 'get' as T, statusCode: 200);
  }

  @override
  Future<ApiResponse<T?>> post<T>(
    String path, {
    data,
    queryParameters,
    options,
    onSendProgress,
    onReceiveProgress,
    cancelToken,
  }) async {
    lastMethod = 'POST';
    return ApiResponse(data: 'post' as T, statusCode: 200);
  }

  @override
  Future<ApiResponse<T?>> put<T>(
    String path, {
    data,
    queryParameters,
    options,
    onSendProgress,
    onReceiveProgress,
    cancelToken,
  }) async {
    lastMethod = 'PUT';
    return ApiResponse(data: 'put' as T, statusCode: 200);
  }

  @override
  Future<ApiResponse<T?>> patch<T>(
    String path, {
    data,
    queryParameters,
    options,
    onSendProgress,
    onReceiveProgress,
    cancelToken,
  }) async {
    lastMethod = 'PATCH';
    return ApiResponse(data: 'patch' as T, statusCode: 200);
  }

  @override
  Future<ApiResponse<T?>> delete<T>(
    String path, {
    data,
    queryParameters,
    options,
    cancelToken,
  }) async {
    lastMethod = 'DELETE';
    return ApiResponse(data: 'delete' as T, statusCode: 200);
  }

  @override
  Future<ApiResponse<T?>> options<T>(
    String path, {
    data,
    queryParameters,
    options,
    cancelToken,
  }) async {
    lastMethod = 'OPTIONS';
    return ApiResponse(data: 'options' as T, statusCode: 200);
  }
}
