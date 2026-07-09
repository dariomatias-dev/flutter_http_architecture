class LogSanitizer {
  static const _sensitiveKeys = <String>{
    'password',
    'token',
    'access_token',
    'accesstoken',
    'refresh_token',
    'refreshtoken',
    'authorization',
    'cookie',
    'set-cookie',
    'jwt',
    'auth',
  };

  static dynamic sanitize(dynamic value) {
    if (value is Map) {
      final result = <String, dynamic>{};

      value.forEach((key, val) {
        final safeKey = key.toString();
        final lowerKey = safeKey.toLowerCase();

        final words = lowerKey.split(RegExp(r'[^a-z0-9]+'));
        final isSensitive = _sensitiveKeys.any(
          (k) => lowerKey == k || words.contains(k),
        );

        result[safeKey] = isSensitive ? '***' : sanitize(val);
      });

      return result;
    }

    if (value is List) {
      return value.map(sanitize).toList();
    }

    return value;
  }
}
