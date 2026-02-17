import 'dart:convert';

/// Decodes JWT payload; extracts exp and claims (plan §11 – jwt_decoder).
class JwtDecoder {
  /// Returns payload map or throws.
  static Map<String, dynamic> decodePayload(String token) {
    final parts = token.split('.');
    if (parts.length != 3) throw Exception('Invalid token');
    final payload = _decodeBase64Url(parts[1]);
    final decoded = json.decode(payload);
    if (decoded is! Map<String, dynamic>) throw Exception('Invalid payload');
    return decoded;
  }

  /// Expiry from `exp` claim (seconds since epoch). Returns null if missing.
  static DateTime? getExpiry(String token) {
    final payload = decodePayload(token);
    final exp = payload['exp'];
    if (exp == null) return null;
    if (exp is int) return DateTime.fromMillisecondsSinceEpoch(exp * 1000);
    return null;
  }

  /// True if token is expired or will expire in the next [buffer] (default 0).
  static bool isExpired(String token, [Duration buffer = Duration.zero]) {
    final exp = getExpiry(token);
    if (exp == null) return false;
    return DateTime.now().add(buffer).isAfter(exp);
  }

  static String _decodeBase64Url(String str) {
    String output = str.replaceAll('-', '+').replaceAll('_', '/');
    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += '==';
        break;
      case 3:
        output += '=';
        break;
      default:
        throw Exception('Illegal base64url string');
    }
    return utf8.decode(base64Url.decode(output));
  }
}
