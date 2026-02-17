/// Response DTO for POST /api/v1/auth/login/ (Keycloak token response).
class LoginResponse {
  final String accessToken;
  final String? refreshToken;
  final int? expiresIn;
  final int? refreshExpiresIn;
  final String? tokenType;
  final String? scope;

  const LoginResponse({
    required this.accessToken,
    this.refreshToken,
    this.expiresIn,
    this.refreshExpiresIn,
    this.tokenType,
    this.scope,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String?,
      expiresIn: json['expires_in'] as int?,
      refreshExpiresIn: json['refresh_expires_in'] as int?,
      tokenType: json['token_type'] as String?,
      scope: json['scope'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'access_token': accessToken,
        'refresh_token': refreshToken,
        'expires_in': expiresIn,
        'refresh_expires_in': refreshExpiresIn,
        'token_type': tokenType,
        'scope': scope,
      };
}
