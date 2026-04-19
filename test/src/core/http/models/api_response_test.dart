import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_http_architecture/src/core/http/models/api_response.dart';
import 'package:flutter_http_architecture/src/core/http/errors/http_error.dart';
import 'package:flutter_http_architecture/src/core/http/errors/http_error_type.dart';

void main() {
  test('isSuccess returns true when status is below 400 and no error', () {
    final response = ApiResponse<String>(data: 'ok', statusCode: 200);

    expect(response.isSuccess, true);
  });

  test('isSuccess returns false when status is 400 or higher', () {
    final response = ApiResponse<String>(data: 'error', statusCode: 404);

    expect(response.isSuccess, false);
  });

  test('isSuccess returns false when error exists', () {
    final response = ApiResponse<String>(
      data: null,
      statusCode: 200,
      error: HttpError(type: HttpErrorType.unknown, message: 'fail'),
    );

    expect(response.isSuccess, false);
  });
}
