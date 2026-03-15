import 'package:dio/dio.dart';

import 'package:flutter_http_architecture/src/core/http/api_response.dart';

class RequestExecutor {
  Future<ApiResponse<T?>> execute<T>(
    Future<Response<T?>> Function() request,
  ) async {
    try {
      final response = await request();

      return ApiResponse<T?>(
        data: response.data,
        statusCode: response.statusCode,
        headers: response.headers.map,
      );
    } on DioException catch (err, stack) {
      return ApiResponse<T?>(
        data: null,
        statusCode: err.response?.statusCode,
        headers: err.response?.headers.map,
        errorMessage: err.message,
        stackTrace: stack,
      );
    } catch (err, stack) {
      return ApiResponse<T?>(
        data: null,
        errorMessage: err.toString(),
        stackTrace: stack,
      );
    }
  }
}
