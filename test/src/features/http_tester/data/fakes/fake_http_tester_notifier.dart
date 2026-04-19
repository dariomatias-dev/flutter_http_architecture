import 'dart:async';

import 'package:flutter_http_architecture/src/features/http_tester/presentation/providers/http_tester_notifier.dart';
import 'package:flutter_http_architecture/src/features/http_tester/presentation/viewmodels/http_tester_view_state.dart';

class FakeHttpTesterNotifier extends HttpTesterNotifier {
  @override
  FutureOr<HttpTesterViewState> build() {
    return HttpTesterViewState();
  }
}
