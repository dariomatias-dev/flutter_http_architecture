import 'package:flutter_http_architecture/src/core/http/executor/request_context.dart';
import 'package:flutter_http_architecture/src/core/http/models/api_response.dart';

import 'package:flutter_http_architecture/src/features/http_tester/domain/repositories/http_tester_repository.dart';

class FakeHttpTesterRepository implements HttpTesterRepository {
  @override
  Future<ApiResponse<dynamic>> executeRequest({
    required String method,
    required int statusCode,
    int maxRetries = 0,
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    return ApiResponse(
      data: {'message': 'success'},
      statusCode: statusCode,
      headers: {'x-test': 'true'},
      context: RequestContext(
        method: method,
        path: '/test',
        startTime: DateTime.now(),
      ),
    );
  }
}
