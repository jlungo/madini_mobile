import 'package:flutter/foundation.dart';
import '../../domain/entities/permission.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

enum AuthStatus {
  initial,
  unauthenticated,
  authenticating,
  authenticated,
  sessionExpired,
  error,
}

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository;

  AuthStatus _status = AuthStatus.initial;
  User? _user;
  String? _errorMessage;

  AuthProvider({required AuthRepository authRepository}) : _authRepository = authRepository;

  AuthStatus get status => _status;
  User? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  /// Plan §5: read-only selectors.
  User? get currentUser => _user;

  bool hasPermission(Permission permission) =>
      _user?.hasPermission(permission.raw) ?? false;

  bool hasAny(Iterable<Permission> permissions) =>
      _user != null &&
      permissions.any((p) => _user!.hasPermission(p.raw));

  bool hasAll(Iterable<Permission> permissions) =>
      _user != null &&
      permissions.every((p) => _user!.hasPermission(p.raw));

  Future<void> login(String email, String password) async {
    _status = AuthStatus.authenticating;
    _errorMessage = null;
    notifyListeners();

    final result = await _authRepository.login(email, password);

    result.fold(
      (failure) {
        _status = AuthStatus.error;
        _errorMessage = failure;
        notifyListeners();
      },
      (user) {
        _user = user;
        _status = AuthStatus.authenticated;
        notifyListeners();
      },
    );
  }

  Future<void> logout() async {
    await _authRepository.logout();
    _user = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  Future<void> checkAuthStatus() async {
    try {
      final user = await _authRepository.getCurrentUser();
      if (user != null) {
        _user = user;
        _status = AuthStatus.authenticated;
      } else {
        final token = await _authRepository.getAccessToken();
        if (token != null && token.isNotEmpty) {
          _status = AuthStatus.sessionExpired;
          _errorMessage = 'Session expired';
          await _authRepository.logout();
          _user = null;
        } else {
          _status = AuthStatus.unauthenticated;
        }
      }
    } catch (_) {
      _status = AuthStatus.error;
      _errorMessage = 'Failed to restore session';
    }
    notifyListeners();
  }
}
