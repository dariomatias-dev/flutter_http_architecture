import 'package:flutter_http_architecture/src/core/constants/api_urls.dart';
import 'package:flutter_http_architecture/src/core/constants/methods.dart';
import 'package:flutter_http_architecture/src/core/constants/retry_attempts.dart';

import 'package:flutter_http_architecture/src/features/http_workbench/domain/entities/http_advanced_item.dart';

class HttpAdvancedState {
  final String method;
  final String url;
  final List<HttpAdvancedItem> headers;
  final List<HttpAdvancedItem> queryParams;
  final int maxRetries;
  final bool isLoading;

  HttpAdvancedState({
    required this.method,
    required this.url,
    required this.headers,
    required this.queryParams,
    required this.maxRetries,
    required this.isLoading,
  });

  HttpAdvancedState.initial()
    : method = methods.first,
      url = ApiUrls.httpbin,
      headers = <HttpAdvancedItem>[HttpAdvancedItem()],
      queryParams = <HttpAdvancedItem>[HttpAdvancedItem()],
      maxRetries = retryAttempts.first,
      isLoading = false;

  HttpAdvancedState copyWith({
    String? method,
    String? url,
    List<HttpAdvancedItem>? headers,
    List<HttpAdvancedItem>? queryParams,
    int? maxRetries,
    bool? isLoading,
  }) {
    return HttpAdvancedState(
      method: method ?? this.method,
      url: url ?? this.url,
      headers: headers ?? this.headers,
      queryParams: queryParams ?? this.queryParams,
      maxRetries: maxRetries ?? this.maxRetries,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
