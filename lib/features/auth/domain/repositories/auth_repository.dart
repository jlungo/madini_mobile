import 'package:dartz/dartz.dart';

import '../entities/session.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<String, User>> login(String email, String password);
  Future<void> logout();
  Future<User?> getCurrentUser();
  Future<Session?> getSession();
  Future<String?> getAccessToken();
}
