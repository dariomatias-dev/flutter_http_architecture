import 'dart:io';

import 'package:dio/dio.dart';

import 'package:flutter_http_architecture/src/core/http/errors/http_error.dart';
import 'package:flutter_http_architecture/src/core/http/errors/http_error_type.dart';

class HttpErrorMapper {
  static HttpError map(DioException err) {
    final statusCode = err.response?.statusCode;
    final data = err.response?.data;

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
        return _mapStatusCodeError(statusCode, data, err);

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

  static HttpError _mapStatusCodeError(
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

  static String? _extractMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data['errors']?.toString();
    }
    return data?.toString();
  }
}
