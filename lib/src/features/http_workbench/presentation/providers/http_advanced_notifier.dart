import 'package:flutter_http_architecture/src/features/http_workbench/domain/entities/http_advanced_item.dart';
import 'package:flutter_http_architecture/src/features/http_workbench/presentation/viewmodels/http_advanced_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HttpAdvancedNotifier extends Notifier<HttpAdvancedState> {
  @override
  HttpAdvancedState build() => HttpAdvancedState.initial();

  void updateMethod(String value) => state = state.copyWith(method: value);

  void updateUrl(String value) => state = state.copyWith(url: value);

  void addHeader() {
    state = state.copyWith(
      headers: <HttpAdvancedItem>[...state.headers, HttpAdvancedItem()],
    );
  }

  void removeHeader(String id) {
    state = state.copyWith(
      headers: state.headers.where((e) => e.id != id).toList(),
    );
  }

  void updateHeader(String id, {String? key, String? value}) {
    state = state.copyWith(
      headers: state.headers.map((e) {
        return e.id == id ? e.copyWith(key: key, value: value) : e;
      }).toList(),
    );
  }

  void addQueryParam() {
    state = state.copyWith(
      queryParams: <HttpAdvancedItem>[...state.queryParams, HttpAdvancedItem()],
    );
  }

  void removeQueryParam(String id) {
    state = state.copyWith(
      queryParams: state.queryParams.where((e) => e.id != id).toList(),
    );
  }

  void updateQueryParam(String id, {String? key, String? value}) {
    state = state.copyWith(
      queryParams: state.queryParams.map((e) {
        return e.id == id ? e.copyWith(key: key, value: value) : e;
      }).toList(),
    );
  }

  void updateRetries(int value) => state = state.copyWith(maxRetries: value);
}
