import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class LoggingInterceptor extends Interceptor {
  final _logger = Logger();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _logger.i('REQUEST [${options.method}] ${options.uri}');
    _logger.i('HEADERS: ${options.headers}');
    _logger.i('DATA: ${options.data}');

    if (options.queryParameters.isNotEmpty) {
      _logger.i('QUERY: ${options.queryParameters}');
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _logger.i(
      'RESPONSE [${response.statusCode}] ${response.requestOptions.uri}',
    );
    _logger.i('DATA: ${response.data}');

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _logger.e(
      'ERROR [${err.requestOptions.uri}]',
      error: err.error,
      stackTrace: err.stackTrace,
    );

    handler.next(err);
  }
}
