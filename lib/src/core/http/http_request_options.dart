class HttpRequestOptions {
  final Map<String, String>? headers;
  final Duration? sendTimeout;
  final Duration? receiveTimeout;
  final String? contentType;
  final Map<String, dynamic>? extra;

  const HttpRequestOptions({
    this.headers,
    this.sendTimeout,
    this.receiveTimeout,
    this.contentType,
    this.extra,
  });

  HttpRequestOptions copyWith({
    Map<String, String>? headers,
    Duration? sendTimeout,
    Duration? receiveTimeout,
    String? contentType,
    Map<String, dynamic>? extra,
  }) {
    return HttpRequestOptions(
      headers: headers ?? this.headers,
      sendTimeout: sendTimeout ?? this.sendTimeout,
      receiveTimeout: receiveTimeout ?? this.receiveTimeout,
      contentType: contentType ?? this.contentType,
      extra: extra ?? this.extra,
    );
  }
}
