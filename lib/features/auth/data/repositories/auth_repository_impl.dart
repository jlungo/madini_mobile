import 'package:dartz/dartz.dart';

import '../../../../core/security/jwt_decoder.dart';
import '../../../../services/storage_service.dart';
import '../../domain/entities/session.dart';
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
      final response = await remoteDataSource.login(email, password);
      await storageService.saveTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );
      final user = _userFromToken(response.accessToken);
      return Right(user);
    } on AuthException catch (e) {
      return Left(e.message);
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
    return storageService.readAccessToken();
  }

  @override
  Future<User?> getCurrentUser() async {
    final token = await getAccessToken();
    if (token == null || token.isEmpty) return null;
    if (JwtDecoder.isExpired(token)) return null;
    try {
      return _userFromToken(token);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<Session?> getSession() async {
    final token = await getAccessToken();
    if (token == null || token.isEmpty || JwtDecoder.isExpired(token)) {
      return null;
    }
    try {
      final user = _userFromToken(token);
      final expiresAt = JwtDecoder.getExpiry(token);
      return Session(
        accessToken: token,
        refreshToken: await storageService.readRefreshToken(),
        expiresAt: expiresAt,
        user: user,
      );
    } catch (_) {
      return null;
    }
  }

  User _userFromToken(String token) {
    final payload = JwtDecoder.decodePayload(token);
    return UserModel.fromJson(payload);
  }
}
