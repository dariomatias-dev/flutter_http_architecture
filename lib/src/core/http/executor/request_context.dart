import 'package:flutter_http_architecture/src/core/http/errors/http_error.dart';

class RequestContext {
  final String method;
  final String path;
  final DateTime startTime;
  Duration? duration;
  int retryCount = 0;
  int? statusCode;
  HttpError? error;

  RequestContext({
    required this.method,
    required this.path,
    required this.startTime,
  });
}
