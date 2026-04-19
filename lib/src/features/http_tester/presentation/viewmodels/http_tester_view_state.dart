class HttpTesterViewState {
  final String method;
  final int statusCode;
  final int maxRetries;
  final String result;
  final String headers;
  final String duration;
  final int actualRetries;

  HttpTesterViewState({
    this.method = 'GET',
    this.statusCode = 200,
    this.maxRetries = 0,
    this.result = '',
    this.headers = '',
    this.duration = '',
    this.actualRetries = 0,
  });

  HttpTesterViewState copyWith({
    String? method,
    int? statusCode,
    int? maxRetries,
    String? result,
    String? headers,
    String? duration,
    int? actualRetries,
  }) {
    return HttpTesterViewState(
      method: method ?? this.method,
      statusCode: statusCode ?? this.statusCode,
      maxRetries: maxRetries ?? this.maxRetries,
      result: result ?? this.result,
      headers: headers ?? this.headers,
      duration: duration ?? this.duration,
      actualRetries: actualRetries ?? this.actualRetries,
    );
  }
}
