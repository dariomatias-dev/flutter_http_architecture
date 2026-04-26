import 'package:flutter_riverpod/flutter_riverpod.dart';

enum HttpMode { simple, advanced }

class HttpModeNotifier extends Notifier<HttpMode> {
  @override
  HttpMode build() => HttpMode.simple;

  void toggle() {
    state = state == HttpMode.simple ? HttpMode.advanced : HttpMode.simple;
  }
}
