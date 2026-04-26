import 'package:flutter_http_architecture/src/core/constants/api_urls.dart';
import 'package:flutter_http_architecture/src/core/constants/methods.dart';
import 'package:flutter_http_architecture/src/core/constants/retry_attempts.dart';
import 'package:flutter_http_architecture/src/core/http/models/api_response.dart';

import 'package:flutter_http_architecture/src/features/http_workbench/domain/entities/http_advanced_item.dart';

class HttpAdvancedState {
  final String method;
  final String url;
  final List<HttpAdvancedItem> headers;
  final List<HttpAdvancedItem> queryParams;
  final String body;
  final int maxRetries;
  final ApiResponse<dynamic>? response;

  HttpAdvancedState({
    required this.method,
    required this.url,
    required this.headers,
    required this.queryParams,
    required this.body,
    required this.maxRetries,
    this.response,
  });

  HttpAdvancedState.initial()
    : method = methods.first,
      url = ApiUrls.httpbin,
      headers = <HttpAdvancedItem>[HttpAdvancedItem()],
      queryParams = <HttpAdvancedItem>[HttpAdvancedItem()],
      body = '{\n "id": 1,\n "name": "tester"\n}',
      maxRetries = retryAttempts.first,
      response = null;

  HttpAdvancedState copyWith({
    String? method,
    String? url,
    List<HttpAdvancedItem>? headers,
    List<HttpAdvancedItem>? queryParams,
    String? body,
    int? maxRetries,
    ApiResponse<dynamic>? response,
  }) {
    return HttpAdvancedState(
      method: method ?? this.method,
      url: url ?? this.url,
      headers: headers ?? this.headers,
      queryParams: queryParams ?? this.queryParams,
      body: body ?? this.body,
      maxRetries: maxRetries ?? this.maxRetries,
      response: response ?? this.response,
    );
  }
}
