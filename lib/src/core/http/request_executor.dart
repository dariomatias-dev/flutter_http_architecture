import 'dart:io';

import 'package:dio/dio.dart';

import 'package:flutter_http_architecture/src/core/http/api_response.dart';
import 'package:flutter_http_architecture/src/core/http/errors/http_error.dart';
import 'package:flutter_http_architecture/src/core/http/errors/http_error_type.dart';

class RequestExecutor {
  Future<ApiResponse<T?>> execute<T>(
    Future<Response<T?>> Function() request,
  ) async {
    try {
      final response = await request();

      return ApiResponse<T?>(
        data: response.data,
        statusCode: response.statusCode,
        headers: response.headers.map,
      );
    } on DioException catch (err) {
      return ApiResponse<T?>(
        data: null,
        statusCode: err.response?.statusCode,
        headers: err.response?.headers.map,
        error: _mapDioError(err),
      );
    } catch (err, stackTrace) {
      return ApiResponse<T?>(
        data: null,
        error: HttpError(
          type: HttpErrorType.unknown,
          message: err.toString(),
          stackTrace: stackTrace,
        ),
      );
    }
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
          message: err.error?.toString() ?? err.message ?? 'Unknown error',
          statusCode: statusCode,
        );
    }
  }

  HttpError _mapStatusCodeError(
    int? statusCode,
    dynamic data,
    DioException err,
  ) {
    final messageFromApi = _extractMessage(data);

    switch (statusCode) {
      case 400:
        return HttpError(
          type: HttpErrorType.badRequest,
          statusCode: statusCode,
          message: messageFromApi ?? 'Bad request',
        );
      case 401:
        return HttpError(
          type: HttpErrorType.unauthorized,
          statusCode: statusCode,
          message: messageFromApi ?? 'Unauthorized',
        );
      case 403:
        return HttpError(
          type: HttpErrorType.forbidden,
          statusCode: statusCode,
          message: messageFromApi ?? 'Forbidden',
        );
      case 404:
        return HttpError(
          type: HttpErrorType.notFound,
          statusCode: statusCode,
          message: messageFromApi ?? 'Not found',
        );
      case 409:
        return HttpError(
          type: HttpErrorType.conflict,
          statusCode: statusCode,
          message: messageFromApi ?? 'Conflict',
        );
      case 422:
        return HttpError(
          type: HttpErrorType.validation,
          statusCode: statusCode,
          message: messageFromApi ?? 'Validation error',
          data: data,
        );
      case 429:
        return HttpError(
          type: HttpErrorType.tooManyRequests,
          statusCode: statusCode,
          message: messageFromApi ?? 'Too many requests',
        );
    }

    if (statusCode != null && statusCode >= 500) {
      return HttpError(
        type: HttpErrorType.server,
        statusCode: statusCode,
        message: messageFromApi ?? 'Server error',
      );
    }

    return HttpError(
      type: HttpErrorType.unknown,
      statusCode: statusCode,
      message: messageFromApi ?? err.message ?? 'Unknown error',
    );
  }

  String? _extractMessage(dynamic data) {
    if (data == null) return null;

    if (data is Map<String, dynamic>) {
      return data['errors']?.toString();
    }

    return null;
  }
}
