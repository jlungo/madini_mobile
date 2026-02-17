import 'user.dart';

/// Session info: tokens and user for display (plan §4.2).
class Session {
  final String accessToken;
  final String? refreshToken;
  final DateTime? expiresAt;
  final User user;

  const Session({
    required this.accessToken,
    this.refreshToken,
    this.expiresAt,
    required this.user,
  });

  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }
}
