import 'dart:io';

import 'package:dio/dio.dart';

import 'package:flutter_http_architecture/src/core/http/errors/http_error.dart';
import 'package:flutter_http_architecture/src/core/http/errors/http_error_type.dart';
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
        final error = _mapDioError(err);

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

  HttpError _mapDioError(DioException err) {
    final statusCode = err.response?.statusCode;
    final responseData = err.response?.data;

    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return HttpError(
          type: HttpErrorType.timeout,
          message: 'Request timeout',
          statusCode: statusCode,
        );

      case DioExceptionType.badCertificate:
        return HttpError(
          type: HttpErrorType.security,
          message: 'Invalid SSL certificate',
        );

      case DioExceptionType.badResponse:
        return _mapStatusCodeError(statusCode, responseData, err);

      case DioExceptionType.cancel:
        return HttpError(
          type: HttpErrorType.cancel,
          message: 'Request cancelled',
        );

      case DioExceptionType.connectionError:
        final error = err.error;
        if (error is SocketException) {
          return HttpError(
            type: HttpErrorType.network,
            message: 'No internet connection',
          );
        }

        return HttpError(
          type: HttpErrorType.network,
          message: error?.toString() ?? 'Connection error',
        );

      default:
        return HttpError(
          type: HttpErrorType.unknown,
          message: err.message ?? 'Unknown error',
          statusCode: statusCode,
        );
    }
  }

  HttpError _mapStatusCodeError(
    int? statusCode,
    dynamic data,
    DioException err,
  ) {
    final message = _extractMessage(data);

    switch (statusCode) {
      case 400:
        return HttpError(
          type: HttpErrorType.badRequest,
          statusCode: statusCode,
          message: message ?? 'Bad request',
        );

      case 401:
        return HttpError(
          type: HttpErrorType.unauthorized,
          statusCode: statusCode,
          message: message ?? 'Unauthorized',
        );

      case 403:
        return HttpError(
          type: HttpErrorType.forbidden,
          statusCode: statusCode,
          message: message ?? 'Forbidden',
        );

      case 404:
        return HttpError(
          type: HttpErrorType.notFound,
          statusCode: statusCode,
          message: message ?? 'Not found',
        );

      case 409:
        return HttpError(
          type: HttpErrorType.conflict,
          statusCode: statusCode,
          message: message ?? 'Conflict',
        );

      case 422:
        return HttpError(
          type: HttpErrorType.validation,
          statusCode: statusCode,
          message: message ?? 'Validation error',
          data: data,
        );

      case 429:
        return HttpError(
          type: HttpErrorType.tooManyRequests,
          statusCode: statusCode,
          message: message ?? 'Too many requests',
        );
    }

    if (statusCode != null && statusCode >= 500) {
      return HttpError(
        type: HttpErrorType.server,
        statusCode: statusCode,
        message: message ?? 'Server error',
      );
    }

    return HttpError(
      type: HttpErrorType.unknown,
      statusCode: statusCode,
      message: message ?? err.message ?? 'Unknown error',
    );
  }

  String? _extractMessage(dynamic data) {
    if (data is Map<String, dynamic>) return data['errors']?.toString();
    return data?.toString();
  }

  Duration _calculateDelay(int attempt, Duration baseDelay) {
    if (baseDelay == Duration.zero) return Duration.zero;

    final exponentialFactor = 1 << attempt;
    final delay = baseDelay * exponentialFactor;

    const maxDelay = Duration(seconds: 10);

    return delay > maxDelay ? maxDelay : delay;
  }
}
