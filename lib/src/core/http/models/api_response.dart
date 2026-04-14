import 'package:flutter_http_architecture/src/core/http/errors/http_error.dart';
import 'package:flutter_http_architecture/src/core/http/executor/request_context.dart';

class ApiResponse<T> {
  final T? data;
  final int? statusCode;
  final Map<String, dynamic>? headers;
  final HttpError? error;
  final RequestContext? context;

  const ApiResponse({
    this.data,
    this.statusCode,
    this.headers,
    this.error,
    this.context,
  });

  bool get isSuccess => error == null && (statusCode ?? 0) < 400;
}
