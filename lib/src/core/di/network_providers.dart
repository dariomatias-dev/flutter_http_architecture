import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_http_architecture/src/core/constants/api_urls.dart';
import 'package:flutter_http_architecture/src/core/http/client/dio_http_client.dart';
import 'package:flutter_http_architecture/src/core/http/client/http_client.dart';
import 'package:flutter_http_architecture/src/core/http/config/network_config.dart';

final networkConfigProvider = Provider<NetworkConfig>((ref) {
  return const NetworkConfig(
    baseUrl: ApiUrls.httpbin,
    connectTimeout: Duration(seconds: 15),
    receiveTimeout: Duration(seconds: 15),
  );
});

final httpBinClientProvider = Provider<HttpClient>((ref) {
  final config = ref.watch(networkConfigProvider);

  return DioHttpClient(config: config);
});
