import 'package:flutter_http_architecture/src/core/http/http_client.dart';

class AuthRepository {
  final HttpClient _httpClient;

  AuthRepository({required HttpClient httpClient}) : _httpClient = httpClient;

  Future<String?> login(String email, String password) async {
    final response = await _httpClient.post<Map<String, dynamic>>(
      '/auth/login',
      headers: {'Content-Type': 'application/json'},
      data: {'username': 'emilys', 'password': 'emilyspass'},
    );

    if (response.statusCode == 200) {
      return response.data?['accessToken'];
    }

    return null;
  }
}
