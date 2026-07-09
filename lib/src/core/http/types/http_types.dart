typedef ProgressCallbackHttp = void Function(int count, int total);

abstract class HttpCancelToken {
  bool get isCancelled;

  void cancel([String? reason]);
}
