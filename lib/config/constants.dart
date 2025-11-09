/// API Configuration Constants
class ApiConstants {
  // Base URL for the API
  // Change this to your actual backend URL
  // For Android Emulator use: http://10.0.2.2:3000
  // For iOS Simulator use: http://localhost:3000
  // For physical device use: http://YOUR_COMPUTER_IP:3000
  static const String baseUrl = 'http://localhost:3000';

  // API Endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String userProfile = '/users/me';
  static const String updateServices = '/users/me/services';
  static const String contractors = '/workers';
  static const String jobs = '/jobs';
  static const String reviews = '/reviews';

  // Helper method to get contractor by ID
  static String contractorById(String id) => '/workers/$id';

  // Helper methods for job actions
  static String acceptJob(String id) => '/jobs/$id/accept';
  static String completeJob(String id) => '/jobs/$id/complete';
  static String cancelJob(String id) => '/jobs/$id/cancel';
}

/// App-wide constants
class AppConstants {
  static const String appName = 'Fixea';
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String roleKey = 'user_role';
}
