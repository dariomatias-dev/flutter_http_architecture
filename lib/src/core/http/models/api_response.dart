import 'package:flutter_http_architecture/src/core/http/errors/http_error.dart';

class ApiResponse<T> {
  final T? data;
  final int? statusCode;
  final Map<String, dynamic>? headers;
  final HttpError? error;

  const ApiResponse({
    required this.data,
    this.statusCode,
    this.headers,
    this.error,
  });

  bool get isSuccess => error == null;
}
