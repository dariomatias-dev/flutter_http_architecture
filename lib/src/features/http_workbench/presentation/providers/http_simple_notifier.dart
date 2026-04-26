import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_http_architecture/src/features/http_workbench/di/http_workbench_providers.dart';
import 'package:flutter_http_architecture/src/features/http_workbench/presentation/viewmodels/http_simple_view_state.dart';

class HttpSimpleNotifier extends AsyncNotifier<HttpSimpleViewState> {
  @override
  FutureOr<HttpSimpleViewState> build() {
    return HttpSimpleViewState();
  }

  void updateMethod(String method) {
    final current = state.requireValue;

    state = AsyncData(current.copyWith(method: method));
  }

  void updateStatus(int status) {
    final current = state.requireValue;

    state = AsyncData(current.copyWith(statusCode: status));
  }

  void updateRetryCount(int count) {
    final current = state.requireValue;

    state = AsyncData(current.copyWith(maxRetries: count));
  }

  Future<void> runRequest() async {
    final current = state.requireValue;

    final viewModel = ref.read(httpSimpleViewModelProvider);

    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final responseMap = await viewModel.executeAndFormat(
        method: current.method,
        statusCode: current.statusCode,
        maxRetries: current.maxRetries,
      );

      return current.copyWith(
        result: responseMap['result'],
        headers: responseMap['headers'],
        duration: responseMap['duration'],
        actualRetries: int.tryParse(responseMap['retries'] ?? '0') ?? 0,
      );
    });
  }
}
