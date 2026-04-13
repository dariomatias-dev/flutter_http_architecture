import 'package:flutter_http_architecture/src/core/http/errors/http_error_type.dart';

class HttpError {
  final HttpErrorType type;
  final String message;
  final int? statusCode;
  final Object? data;
  final StackTrace? stackTrace;

  HttpError({
    required this.type,
    required this.message,
    this.statusCode,
    this.data,
    this.stackTrace,
  });
}
