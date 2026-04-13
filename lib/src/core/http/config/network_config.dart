class NetworkConfig {
  final String? baseUrl;
  final Duration connectTimeout;
  final Duration receiveTimeout;
  final Map<String, dynamic> defaultHeaders;

  const NetworkConfig({
    this.baseUrl,
    this.connectTimeout = const Duration(seconds: 10),
    this.receiveTimeout = const Duration(seconds: 10),
    this.defaultHeaders = const {'Content-Type': 'application/json'},
  });

  NetworkConfig copyWith({
    String? baseUrl,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    Map<String, dynamic>? defaultHeaders,
  }) {
    return NetworkConfig(
      baseUrl: baseUrl,
      connectTimeout: connectTimeout ?? this.connectTimeout,
      receiveTimeout: receiveTimeout ?? this.receiveTimeout,
      defaultHeaders: defaultHeaders ?? this.defaultHeaders,
    );
  }
}
