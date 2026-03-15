class ApiResponse<T> {
  final T? data;
  final int? statusCode;
  final Map<String, dynamic>? headers;
  final String? errorMessage;
  final StackTrace? stackTrace;

  const ApiResponse({
    required this.data,
    this.statusCode,
    this.headers,
    this.errorMessage,
    this.stackTrace,
  });
}
