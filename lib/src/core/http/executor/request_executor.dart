import 'package:dio/dio.dart';

import 'package:flutter_http_architecture/src/core/http/errors/http_error.dart';
import 'package:flutter_http_architecture/src/core/http/errors/http_error_type.dart';
import 'package:flutter_http_architecture/src/core/http/errors/http_error_mapper.dart';
import 'package:flutter_http_architecture/src/core/http/executor/request_context.dart';
import 'package:flutter_http_architecture/src/core/http/models/api_response.dart';
import 'package:flutter_http_architecture/src/core/http/options/http_request_options.dart';

class RequestExecutor {
  Future<ApiResponse<T>> execute<T>({
    required Future<Response<T>> Function(RequestContext context) request,
    required String method,
    required String path,
    HttpRequestOptions? options,
  }) async {
    final context = RequestContext(
      method: method,
      path: path,
      startTime: DateTime.now(),
    );

    final maxRetries = options?.maxRetries ?? 0;
    final retryDelay = options?.retryDelay ?? Duration.zero;

    for (int attempt = 0; attempt <= maxRetries; attempt++) {
      try {
        context.retryCount = attempt;

        final response = await request(context);

        context.statusCode = response.statusCode;
        context.duration = DateTime.now().difference(context.startTime);

        return ApiResponse<T>(
          data: response.data,
          statusCode: response.statusCode,
          headers: response.headers.map,
          context: context,
        );
      } on DioException catch (err) {
        final error = HttpErrorMapper.map(err);

        context.error = error;
        context.statusCode = err.response?.statusCode;
        context.duration = DateTime.now().difference(context.startTime);

        final shouldRetry = _shouldRetry(err, method, options);

        if (attempt < maxRetries && shouldRetry) {
          final delay = _calculateDelay(attempt, retryDelay);

          if (delay > Duration.zero) {
            await Future.delayed(delay);
          }

          continue;
        }

        return ApiResponse<T>(
          data: null,
          statusCode: context.statusCode,
          headers: err.response?.headers.map,
          error: error,
          context: context,
        );
      } catch (err, stackTrace) {
        final error = HttpError(
          type: HttpErrorType.unknown,
          message: err.toString(),
          stackTrace: stackTrace,
        );

        context.error = error;
        context.duration = DateTime.now().difference(context.startTime);

        return ApiResponse<T>(data: null, error: error, context: context);
      }
    }

    return ApiResponse<T>(context: context);
  }

  bool _shouldRetry(
    DioException err,
    String method,
    HttpRequestOptions? options,
  ) {
    if (err.type == DioExceptionType.cancel) return false;

    final retryable = options?.retryable ?? _isIdempotent(method);
    if (!retryable) return false;

    const retryableTypes = {
      DioExceptionType.connectionTimeout,
      DioExceptionType.receiveTimeout,
      DioExceptionType.sendTimeout,
      DioExceptionType.connectionError,
    };

    if (retryableTypes.contains(err.type)) return true;

    final statusCode = err.response?.statusCode;

    return statusCode != null && (statusCode >= 500 || statusCode == 429);
  }

  bool _isIdempotent(String method) {
    return const ['GET', 'HEAD', 'OPTIONS', 'PUT', 'DELETE'].contains(method);
  }

  Duration _calculateDelay(int attempt, Duration baseDelay) {
    if (baseDelay == Duration.zero) return Duration.zero;

    final exponentialFactor = 1 << attempt;
    final delay = baseDelay * exponentialFactor;

    const maxDelay = Duration(seconds: 10);

    return delay > maxDelay ? maxDelay : delay;
  }
}
