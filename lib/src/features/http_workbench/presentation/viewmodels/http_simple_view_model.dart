import 'dart:convert';

import 'package:flutter_http_architecture/src/features/http_workbench/data/services/http_tester_service.dart';

class HttpSimpleViewModel {
  final HttpTesterService _service;

  HttpSimpleViewModel(this._service);

  Future<Map<String, String>> executeAndFormat({
    required String method,
    required int statusCode,
    required int maxRetries,
  }) async {
    final response = await _service.executeRequest(
      method: method,
      statusCode: statusCode,
      maxRetries: maxRetries,
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
