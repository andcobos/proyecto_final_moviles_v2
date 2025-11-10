import 'user.dart';
import 'service.dart';
import 'review.dart';

/// Contractor Model
/// Extended user model with services and reviews
class Contractor {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String role;
  final List<Service> services;
  final List<Review> reviews;

  Contractor({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.services,
    required this.reviews,
  });

  /// Create Contractor from JSON response
  factory Contractor.fromJson(Map<String, dynamic> json) {
    return Contractor(
      id: json['id'] as String,
      email: json['email'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      role: json['role'] as String,
      services: (json['services'] as List<dynamic>?)
              ?.map((s) => Service.fromJson(s as Map<String, dynamic>))
              .toList() ??
          [],
      reviews: (json['reviewsAsContractor'] as List<dynamic>?)
              ?.map((r) => Review.fromJson(r as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  /// Convert Contractor to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'role': role,
      'services': services.map((s) => s.toJson()).toList(),
      'reviewsAsContractor': reviews.map((r) => r.toJson()).toList(),
    };
  }

  /// Get full name
  String get fullName => '$firstName $lastName';

  /// Calculate average rating from reviews
  double get averageRating {
    if (reviews.isEmpty) return 0.0;
    final total = reviews.fold<int>(0, (sum, review) => sum + review.rating);
    return total / reviews.length;
  }

  /// Get number of reviews
  int get reviewCount => reviews.length;

  /// Convert to basic User model
  User toUser() {
    return User(
      id: id,
      email: email,
      firstName: firstName,
      lastName: lastName,
      role: role,
    );
  }

  /// Create a copy with updated fields
  Contractor copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    String? role,
    List<Service>? services,
    List<Review>? reviews,
  }) {
    return Contractor(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      role: role ?? this.role,
      services: services ?? this.services,
      reviews: reviews ?? this.reviews,
    );
  }
}
