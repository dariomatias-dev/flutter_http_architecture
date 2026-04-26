import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_http_architecture/src/core/constants/api_urls.dart';
import 'package:flutter_http_architecture/src/core/http/client/dio_http_client.dart';
import 'package:flutter_http_architecture/src/core/http/client/http_client.dart';
import 'package:flutter_http_architecture/src/core/http/config/network_config.dart';

final httpBinClientProvider = Provider<HttpClient>((ref) {
  return DioHttpClient(
    config: const NetworkConfig(
      baseUrl: ApiUrls.httpbin,
      connectTimeout: Duration(seconds: 15),
      receiveTimeout: Duration(seconds: 15),
    ),
  );
});

final httpClientProvider = Provider<HttpClient>((ref) {
  return DioHttpClient(config: const NetworkConfig());
});
