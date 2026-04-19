import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_http_architecture/src/features/http_tester/di/http_tester_providers.dart';
import 'package:flutter_http_architecture/src/features/http_tester/presentation/viewmodels/http_tester_view_state.dart';

class HttpTesterNotifier extends AsyncNotifier<HttpTesterViewState> {
  @override
  FutureOr<HttpTesterViewState> build() {
    return HttpTesterViewState();
  }

  void updateMethod(String method) {
    final current = state.value ?? HttpTesterViewState();

    state = AsyncData(current.copyWith(method: method));
  }

  void updateStatus(int status) {
    final current = state.value ?? HttpTesterViewState();

    state = AsyncData(current.copyWith(statusCode: status));
  }

  void updateRetryCount(int count) {
    final current = state.value ?? HttpTesterViewState();

    state = AsyncData(current.copyWith(maxRetries: count));
  }

  void updateBody(String body) {
    final current = state.value ?? HttpTesterViewState();
    state = AsyncData(current.copyWith(requestBody: body));
  }

  Future<void> runRequest() async {
    final current = state.value ?? HttpTesterViewState();
    final viewModel = ref.read(httpTesterViewModelProvider);

    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final responseMap = await viewModel.executeAndFormat(
        method: current.method,
        statusCode: current.statusCode,
        maxRetries: current.maxRetries,
        body: current.requestBody,
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
