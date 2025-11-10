import '../config/constants.dart';
import '../models/contractor.dart';
import 'api_service.dart';

/// Contractor Service
/// Handles browsing contractors and their services
class ContractorService {
  final ApiService _api = ApiService();

  /// Get all contractors
  /// Public endpoint - no auth required
  Future<List<Contractor>> getAllContractors() async {
    final response = await _api.get(
      ApiConstants.contractors,
      includeAuth: false,
    );

    return (response as List)
        .map((json) => Contractor.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Get contractor by ID
  /// Public endpoint - no auth required
  Future<Contractor?> getContractorById(String id) async {
    final response = await _api.get(
      ApiConstants.contractorById(id),
      includeAuth: false,
    );

    if (response == null) return null;

    return Contractor.fromJson(response as Map<String, dynamic>);
  }

  /// Search contractors by service name
  /// Client-side filtering since API doesn't support search
  Future<List<Contractor>> searchContractorsByService(String serviceName) async {
    final contractors = await getAllContractors();

    if (serviceName.isEmpty) return contractors;

    return contractors.where((contractor) {
      return contractor.services.any((service) =>
          service.name.toLowerCase().contains(serviceName.toLowerCase()));
    }).toList();
  }

  /// Filter contractors by minimum rating
  Future<List<Contractor>> filterByRating(double minRating) async {
    final contractors = await getAllContractors();

    return contractors
        .where((contractor) => contractor.averageRating >= minRating)
        .toList();
  }

  /// Get contractors sorted by rating (highest first)
  Future<List<Contractor>> getContractorsSortedByRating() async {
    final contractors = await getAllContractors();

    contractors.sort((a, b) => b.averageRating.compareTo(a.averageRating));

    return contractors;
  }
}
