import 'package:dio/dio.dart';

import 'package:flutter_http_architecture/src/core/http/multipart/http_multipart.dart';

class DioMultipart implements HttpMultipart {
  final FormData _data;

  DioMultipart(this._data);

  @override
  FormData get raw => _data;
}
