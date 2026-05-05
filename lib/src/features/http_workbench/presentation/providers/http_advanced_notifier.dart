import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_http_architecture/src/features/http_workbench/di/http_workbench_providers.dart';
import 'package:flutter_http_architecture/src/features/http_workbench/presentation/viewmodels/http_advanced_state.dart';

class HttpAdvancedNotifier extends AsyncNotifier<HttpAdvancedState> {
  @override
  FutureOr<HttpAdvancedState> build() => HttpAdvancedState.initial();

  Future<void> executeRequest({
    required String method,
    required String url,
    required String body,
    required List<Map<String, dynamic>> headers,
    required List<Map<String, dynamic>> queryParams,
  }) async {
    final currentData = state.value ?? HttpAdvancedState.initial();

    state = const AsyncLoading<HttpAdvancedState>();

    state = await AsyncValue.guard(() async {
      final vm = ref.read(httpAdvancedViewModelProvider);

      final requestState = currentData.copyWith(
        method: method,
        url: url,
        body: body,
      );

      final res = await vm.execute(requestState);

      return requestState.copyWith(response: res);
    });
  }
}
