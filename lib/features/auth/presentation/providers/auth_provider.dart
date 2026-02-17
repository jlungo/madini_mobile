import 'package:flutter/foundation.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

enum AuthStatus {
  initial,
  authenticated,
  unauthenticated,
  loading,
  failure,
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

  Future<void> login(String email, String password) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    final result = await _authRepository.login(email, password);

    result.fold(
      (failure) {
        _status = AuthStatus.failure;
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
    debugPrint('[AuthProvider] checkAuthStatus started');
    try {
      final user = await _authRepository.getCurrentUser();
      debugPrint('[AuthProvider] getCurrentUser returned: ${user?.email}');
      if (user != null) {
        _user = user;
        _status = AuthStatus.authenticated;
      } else {
        _status = AuthStatus.unauthenticated;
      }
    } catch (e) {
      debugPrint('[AuthProvider] Error in checkAuthStatus: $e');
      _status = AuthStatus.failure;
      _errorMessage = e.toString();
    }
    debugPrint('[AuthProvider] checkAuthStatus finished with status: $_status');
    notifyListeners();
  }
}
