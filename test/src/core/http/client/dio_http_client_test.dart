import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_http_architecture/src/core/http/client/dio_http_client.dart';
import 'package:flutter_http_architecture/src/core/http/config/network_config.dart';

void main() {
  test('GET request returns mocked response via interceptor', () async {
    final dio = Dio(BaseOptions(baseUrl: 'https://api.test.com'));

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          handler.resolve(
            Response(
              requestOptions: options,
              statusCode: 200,
              data: {'message': 'success'},
            ),
          );
        },
      ),
    );

    final client = DioHttpClient(
      config: const NetworkConfig(baseUrl: 'https://api.test.com'),
      dio: dio,
    );

    final response = await client.get('/test');

    expect(response.statusCode, 200);
  });

  test('POST request returns mocked creation response', () async {
    final dio = Dio(BaseOptions(baseUrl: 'https://api.test.com'));

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          handler.resolve(
            Response(
              requestOptions: options,
              statusCode: 201,
              data: {'status': 'created'},
            ),
          );
        },
      ),
    );

    final client = DioHttpClient(
      config: const NetworkConfig(baseUrl: 'https://api.test.com'),
      dio: dio,
    );

    final response = await client.post('/create', data: {'name': 'test'});

    expect(response.statusCode, 201);
  });
}
