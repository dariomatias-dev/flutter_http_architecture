import 'package:dio/dio.dart';

import 'package:flutter_http_architecture/src/core/http/api_response.dart';
import 'package:flutter_http_architecture/src/core/http/http_client.dart';
import 'package:flutter_http_architecture/src/core/http/interceptors/logging_interceptor.dart';
import 'package:flutter_http_architecture/src/core/http/network_config.dart';
import 'package:flutter_http_architecture/src/core/http/request_executor.dart';
import 'package:flutter_http_architecture/src/core/type/progress_callback_http.dart';

class DioHttpClient implements HttpClient {
  DioHttpClient({required NetworkConfig config}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: config.baseUrl ?? '',
        connectTimeout: config.connectTimeout,
        receiveTimeout: config.receiveTimeout,
        headers: config.defaultHeaders,
      ),
    );

    _dio.interceptors.add(LoggingInterceptor());

    _executor = RequestExecutor();
  }

  late final Dio _dio;
  late final RequestExecutor _executor;

  Future<ApiResponse<T?>> _request<T>(
    String method,
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    ProgressCallbackHttp? onSendProgress,
    ProgressCallbackHttp? onReceiveProgress,
  }) {
    final combinedHeaders = {
      ..._dio.options.headers,
      if (headers != null) ...headers,
    };

    return _executor.execute(() {
      return _dio.request<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(method: method, headers: combinedHeaders),
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    });
  }

  @override
  Future<ApiResponse<T?>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) {
    return _request<T>(
      'GET',
      path,
      queryParameters: queryParameters,
      headers: headers,
    );
  }

  @override
  Future<ApiResponse<T?>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    ProgressCallbackHttp? onSendProgress,
    ProgressCallbackHttp? onReceiveProgress,
  }) {
    return _request<T>(
      'POST',
      path,
      data: data,
      queryParameters: queryParameters,
      headers: headers,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  @override
  Future<ApiResponse<T?>> put<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    ProgressCallbackHttp? onSendProgress,
    ProgressCallbackHttp? onReceiveProgress,
  }) {
    return _request<T>(
      'PUT',
      path,
      data: data,
      queryParameters: queryParameters,
      headers: headers,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  @override
  Future<ApiResponse<T?>> patch<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    ProgressCallbackHttp? onSendProgress,
    ProgressCallbackHttp? onReceiveProgress,
  }) {
    return _request<T>(
      'PATCH',
      path,
      data: data,
      queryParameters: queryParameters,
      headers: headers,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  @override
  Future<ApiResponse<T?>> delete<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) {
    return _request<T>(
      'DELETE',
      path,
      data: data,
      queryParameters: queryParameters,
      headers: headers,
    );
  }
}
