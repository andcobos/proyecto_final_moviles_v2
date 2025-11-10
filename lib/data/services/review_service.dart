import '../../core/constants.dart';
import '../models/review.dart';
import 'api_service.dart';

/// Review Service
/// Handles creating reviews for completed jobs
class ReviewService {
  final ApiService _api = ApiService();

  /// Create a review (CLIENT only)
  /// Can only review completed jobs
  /// One review per job
  Future<Review> createReview(CreateReviewRequest request) async {
    // Validate rating
    if (!request.isValid) {
      throw Exception('Rating must be between 1 and 5');
    }

    final response = await _api.post(
      ApiConstants.reviews,
      request.toJson(),
    );

    return Review.fromJson(response as Map<String, dynamic>);
  }
}
