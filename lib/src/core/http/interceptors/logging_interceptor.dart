import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class LoggingInterceptor extends Interceptor {
  final _logger = Logger();

  @override
  void onRequest(options, handler) {
    _logger.i(
      'REQUEST [${options.method}] ${options.uri}',
      error: options.data,
    );

    if (options.queryParameters.isNotEmpty) {
      _logger.i('QUERY PARAMETERS: ${options.queryParameters}');
    }

    handler.next(options);
  }

  @override
  void onResponse(response, handler) {
    _logger.i(
      'RESPONSE [${response.statusCode}] ${response.requestOptions.uri}',
      error: response.data,
    );

    handler.next(response);
  }

  @override
  void onError(err, handler) {
    _logger.e(
      'ERROR [${err.requestOptions.uri}]',
      error: err,
      stackTrace: err.stackTrace,
    );

    handler.next(err);
  }
}
