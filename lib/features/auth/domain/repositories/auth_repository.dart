import 'package:dartz/dartz.dart';
import '../../domain/entities/user.dart';

abstract class AuthRepository {
  Future<Either<String, User>> login(String email, String password);
  Future<void> logout();
  Future<User?> getCurrentUser();
  Future<String?> getAccessToken();
}
