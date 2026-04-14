import 'dart:io';

import 'package:dio/dio.dart';

import 'package:flutter_http_architecture/src/core/http/executor/request_context.dart';
import 'package:flutter_http_architecture/src/core/http/models/api_response.dart';
import 'package:flutter_http_architecture/src/core/http/errors/http_error.dart';
import 'package:flutter_http_architecture/src/core/http/errors/http_error_type.dart';

class RequestExecutor {
  Future<ApiResponse<T?>> execute<T>({
    required Future<Response<T?>> Function() request,
    int maxRetries = 0,
  }) async {
    RequestContext? context;

    for (int attempt = 0; attempt <= maxRetries; attempt++) {
      try {
        final response = await request();

        context =
            response.requestOptions.extra['requestContext'] as RequestContext?;

        if (context != null) {
          context.retryCount = attempt;
        }

        return ApiResponse<T?>(
          data: response.data,
          statusCode: response.statusCode,
          headers: response.headers.map,
          error: null,
          context: context,
        );
      } on DioException catch (err) {
        context = err.requestOptions.extra['requestContext'] as RequestContext?;

        final error = _mapDioError(err);

        if (context != null) {
          context.retryCount = attempt;
          context.error = error;
          context.statusCode = err.response?.statusCode;
        }

        if (attempt == maxRetries) {
          return ApiResponse<T?>(
            data: null,
            statusCode: context?.statusCode,
            headers: err.response?.headers.map,
            error: error,
            context: context,
          );
        }
      } catch (err, stackTrace) {
        final error = HttpError(
          type: HttpErrorType.unknown,
          message: err.toString(),
          stackTrace: stackTrace,
        );

        return ApiResponse<T?>(data: null, error: error, context: context);
      }
    }

    return ApiResponse<T?>(data: null, context: context);
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
}
