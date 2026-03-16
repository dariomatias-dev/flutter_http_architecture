import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'package:flutter_http_architecture/src/app_widget.dart';

import 'package:flutter_http_architecture/src/core/constants/api_urls.dart';
import 'package:flutter_http_architecture/src/core/http/dio_http_client.dart';
import 'package:flutter_http_architecture/src/core/http/network_config.dart';

import 'package:flutter_http_architecture/src/data/repositories/auth_repository.dart';
import 'package:flutter_http_architecture/src/data/repositories/user_repository.dart';

void main() {
  runApp(
    MultiProvider(
      providers: <SingleChildWidget>[
        Provider(
          create: (_) {
            return AuthRepository(
              httpClient: DioHttpClient(
                config: NetworkConfig(baseUrl: ApiUrls.dummyjson),
              ),
            );
          },
        ),
        Provider(
          create: (_) {
            return UserRepository(
              httpClient: DioHttpClient(
                config: NetworkConfig(baseUrl: ApiUrls.dummyjson),
              ),
            );
          },
        ),
      ],
      child: const AppWidget(),
    ),
  );
}
