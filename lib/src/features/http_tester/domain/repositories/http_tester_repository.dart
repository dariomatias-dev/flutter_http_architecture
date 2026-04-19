import 'package:flutter_http_architecture/src/core/http/models/api_response.dart';

abstract class HttpTesterRepository {
  Future<ApiResponse<dynamic>> executeRequest({
    required String method,
    required int statusCode,
    int maxRetries = 0,
    Object? data,
    Map<String, dynamic>? queryParameters,
  });
}
