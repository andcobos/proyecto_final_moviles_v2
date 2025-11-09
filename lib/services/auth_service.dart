import '../config/constants.dart';
import '../models/user.dart';
import 'api_service.dart';
import 'storage_service.dart';

/// Authentication Service
/// Handles login, registration, and user profile operations
class AuthService {
  final ApiService _api = ApiService();
  final StorageService _storage = StorageService.instance;

  /// Login user
  /// Returns the authenticated user
  Future<User> login(String email, String password) async {
    final data = {
      'email': email,
      'password': password,
    };

    final response = await _api.post(
      ApiConstants.login,
      data,
      includeAuth: false,
    );

    // Save token
    final authResponse = AuthResponse.fromJson(response);
    await _storage.saveToken(authResponse.accessToken);

    // Get user profile
    final user = await getCurrentUser();
    await _storage.saveUser(user);
    await _storage.saveRole(user.role);

    return user;
  }

  /// Register new user
  /// Returns the created user
  Future<User> register(RegisterRequest request) async {
    final response = await _api.post(
      ApiConstants.register,
      request.toJson(),
      includeAuth: false,
    );

    // Parse user from response
    final user = User.fromJson(response);

    // Note: Registration doesn't return a token, so we need to login after
    return user;
  }

  /// Register and login in one step
  Future<User> registerAndLogin(RegisterRequest request) async {
    // First register
    await register(request);

    // Then login
    return await login(request.email, request.password);
  }

  /// Get current user profile
  Future<User> getCurrentUser() async {
    final response = await _api.get(ApiConstants.userProfile);
    return User.fromJson(response);
  }

  /// Update contractor services
  /// Only for CONTRACTOR role
  Future<List<Map<String, dynamic>>> updateServices(
      List<Map<String, dynamic>> services) async {
    final data = {'services': services};

    final response = await _api.patch(
      ApiConstants.updateServices,
      data,
    );

    return List<Map<String, dynamic>>.from(response);
  }

  /// Logout user
  Future<void> logout() async {
    await _storage.clearAll();
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    return await _storage.isLoggedIn();
  }

  /// Get stored user
  Future<User?> getStoredUser() async {
    return await _storage.getUser();
  }

  /// Get stored token
  Future<String?> getStoredToken() async {
    return await _storage.getToken();
  }

  /// Get stored role
  Future<String?> getStoredRole() async {
    return await _storage.getRole();
  }
}
