import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_http_architecture/src/app_widget.dart';

import 'package:flutter_http_architecture/src/core/constants/api_urls.dart';
import 'package:flutter_http_architecture/src/core/http/dio_http_client.dart';
import 'package:flutter_http_architecture/src/core/http/network_config.dart';

import 'package:flutter_http_architecture/src/data/repositories/user_repository.dart';

void main() {
  runApp(
    Provider(
      create: (_) {
        return UserRepository(
          httpClient: DioHttpClient(
            config: NetworkConfig(baseUrl: ApiUrls.jsonplaceholder),
          ),
        );
      },
      child: const AppWidget(),
    ),
  );
}
