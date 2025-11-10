/// API Configuration Constants
class ApiConstants {
  // Base URL for the API
  // Cambia esto según tu entorno:
  // Android Emulator: http://10.0.2.2:3000
  // iOS Simulator: http://localhost:3000
  // Dispositivo físico: http://TU_IP_LOCAL:3000
  static const String baseUrl = 'http://localhost:3000';

  // API Endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String userProfile = '/users/me';
  static const String updateServices = '/users/me/services';
  static const String contractors = '/workers';
  static const String jobs = '/jobs';
  static const String reviews = '/reviews';
  static const String services = '/workers';


  // Helper methods
  static String contractorById(String id) => '/workers/$id';
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
