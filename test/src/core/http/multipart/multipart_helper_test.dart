import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_http_architecture/src/core/http/multipart/multipart_helper.dart';

void main() {
  test('converts File to multipart', () async {
    final file = File('test_file.txt');
    await file.writeAsString('hello');

    final result = await MultipartHelper.fromMap({'file': file});

    expect(result.raw, isNotNull);

    await file.delete();
  });

  test('handles list of files', () async {
    final file1 = File('file1.txt');
    final file2 = File('file2.txt');

    await file1.writeAsString('a');
    await file2.writeAsString('b');

    final result = await MultipartHelper.fromMap({
      'files': [file1, file2],
    });

    expect(result.raw, isNotNull);

    await file1.delete();
    await file2.delete();
  });

  test('handles Uint8List', () async {
    final bytes = Uint8List.fromList([1, 2, 3]);

    final result = await MultipartHelper.fromMap({'data': bytes});

    expect(result.raw, isNotNull);
  });
}
