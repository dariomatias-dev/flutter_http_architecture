import 'package:flutter_http_architecture/src/core/http/api_response.dart';
import 'package:flutter_http_architecture/src/core/type/progress_callback_http.dart';

abstract class HttpClient {
  Future<ApiResponse<T?>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  });

  Future<ApiResponse<T?>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    ProgressCallbackHttp? onSendProgress,
    ProgressCallbackHttp? onReceiveProgress,
  });

  Future<ApiResponse<T?>> put<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    ProgressCallbackHttp? onSendProgress,
    ProgressCallbackHttp? onReceiveProgress,
  });

  Future<ApiResponse<T?>> patch<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    ProgressCallbackHttp? onSendProgress,
    ProgressCallbackHttp? onReceiveProgress,
  });

  Future<ApiResponse<T?>> delete<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  });
}
