import 'package:flutter_http_architecture/src/core/http/models/api_response.dart';
import 'package:flutter_http_architecture/src/core/http/options/http_request_options.dart';
import 'package:flutter_http_architecture/src/core/http/tokens/http_cancel_token.dart';
import 'package:flutter_http_architecture/src/core/type/progress_callback_http.dart';

abstract class HttpClient {
  Future<ApiResponse<T?>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    HttpRequestOptions? options,
    HttpCancelToken? cancelToken,
  });

  Future<ApiResponse<T?>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    HttpRequestOptions? options,
    ProgressCallbackHttp? onSendProgress,
    ProgressCallbackHttp? onReceiveProgress,
    HttpCancelToken? cancelToken,
  });

  Future<ApiResponse<T?>> put<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    HttpRequestOptions? options,
    ProgressCallbackHttp? onSendProgress,
    ProgressCallbackHttp? onReceiveProgress,
    HttpCancelToken? cancelToken,
  });

  Future<ApiResponse<T?>> patch<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    HttpRequestOptions? options,
    ProgressCallbackHttp? onSendProgress,
    ProgressCallbackHttp? onReceiveProgress,
    HttpCancelToken? cancelToken,
  });

  Future<ApiResponse<T?>> delete<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    HttpRequestOptions? options,
    HttpCancelToken? cancelToken,
  });

  Future<ApiResponse<T?>> options<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    HttpRequestOptions? options,
    HttpCancelToken? cancelToken,
  });
}
