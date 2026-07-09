import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_http_architecture/src/core/http/models/api_response.dart';
import 'package:flutter_http_architecture/src/core/http/errors/http_error.dart';
import 'package:flutter_http_architecture/src/core/http/errors/http_error_type.dart';

import 'package:flutter_http_architecture/src/features/http_workbench/presentation/viewmodels/http_simple_view_model.dart';
import 'package:flutter_http_architecture/src/features/http_workbench/data/services/http_tester_service.dart';

import '../../data/fakes/fake_http_client.dart';

void main() {
  HttpSimpleViewModel createVm(
    ApiResponse<dynamic> Function(String method, String path) builder,
  ) {
    final client = FakeHttpClient(responseBuilder: builder);
    final service = HttpTesterService(client);

    return HttpSimpleViewModel(service);
  }

  test('formats success response', () async {
    final vm = createVm(
      (method, path) => ApiResponse(data: 'ok', statusCode: 200, error: null),
    );

    final result = await vm.executeAndFormat(
      method: 'GET',
      statusCode: 200,
      maxRetries: 0,
    );

    expect(result['result'], contains('SUCCESS'));
  });

  test('formats error response', () async {
    final vm = createVm(
      (method, path) => ApiResponse(
        data: null,
        statusCode: 500,
        error: HttpError(type: HttpErrorType.server, message: 'error'),
      ),
    );

    final result = await vm.executeAndFormat(
      method: 'GET',
      statusCode: 500,
      maxRetries: 0,
    );

    expect(result['result'], contains('ERROR'));
  });
}
