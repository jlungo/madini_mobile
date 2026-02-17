import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/network/api_client.dart';

abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> login(String email, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;
  final AppConfig config;

  AuthRemoteDataSourceImpl({
    required this.apiClient,
    required this.config,
  });

  @override
  Future<Map<String, dynamic>> login(String email, String password) async {
    // Mock login for development environment since backend URLs are placeholders
    if (config.env == AppEnvironment.dev) {
      if (email == 'admin@example.com' && password == 'password') {
        return _getMockTokenResponse('admin');
      } else if (email == 'librarian@example.com' && password == 'password') {
        return _getMockTokenResponse('librarian');
      } else if (email == 'user@example.com' && password == 'password') {
        return _getMockTokenResponse('user');
      }
    }

    final payload = {
      'grant_type': 'password',
      'client_id': 'madini-mobile',
      'username': email,
      'password': password,
    };

    final url = '${config.authBaseUrl}/protocol/openid-connect/token';

    try {
      final response = await apiClient.post(
        url,
        data: payload,
        options: Options(
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to login: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      // In dev, fall back to mock if network fails (e.g. invalid local URL)
      if (config.env == AppEnvironment.dev) {
        return _getMockTokenResponse(email.split('@')[0]);
      }
      throw Exception('Login failed: ${e.message}');
    }
  }

  Map<String, dynamic> _getMockTokenResponse(String username) {
    // Create a mock JWT payload
    final payload = {
      "sub": "mock-id-$username",
      "preferred_username": username,
      "email": "$username@example.com",
      "given_name": username.substring(0, 1).toUpperCase() + username.substring(1),
      "family_name": "Mock",
      "realm_access": {
        "roles": [username]
      },
      "permissions": username == 'admin' ? ["*:*:*:any"] : ["lab:sample:list", "museum:specimen:list"]
    };

    // Base64Url encode the payload
    final encodedPayload = base64Url.encode(utf8.encode(json.encode(payload))).replaceAll('=', '');
    
    // JWT format: header.payload.signature
    final mockToken = "header.$encodedPayload.signature";

    return {
      'access_token': mockToken,
      'refresh_token': 'mock_refresh_token',
      'expires_in': 3600,
    };
  }
}
