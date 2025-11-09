import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

/// Auth State
class AuthState {
  final User? user;
  final bool isAuthenticated;
  final bool isLoading;
  final String? error;

  AuthState({
    this.user,
    this.isAuthenticated = false,
    this.isLoading = false,
    this.error,
  });

  AuthState copyWith({
    User? user,
    bool? isAuthenticated,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      user: user ?? this.user,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  /// Helper to check if user is a client
  bool get isClient => user?.isClient ?? false;

  /// Helper to check if user is a contractor
  bool get isContractor => user?.isContractor ?? false;
}

/// Auth Notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService = AuthService();

  AuthNotifier() : super(AuthState()) {
    _init();
  }

  /// Initialize - check if user is already logged in
  Future<void> _init() async {
    state = state.copyWith(isLoading: true);

    try {
      final isLoggedIn = await _authService.isLoggedIn();
      if (isLoggedIn) {
        final user = await _authService.getStoredUser();
        if (user != null) {
          state = AuthState(
            user: user,
            isAuthenticated: true,
            isLoading: false,
          );
          return;
        }
      }
    } catch (e) {
      // If there's an error loading stored data, just continue as logged out
    }

    state = AuthState(isLoading: false);
  }

  /// Login
  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final user = await _authService.login(email, password);
      state = AuthState(
        user: user,
        isAuthenticated: true,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      rethrow;
    }
  }

  /// Register
  Future<void> register(RegisterRequest request) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Register and login
      final user = await _authService.registerAndLogin(request);
      state = AuthState(
        user: user,
        isAuthenticated: true,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      rethrow;
    }
  }

  /// Logout
  Future<void> logout() async {
    await _authService.logout();
    state = AuthState();
  }

  /// Refresh user data
  Future<void> refreshUser() async {
    if (!state.isAuthenticated) return;

    try {
      final user = await _authService.getCurrentUser();
      state = state.copyWith(user: user);
    } catch (e) {
      // If refresh fails, keep current state
    }
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// Auth Provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

/// Convenience providers for common checks
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isAuthenticated;
});

final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authProvider).user;
});

final isClientProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isClient;
});

final isContractorProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isContractor;
});
