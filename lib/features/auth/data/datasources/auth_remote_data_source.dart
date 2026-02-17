import 'package:dio/dio.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/network/api_client.dart';
import '../models/login_response.dart';

const String _loginPath = '/auth/login/';

abstract class AuthRemoteDataSource {
  Future<LoginResponse> login(String username, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;
  final AppConfig config;

  AuthRemoteDataSourceImpl({
    required this.apiClient,
    required this.config,
  });

  @override
  Future<LoginResponse> login(String username, String password) async {
    final url = '${config.apiBaseUrl}$_loginPath';
    final payload = <String, String>{
      'username': username,
      'password': password,
    };

    try {
      final response = await apiClient.post(
        url,
        data: payload,
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data is Map<String, dynamic>
            ? response.data as Map<String, dynamic>
            : Map<String, dynamic>.from(response.data as Map);
        final loginResponse = LoginResponse.fromJson(data);
        if (loginResponse.accessToken.isEmpty) {
          throw AuthException('No access token received');
        }
        return loginResponse;
      }

      throw AuthException(
        _extractMessage(response.data) ?? 'Login failed',
      );
    } on DioException catch (e) {
      if (e.response != null) {
        final statusCode = e.response!.statusCode;
        final message = _extractMessage(e.response!.data) ?? e.message ?? 'Login failed';
        if (statusCode == 401) {
          throw AuthException('Invalid credentials');
        }
        if (statusCode == 400) {
          throw AuthException(message);
        }
        throw AuthException(message);
      }
      throw AuthException(e.message ?? 'Network error');
    }
  }

  static String? _extractMessage(dynamic data) {
    if (data == null) return null;
    if (data is Map<String, dynamic> && data.containsKey('detail')) {
      final d = data['detail'];
      return d is String ? d : d?.toString();
    }
    return null;
  }
}

/// Thrown when login or token operations fail.
class AuthException implements Exception {
  final String message;
  AuthException(this.message);
  @override
  String toString() => message;
}
