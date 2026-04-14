abstract class HttpCancelToken {
  bool get isCancelled;

  void cancel([String? reason]);
}
