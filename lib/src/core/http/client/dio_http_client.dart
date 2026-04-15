import 'package:dio/dio.dart';

import 'package:flutter_http_architecture/src/core/http/client/http_client.dart';
import 'package:flutter_http_architecture/src/core/http/config/network_config.dart';
import 'package:flutter_http_architecture/src/core/http/executor/request_executor.dart';
import 'package:flutter_http_architecture/src/core/http/interceptors/logging_interceptor.dart';
import 'package:flutter_http_architecture/src/core/http/models/api_response.dart';
import 'package:flutter_http_architecture/src/core/http/options/http_request_options.dart';
import 'package:flutter_http_architecture/src/core/http/tokens/http_cancel_token.dart';
import 'package:flutter_http_architecture/src/core/http/types/progress_callback_http.dart';

class DioCancelToken implements HttpCancelToken {
  final CancelToken _token = CancelToken();

  CancelToken get raw => _token;

  @override
  bool get isCancelled => _token.isCancelled;

  @override
  void cancel([String? reason]) {
    _token.cancel(reason);
  }
}

class DioHttpClient implements HttpClient {
  DioHttpClient({required NetworkConfig config})
    : _defaultHeaders = config.defaultHeaders {
    _dio = Dio(
      BaseOptions(
        baseUrl: config.baseUrl ?? '',
        connectTimeout: config.connectTimeout,
        receiveTimeout: config.receiveTimeout,
        headers: _defaultHeaders,
      ),
    );

    _dio.interceptors.add(LoggingInterceptor());

    _executor = RequestExecutor();
  }

  late final Dio _dio;
  late final RequestExecutor _executor;
  final Map<String, dynamic> _defaultHeaders;

  Options _mapToDioOptions(String method, HttpRequestOptions? options) {
    final mergedHeaders = {
      ..._defaultHeaders,
      if (options?.headers != null) ...options!.headers!,
    };

    return Options(
      method: method,
      headers: mergedHeaders,
      sendTimeout: options?.sendTimeout,
      receiveTimeout: options?.receiveTimeout,
      contentType: options?.contentType,
      extra: options?.extra,
    );
  }

  CancelToken? _extractCancelToken(HttpCancelToken? token) {
    if (token is DioCancelToken) {
      return token.raw;
    }

    return null;
  }

  Future<ApiResponse<T?>> _request<T>(
    String method,
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    HttpRequestOptions? options,
    ProgressCallbackHttp? onSendProgress,
    ProgressCallbackHttp? onReceiveProgress,
    HttpCancelToken? cancelToken,
  }) {
    return _executor.execute(
      request: () {
        return _dio.request<T>(
          path,
          data: data,
          queryParameters: queryParameters,
          options: _mapToDioOptions(method, options),
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress,
          cancelToken: _extractCancelToken(cancelToken),
        );
      },
      maxRetries: options?.maxRetries ?? 0,
      retryDelay: options?.retryDelay ?? Duration.zero,
    );
  }

  @override
  Future<ApiResponse<T?>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    HttpRequestOptions? options,
    HttpCancelToken? cancelToken,
  }) {
    return _request<T>(
      'GET',
      path,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  @override
  Future<ApiResponse<T?>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    HttpRequestOptions? options,
    ProgressCallbackHttp? onSendProgress,
    ProgressCallbackHttp? onReceiveProgress,
    HttpCancelToken? cancelToken,
  }) {
    return _request<T>(
      'POST',
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
      cancelToken: cancelToken,
    );
  }

  @override
  Future<ApiResponse<T?>> put<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    HttpRequestOptions? options,
    ProgressCallbackHttp? onSendProgress,
    ProgressCallbackHttp? onReceiveProgress,
    HttpCancelToken? cancelToken,
  }) {
    return _request<T>(
      'PUT',
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
      cancelToken: cancelToken,
    );
  }

  @override
  Future<ApiResponse<T?>> patch<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    HttpRequestOptions? options,
    ProgressCallbackHttp? onSendProgress,
    ProgressCallbackHttp? onReceiveProgress,
    HttpCancelToken? cancelToken,
  }) {
    return _request<T>(
      'PATCH',
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
      cancelToken: cancelToken,
    );
  }

  @override
  Future<ApiResponse<T?>> delete<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    HttpRequestOptions? options,
    HttpCancelToken? cancelToken,
  }) {
    return _request<T>(
      'DELETE',
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  @override
  Future<ApiResponse<T?>> options<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    HttpRequestOptions? options,
    HttpCancelToken? cancelToken,
  }) {
    return _request<T>(
      'OPTIONS',
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }
}
