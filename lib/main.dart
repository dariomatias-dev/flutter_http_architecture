import 'package:flutter/material.dart';
import 'package:flutter_http_architecture/src/app_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(ProviderScope(overrides: [], child: AppWidget()));
}
