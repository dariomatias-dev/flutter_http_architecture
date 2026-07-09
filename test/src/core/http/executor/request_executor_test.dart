import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_http_architecture/src/core/http/executor/request_executor.dart';
import 'package:flutter_http_architecture/src/core/http/options/http_request_options.dart';
import 'package:flutter_http_architecture/src/core/http/errors/http_error_type.dart';

void main() {
  test('returns success response when request succeeds', () async {
    final executor = RequestExecutor();

    final result = await executor.execute<String>(
      method: 'GET',
      path: '/resource',
      request: (context) async {
        return Response<String>(
          requestOptions: RequestOptions(path: '/resource'),
          statusCode: 200,
          data: 'success',
        );
      },
    );

    expect(result.data, 'success');
    expect(result.statusCode, 200);
    expect(result.error, null);
  });

  test('maps exception to unknown error', () async {
    final executor = RequestExecutor();

    final result = await executor.execute<String>(
      method: 'GET',
      path: '/resource',
      request: (context) async {
        throw Exception('unexpected failure');
      },
    );

    expect(result.data, null);
    expect(result.error, isNotNull);
    expect(result.error!.type, HttpErrorType.unknown);
  });

  test('retries request when allowed and succeeds on second attempt', () async {
    final executor = RequestExecutor();

    int attempts = 0;

    final result = await executor.execute<String>(
      method: 'GET',
      path: '/resource',
      options: const HttpRequestOptions(maxRetries: 1),
      request: (context) async {
        attempts++;

        if (attempts == 1) {
          throw DioException(
            requestOptions: RequestOptions(path: '/resource'),
            type: DioExceptionType.connectionError,
          );
        }

        return Response<String>(
          requestOptions: RequestOptions(path: '/resource'),
          statusCode: 200,
          data: 'ok',
        );
      },
    );

    expect(attempts, 2);
    expect(result.data, 'ok');
  });

  test('does not retry when cancel error occurs', () async {
    final executor = RequestExecutor();

    int attempts = 0;

    final result = await executor.execute<String>(
      method: 'GET',
      path: '/resource',
      options: const HttpRequestOptions(maxRetries: 2),
      request: (context) async {
        attempts++;

        throw DioException(
          requestOptions: RequestOptions(path: '/resource'),
          type: DioExceptionType.cancel,
        );
      },
    );

    expect(attempts, 1);
    expect(result.data, null);
    expect(result.error!.type, HttpErrorType.cancel);
  });

  test('returns error after exhausting all retries', () async {
    final executor = RequestExecutor();

    int attempts = 0;

    final result = await executor.execute<String>(
      method: 'GET',
      path: '/resource',
      options: const HttpRequestOptions(maxRetries: 2),
      request: (context) async {
        attempts++;

        throw DioException(
          requestOptions: RequestOptions(path: '/resource'),
          type: DioExceptionType.connectionError,
        );
      },
    );

    // Initial attempt + 2 retries.
    expect(attempts, 3);
    expect(result.data, null);
    expect(result.error!.type, HttpErrorType.network);
  });

  test('does not retry non-retryable 4xx responses', () async {
    final executor = RequestExecutor();

    int attempts = 0;

    final result = await executor.execute<String>(
      method: 'GET',
      path: '/resource',
      options: const HttpRequestOptions(maxRetries: 3),
      request: (context) async {
        attempts++;

        throw DioException(
          requestOptions: RequestOptions(path: '/resource'),
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(path: '/resource'),
            statusCode: 400,
          ),
        );
      },
    );

    expect(attempts, 1);
    expect(result.error!.type, HttpErrorType.badRequest);
  });

  test('retries on 503 server response', () async {
    final executor = RequestExecutor();

    int attempts = 0;

    final result = await executor.execute<String>(
      method: 'GET',
      path: '/resource',
      options: const HttpRequestOptions(maxRetries: 1),
      request: (context) async {
        attempts++;

        if (attempts == 1) {
          throw DioException(
            requestOptions: RequestOptions(path: '/resource'),
            type: DioExceptionType.badResponse,
            response: Response(
              requestOptions: RequestOptions(path: '/resource'),
              statusCode: 503,
            ),
          );
        }

        return Response<String>(
          requestOptions: RequestOptions(path: '/resource'),
          statusCode: 200,
          data: 'ok',
        );
      },
    );

    expect(attempts, 2);
    expect(result.data, 'ok');
  });

  test('does not retry non-idempotent POST when retryable is unset', () async {
    final executor = RequestExecutor();

    int attempts = 0;

    final result = await executor.execute<String>(
      method: 'POST',
      path: '/resource',
      options: const HttpRequestOptions(maxRetries: 3),
      request: (context) async {
        attempts++;

        throw DioException(
          requestOptions: RequestOptions(path: '/resource'),
          type: DioExceptionType.connectionError,
        );
      },
    );

    expect(attempts, 1);
    expect(result.error!.type, HttpErrorType.network);
  });

  test('exposes retry count in response context', () async {
    final executor = RequestExecutor();

    int attempts = 0;

    final result = await executor.execute<String>(
      method: 'GET',
      path: '/resource',
      options: const HttpRequestOptions(maxRetries: 2),
      request: (context) async {
        attempts++;

        if (attempts < 3) {
          throw DioException(
            requestOptions: RequestOptions(path: '/resource'),
            type: DioExceptionType.connectionError,
          );
        }

        return Response<String>(
          requestOptions: RequestOptions(path: '/resource'),
          statusCode: 200,
          data: 'ok',
        );
      },
    );

    expect(result.context?.retryCount, 2);
  });
}
