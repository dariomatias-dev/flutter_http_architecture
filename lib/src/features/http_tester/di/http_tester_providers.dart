import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_http_architecture/src/core/di/network_providers.dart';

import 'package:flutter_http_architecture/src/features/http_tester/data/repositories/http_tester_repository_impl.dart';
import 'package:flutter_http_architecture/src/features/http_tester/domain/repositories/http_tester_repository.dart';
import 'package:flutter_http_architecture/src/features/http_tester/presentation/providers/http_tester_notifier.dart';
import 'package:flutter_http_architecture/src/features/http_tester/presentation/viewmodels/http_tester_view_model.dart';
import 'package:flutter_http_architecture/src/features/http_tester/presentation/viewmodels/http_tester_view_state.dart';

final httpTesterRepositoryProvider = Provider<HttpTesterRepository>((ref) {
  final client = ref.watch(httpBinClientProvider);

  return HttpTesterRepositoryImpl(client);
});

final httpTesterViewModelProvider = Provider<HttpTesterViewModel>((ref) {
  final repository = ref.watch(httpTesterRepositoryProvider);

  return HttpTesterViewModel(repository);
});

final httpTesterNotifierProvider =
    AsyncNotifierProvider.autoDispose<HttpTesterNotifier, HttpTesterViewState>(
      HttpTesterNotifier.new,
    );
