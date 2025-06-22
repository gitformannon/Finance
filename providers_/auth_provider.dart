import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';

enum AuthStatus { unauthenticated, authenticated }

class AuthState {
  final AuthStatus status;
  const AuthState({required this.status});
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState(status: AuthStatus.unauthenticated));

  Future<void> login(String user, String pass) async {
    final ok = await AuthService.login(user, pass);
    if (ok) {
      state = const AuthState(status: AuthStatus.authenticated);
    }
  }

  void logout() {
    AuthService.logout();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
