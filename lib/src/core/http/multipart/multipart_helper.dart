import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';

import 'package:flutter_http_architecture/src/core/http/multipart/dio_http_multipart.dart';
import 'package:flutter_http_architecture/src/core/http/multipart/http_multipart.dart';

class MultipartHelper {
  static Future<HttpMultipart> fromMap(Map<String, dynamic> data) async {
    final map = <String, dynamic>{};

    for (final entry in data.entries) {
      final value = entry.value;

      if (value is File) {
        map[entry.key] = await MultipartFile.fromFile(value.path);
      } else if (value is List<File>) {
        map[entry.key] = await Future.wait(
          value.map((file) => MultipartFile.fromFile(file.path)),
        );
      } else if (value is Uint8List) {
        map[entry.key] = MultipartFile.fromBytes(value);
      } else if (value is String && File(value).existsSync()) {
        map[entry.key] = await MultipartFile.fromFile(value);
      } else {
        map[entry.key] = value;
      }
    }

    return DioHttpMultipart(FormData.fromMap(map));
  }
}
