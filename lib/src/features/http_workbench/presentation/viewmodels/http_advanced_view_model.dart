import 'dart:convert';

import 'package:flutter_http_architecture/src/core/http/models/api_response.dart';

import 'package:flutter_http_architecture/src/features/http_workbench/data/services/http_advanced_service.dart';
import 'package:flutter_http_architecture/src/features/http_workbench/presentation/viewmodels/http_advanced_state.dart';

class HttpAdvancedViewModel {
  final HttpAdvancedService _service;

  HttpAdvancedViewModel(this._service);

  Future<ApiResponse<dynamic>> execute(HttpAdvancedState state) async {
    final headers = {
      for (var e in state.headers)
        if (e.key.isNotEmpty) e.key: e.value,
    };

    final params = {
      for (var e in state.queryParams)
        if (e.key.isNotEmpty) e.key: e.value,
    };

    dynamic bodyData;
    if (state.body.isNotEmpty) {
      try {
        bodyData = jsonDecode(state.body);
      } catch (_) {
        bodyData = state.body;
      }
    }

    return _service.request<dynamic>(
      method: state.method,
      url: state.url,
      headers: headers,
      queryParameters: params,
      body: bodyData,
      maxRetries: state.maxRetries,
    );
  }
}
