import 'dart:async';

import 'package:flutter_http_architecture/src/features/http_workbench/presentation/providers/http_simple_notifier.dart';
import 'package:flutter_http_architecture/src/features/http_workbench/presentation/viewmodels/http_simple_view_state.dart';

class FakeHttpTesterNotifier extends HttpSimpleNotifier {
  @override
  FutureOr<HttpSimpleViewState> build() {
    return HttpSimpleViewState();
  }
}
