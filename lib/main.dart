import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'package:flutter_http_architecture/src/app_widget.dart';

import 'package:flutter_http_architecture/src/core/constants/api_urls.dart';
import 'package:flutter_http_architecture/src/core/http/client/dio_http_client.dart';
import 'package:flutter_http_architecture/src/core/http/config/network_config.dart';

import 'package:flutter_http_architecture/src/data/repositories/http_bin_repository.dart';

void main() {
  runApp(
    MultiProvider(
      providers: <SingleChildWidget>[
        Provider(
          create: (_) {
            return HttpBinRepository(
              httpClient: DioHttpClient(
                config: NetworkConfig(baseUrl: ApiUrls.httpbin),
              ),
            );
          },
        ),
      ],
      child: AppWidget(),
    ),
  );
}
