import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_http_architecture/src/features/http_tester/presentation/viewmodels/http_tester_view_model.dart';

import '../../data/fakes/failing_http_tester_repository.dart';
import '../../data/fakes/fake_http_tester_repository.dart';

void main() {
  test('formats success response', () async {
    final vm = HttpTesterViewModel(FakeHttpTesterRepository());

    final result = await vm.executeAndFormat(
      method: 'GET',
      statusCode: 200,
      maxRetries: 0,
    );

    expect(result['result']!.contains('SUCCESS'), true);
  });

  test('formats error response', () async {
    final vm = HttpTesterViewModel(FailingHttpTesterRepository());

    final result = await vm.executeAndFormat(
      method: 'GET',
      statusCode: 500,
      maxRetries: 0,
    );

    expect(result['result']!.contains('ERROR'), true);
  });
}
