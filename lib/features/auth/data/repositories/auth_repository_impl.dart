import 'dart:convert';

import 'package:dartz/dartz.dart';

import '../../../../services/storage_service.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final StorageService storageService;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.storageService,
  });

  @override
  Future<Either<String, User>> login(String email, String password) async {
    try {
      final data = await remoteDataSource.login(email, password);
      final accessToken = data['access_token'];
      final refreshToken =
          data['refresh_token']; // Keycloak specific, check payload

      if (accessToken != null) {
        await storageService.saveTokens(
          accessToken: accessToken,
          refreshToken: refreshToken,
        );

        final user = _getUserFromToken(accessToken);
        return Right(user);
      } else {
        return const Left('No access token received');
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<void> logout() async {
    await storageService.clearTokens();
  }

  @override
  Future<String?> getAccessToken() async {
    return await storageService.readAccessToken();
  }

  @override
  Future<User?> getCurrentUser() async {
    print('[AuthRepository] getCurrentUser started');
    final token = await getAccessToken();
    print(
      '[AuthRepository] getAccessToken returned: ${token != null ? 'TOKEN_PRESENT' : 'NULL'}',
    );
    if (token != null) {
      try {
        // Simple expiry check could be added here
        final user = _getUserFromToken(token);
        print(
          '[AuthRepository] _getUserFromToken successful for: ${user.email}',
        );
        return user;
      } catch (e) {
        print('[AuthRepository] Error parsing token: $e');
        return null;
      }
    }
    return null;
  }

  User _getUserFromToken(String token) {
    Map<String, dynamic> payload = _parseJwt(token);
    return UserModel.fromJson(payload);
  }

  Map<String, dynamic> _parseJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('Invalid token');
    }
    final payload = _decodeBase64(parts[1]);
    final payloadMap = json.decode(payload);
    if (payloadMap is! Map<String, dynamic>) {
      throw Exception('Invalid payload');
    }
    return payloadMap;
  }

  String _decodeBase64(String str) {
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
        throw Exception('Illegal base64url string!"');
    }
    return utf8.decode(base64Url.decode(output));
  }
}
