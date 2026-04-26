import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_http_architecture/src/core/di/network_providers.dart';

import 'package:flutter_http_architecture/src/features/http_workbench/data/services/http_advanced_service.dart';
import 'package:flutter_http_architecture/src/features/http_workbench/data/services/http_tester_service.dart';
import 'package:flutter_http_architecture/src/features/http_workbench/presentation/providers/http_advanced_notifier.dart';
import 'package:flutter_http_architecture/src/features/http_workbench/presentation/providers/http_mode_notifier.dart';
import 'package:flutter_http_architecture/src/features/http_workbench/presentation/providers/http_simple_notifier.dart';
import 'package:flutter_http_architecture/src/features/http_workbench/presentation/viewmodels/http_advanced_state.dart';
import 'package:flutter_http_architecture/src/features/http_workbench/presentation/viewmodels/http_advanced_view_model.dart';
import 'package:flutter_http_architecture/src/features/http_workbench/presentation/viewmodels/http_simple_view_model.dart';
import 'package:flutter_http_architecture/src/features/http_workbench/presentation/viewmodels/http_simple_view_state.dart';

final httpTesterServiceProvider = Provider<HttpTesterService>((ref) {
  final client = ref.watch(httpBinClientProvider);

  return HttpTesterService(client);
});

final httpSimpleViewModelProvider = Provider<HttpSimpleViewModel>((ref) {
  final repository = ref.watch(httpTesterServiceProvider);

  return HttpSimpleViewModel(repository);
});

final httpSimpleNotifierProvider =
    AsyncNotifierProvider.autoDispose<HttpSimpleNotifier, HttpSimpleViewState>(
      HttpSimpleNotifier.new,
    );

final httpModeProvider = NotifierProvider<HttpModeNotifier, HttpMode>(
  HttpModeNotifier.new,
);

final httpWorkbenchServiceProvider = Provider.autoDispose<HttpAdvancedService>((
  ref,
) {
  final client = ref.watch(httpClientProvider);

  return HttpAdvancedService(client);
});

final httpAdvancedViewModelProvider =
    Provider.autoDispose<HttpAdvancedViewModel>((ref) {
      final service = ref.watch(httpWorkbenchServiceProvider);

      return HttpAdvancedViewModel(service);
    });

final httpAdvancedProvider =
    AsyncNotifierProvider<HttpAdvancedNotifier, HttpAdvancedState>(
      HttpAdvancedNotifier.new,
    );
