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

  static List<String> _splitWords(String key) {
    final words = <String>[];
    final buffer = StringBuffer();

    for (final unit in key.codeUnits) {
      final isAlphaNumeric =
          (unit >= 0x30 && unit <= 0x39) || (unit >= 0x61 && unit <= 0x7a);

      if (isAlphaNumeric) {
        buffer.writeCharCode(unit);
      } else if (buffer.isNotEmpty) {
        words.add(buffer.toString());
        buffer.clear();
      }
    }

    if (buffer.isNotEmpty) {
      words.add(buffer.toString());
    }

    return words;
  }

  static dynamic sanitize(dynamic value) {
    if (value is Map) {
      final result = <String, dynamic>{};

      value.forEach((key, val) {
        final safeKey = key.toString();
        final lowerKey = safeKey.toLowerCase();

        final words = _splitWords(lowerKey);
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
