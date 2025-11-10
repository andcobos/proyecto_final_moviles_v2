/// Review Model
/// Represents a review left by a client for a contractor on a completed job
class Review {
  final String id;
  final int rating; // 1-5
  final String comment;
  final DateTime createdAt;
  final String jobId;
  final String clientId;
  final String contractorId;

  Review({
    required this.id,
    required this.rating,
    required this.comment,
    required this.createdAt,
    required this.jobId,
    required this.clientId,
    required this.contractorId,
  });

  /// Create Review from JSON response
  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] as String,
      rating: json['rating'] as int,
      comment: json['comment'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      jobId: json['jobId'] as String,
      clientId: json['clientId'] as String,
      contractorId: json['contractorId'] as String,
    );
  }

  /// Convert Review to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt.toIso8601String(),
      'jobId': jobId,
      'clientId': clientId,
      'contractorId': contractorId,
    };
  }

  /// Create a copy with updated fields
  Review copyWith({
    String? id,
    int? rating,
    String? comment,
    DateTime? createdAt,
    String? jobId,
    String? clientId,
    String? contractorId,
  }) {
    return Review(
      id: id ?? this.id,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      createdAt: createdAt ?? this.createdAt,
      jobId: jobId ?? this.jobId,
      clientId: clientId ?? this.clientId,
      contractorId: contractorId ?? this.contractorId,
    );
  }
}

/// Create Review Request Model
class CreateReviewRequest {
  final int rating;
  final String comment;
  final String jobId;

  CreateReviewRequest({
    required this.rating,
    required this.comment,
    required this.jobId,
  });

  Map<String, dynamic> toJson() {
    return {
      'rating': rating,
      'comment': comment,
      'jobId': jobId,
    };
  }

  /// Validate rating is between 1-5
  bool get isValid => rating >= 1 && rating <= 5;
}
