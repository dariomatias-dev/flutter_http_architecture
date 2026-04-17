class HttpRequestOptions {
  final Map<String, String>? headers;
  final Duration? sendTimeout;
  final Duration? receiveTimeout;
  final String? contentType;
  final Map<String, dynamic>? extra;
  final int? maxRetries;
  final Duration? retryDelay;
  final bool? retryable;

  const HttpRequestOptions({
    this.headers,
    this.sendTimeout,
    this.receiveTimeout,
    this.contentType,
    this.extra,
    this.maxRetries,
    this.retryDelay,
    this.retryable,
  });

  HttpRequestOptions copyWith({
    Map<String, String>? headers,
    Duration? sendTimeout,
    Duration? receiveTimeout,
    String? contentType,
    Map<String, dynamic>? extra,
    int? maxRetries,
    Duration? retryDelay,
    bool? retryable,
  }) {
    return HttpRequestOptions(
      headers: headers ?? this.headers,
      sendTimeout: sendTimeout ?? this.sendTimeout,
      receiveTimeout: receiveTimeout ?? this.receiveTimeout,
      contentType: contentType ?? this.contentType,
      extra: extra ?? this.extra,
      maxRetries: maxRetries ?? this.maxRetries,
      retryDelay: retryDelay ?? this.retryDelay,
      retryable: retryable ?? this.retryable,
    );
  }
}
