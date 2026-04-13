import 'package:dio/dio.dart';

import 'package:flutter_http_architecture/src/core/http/multipart/http_multipart.dart';

class DioHttpMultipart implements HttpMultipart {
  final FormData _data;

  DioHttpMultipart(this._data);

  @override
  FormData get raw => _data;
}
