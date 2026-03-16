import 'package:flutter_http_architecture/src/core/http/http_client.dart';

import 'package:flutter_http_architecture/src/shared/models/user_model.dart';

class UserRepository {
  final HttpClient _httpClient;

  UserRepository({required HttpClient httpClient}) : _httpClient = httpClient;

  Future<List<UserModel>> getUsers() async {
    final response = await _httpClient.get<Map<String, dynamic>>('/users');

    if (response.data == null || response.data!['users'] == null) {
      return <UserModel>[];
    }

    final data = response.data!['users'] as List;

    return data.map((json) => UserModel.fromJson(json)).toList();
  }

  Future<UserModel?> getUserById(int id) async {
    final response = await _httpClient.get<Map<String, dynamic>>('/users/$id');

    if (response.data == null) return null;

    return UserModel.fromJson(response.data!['data']);
  }
}
