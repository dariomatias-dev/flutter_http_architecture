import 'dart:async';

import 'package:flutter_http_architecture/src/features/http_workbench/presentation/providers/http_simple_notifier.dart';
import 'package:flutter_http_architecture/src/features/http_workbench/presentation/viewmodels/http_simple_view_state.dart';

class FakeHttpSimpleNotifier extends HttpSimpleNotifier {
  FakeHttpSimpleNotifier(this._initialState);

  final HttpSimpleViewState _initialState;

  @override
  FutureOr<HttpSimpleViewState> build() {
    return _initialState;
  }
}
