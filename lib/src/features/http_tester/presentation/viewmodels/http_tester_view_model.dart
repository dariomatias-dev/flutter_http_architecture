import 'dart:convert';

import 'package:flutter_http_architecture/src/features/http_tester/domain/repositories/http_tester_repository.dart';

class HttpTesterViewModel {
  final HttpTesterRepository _repository;

  HttpTesterViewModel(this._repository);

  Future<Map<String, String>> executeAndFormat({
    required String method,
    required int statusCode,
    required int maxRetries,
    String? body,
  }) async {
    Object? parsedData;

    if (body != null && body.isNotEmpty && method != 'GET') {
      try {
        parsedData = jsonDecode(body);
      } catch (_) {
        parsedData = body;
      }
    }

    final response = await _repository.executeRequest(
      method: method,
      statusCode: statusCode,
      maxRetries: maxRetries,
      data: parsedData,
    );

    final duration = '${response.context?.duration?.inMilliseconds ?? 0}ms';
    final retries = '${response.context?.retryCount ?? 0}';
    final headers = const JsonEncoder.withIndent(
      '  ',
    ).convert(response.headers ?? <String, dynamic>{});

    String resultText;
    if (response.isSuccess) {
      resultText =
          'SUCCESS\nCode: ${response.statusCode}\nData: ${response.data}';
    } else {
      resultText =
          'ERROR\nType: ${response.error?.type}\nMessage: ${response.error?.message}';
    }

    return <String, String>{
      'result': resultText,
      'headers': headers,
      'duration': duration,
      'retries': retries,
    };
  }
}
