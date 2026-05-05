import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import 'package:flutter_http_architecture/src/core/http/errors/http_error_mapper.dart';
import 'package:flutter_http_architecture/src/core/http/executor/request_context.dart';
import 'package:flutter_http_architecture/src/core/http/utils/log_sanitizer.dart';

class LoggingInterceptor extends Interceptor {
  final _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );

  String _formatContext(RequestContext context) {
    return 'start=${context.startTime.toIso8601String()} | '
        'retry=${context.retryCount} | '
        'status=${context.statusCode ?? '-'} | '
        'duration=${context.duration != null ? '${context.duration?.inMilliseconds}ms' : '-'}';
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    RequestContext? context =
        options.extra['requestContext'] as RequestContext?;

    context ??= RequestContext(
      method: options.method,
      path: options.path,
      startTime: DateTime.now(),
    );

    options.extra['requestContext'] = context;

    final buffer = StringBuffer();

    buffer.writeln('┌───────────── HTTP REQUEST ─────────────');
    buffer.writeln('│ ▶ REQUEST');
    buffer.writeln('│   ${options.method} ${options.uri}');
    buffer.writeln('│');
    buffer.writeln('│ ▶ CONTEXT');
    buffer.writeln('│   ${_formatContext(context)}');
    buffer.writeln('│');
    buffer.writeln('│ ▶ HEADERS');
    buffer.writeln('│   ${LogSanitizer.sanitize(options.headers)}');

    if (options.queryParameters.isNotEmpty) {
      buffer.writeln('│');
      buffer.writeln('│ ▶ QUERY');
      buffer.writeln('│   ${LogSanitizer.sanitize(options.queryParameters)}');
    }

    if (options.data != null) {
      buffer.writeln('│');
      buffer.writeln('│ ▶ BODY');
      buffer.writeln('│   ${LogSanitizer.sanitize(options.data)}');
    }

    buffer.writeln('└────────────────────────────────────────');

    _logger.i(buffer.toString());

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final context =
        response.requestOptions.extra['requestContext'] as RequestContext?;

    if (context != null) {
      context.statusCode = response.statusCode;
      context.duration = DateTime.now().difference(context.startTime);
    }

    final buffer = StringBuffer();

    buffer.writeln('┌──────────── HTTP RESPONSE ─────────────');
    buffer.writeln('│ ▶ RESPONSE');
    buffer.writeln(
      '│   ${response.requestOptions.method} ${response.requestOptions.uri}',
    );
    buffer.writeln('│   STATUS: ${response.statusCode}');

    if (context != null) {
      buffer.writeln('│');
      buffer.writeln('│ ▶ CONTEXT');
      buffer.writeln('│   ${_formatContext(context)}');

      if (context.error != null) {
        buffer.writeln('│');
        buffer.writeln('│ ▶ ERROR');
        buffer.writeln(
          '│   ${context.error!.type} | ${context.error!.message}',
        );
      }
    }

    buffer.writeln('│');
    buffer.writeln('│ ▶ HEADERS');
    buffer.writeln('│   ${LogSanitizer.sanitize(response.headers.map)}');

    buffer.writeln('│');
    buffer.writeln('│ ▶ DATA');
    buffer.writeln('│   ${LogSanitizer.sanitize(response.data)}');

    buffer.writeln('└────────────────────────────────────────');

    _logger.i(buffer.toString());

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final context =
        err.requestOptions.extra['requestContext'] as RequestContext?;

    if (context != null) {
      context.statusCode = err.response?.statusCode;
      context.duration = DateTime.now().difference(context.startTime);
      context.error = HttpErrorMapper.map(err);
    }

    final buffer = StringBuffer();

    buffer.writeln('┌───────────── HTTP ERROR ──────────────');
    buffer.writeln('│ ▶ REQUEST');
    buffer.writeln(
      '│   ${err.requestOptions.method} ${err.requestOptions.uri}',
    );
    buffer.writeln('│   STATUS: ${err.response?.statusCode}');

    if (context != null) {
      buffer.writeln('│');
      buffer.writeln('│ ▶ CONTEXT');
      buffer.writeln('│   ${_formatContext(context)}');

      if (context.error != null) {
        buffer.writeln('│');
        buffer.writeln('│ ▶ ERROR');
        buffer.writeln(
          '│   ${context.error!.type} | ${context.error!.message}',
        );
      }
    }

    buffer.writeln('│');
    buffer.writeln('│ ▶ HEADERS');
    buffer.writeln('│   ${LogSanitizer.sanitize(err.response?.headers.map)}');

    buffer.writeln('│');
    buffer.writeln('│ ▶ DATA');
    buffer.writeln('│   ${LogSanitizer.sanitize(err.response?.data)}');

    buffer.writeln('│');
    buffer.writeln('│ ▶ EXCEPTION');
    buffer.writeln('│   ${err.error}');

    buffer.writeln('│');
    buffer.writeln('│ ▶ STACK');
    buffer.writeln('│   ${err.stackTrace}');

    buffer.writeln('└────────────────────────────────────────');

    _logger.e(buffer.toString());

    handler.next(err);
  }
}
