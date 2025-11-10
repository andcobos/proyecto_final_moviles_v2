import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../core/constants.dart';
import '../models/user.dart';

/// Storage Service
/// Handles local storage of authentication tokens and user data
class StorageService {
  static StorageService? _instance;
  SharedPreferences? _prefs;

  StorageService._();

  /// Get singleton instance
  static StorageService get instance {
    _instance ??= StorageService._();
    return _instance!;
  }

  /// Initialize shared preferences
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// Ensure preferences are initialized
  Future<SharedPreferences> get _preferences async {
    if (_prefs == null) {
      await init();
    }
    return _prefs!;
  }

  /// Save authentication token
  Future<void> saveToken(String token) async {
    final prefs = await _preferences;
    await prefs.setString(AppConstants.tokenKey, token);
  }

  /// Get authentication token
  Future<String?> getToken() async {
    final prefs = await _preferences;
    return prefs.getString(AppConstants.tokenKey);
  }

  /// Remove authentication token
  Future<void> removeToken() async {
    final prefs = await _preferences;
    await prefs.remove(AppConstants.tokenKey);
  }

  /// Save user data
  Future<void> saveUser(User user) async {
    final prefs = await _preferences;
    final userJson = jsonEncode(user.toJson());
    await prefs.setString(AppConstants.userKey, userJson);
  }

  /// Get user data
  Future<User?> getUser() async {
    final prefs = await _preferences;
    final userJson = prefs.getString(AppConstants.userKey);
    if (userJson == null) return null;

    try {
      final userData = jsonDecode(userJson) as Map<String, dynamic>;
      return User.fromJson(userData);
    } catch (e) {
      return null;
    }
  }

  /// Remove user data
  Future<void> removeUser() async {
    final prefs = await _preferences;
    await prefs.remove(AppConstants.userKey);
  }

  /// Save user role
  Future<void> saveRole(String role) async {
    final prefs = await _preferences;
    await prefs.setString(AppConstants.roleKey, role);
  }

  /// Get user role
  Future<String?> getRole() async {
    final prefs = await _preferences;
    return prefs.getString(AppConstants.roleKey);
  }

  /// Remove user role
  Future<void> removeRole() async {
    final prefs = await _preferences;
    await prefs.remove(AppConstants.roleKey);
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  /// Clear all stored data (logout)
  Future<void> clearAll() async {
    final prefs = await _preferences;
    await prefs.remove(AppConstants.tokenKey);
    await prefs.remove(AppConstants.userKey);
    await prefs.remove(AppConstants.roleKey);
  }
}
