import '../config/constants.dart';
import '../models/job.dart';
import 'api_service.dart';

/// Job Service
/// Handles job creation and management
class JobService {
  final ApiService _api = ApiService();

  /// Create a new job (CLIENT only)
  Future<Job?> createJob(CreateJobRequest request) async {
  final response = await _api.post(ApiConstants.jobs, request.toJson());

  if (response == null) {
    throw Exception('Respuesta vacía del servidor');
  }

  // Si la API devuelve { "job": { ... } }
  final data = (response is Map<String, dynamic> && response.containsKey('job'))
      ? response['job']
      : response;

  // Verificar que tenga los campos mínimos antes de crear el objeto
  if (data['id'] == null || data['description'] == null) {
    throw Exception('Datos incompletos en la respuesta del servidor');
  }

  return Job.fromJson({
    'id': data['id'] ?? '',
    'description': data['description'] ?? '',
    'status': data['status'] ?? 'PENDING',
    'createdAt': data['createdAt'] ?? DateTime.now().toIso8601String(),
    'updatedAt': data['updatedAt'] ?? DateTime.now().toIso8601String(),
    'clientId': data['clientId'] ?? '',
    'contractorId': data['contractorId'] ?? '',
    'serviceId': data['serviceId'] ?? '',
  });
}


  /// Get all jobs
  /// For CLIENTS: returns their own jobs (any status)
  /// For CONTRACTORS: returns all pending jobs
  Future<List<Job>> getJobs() async {
    final response = await _api.get(ApiConstants.jobs);

    return (response as List)
        .map((json) => Job.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Accept a job (CONTRACTOR only)
  Future<Job> acceptJob(String jobId) async {
    final response = await _api.patchWithoutBody(
      ApiConstants.acceptJob(jobId),
    );

    return Job.fromJson(response as Map<String, dynamic>);
  }

  /// Complete a job (CONTRACTOR only)
  Future<Job> completeJob(String jobId) async {
    final response = await _api.patchWithoutBody(
      ApiConstants.completeJob(jobId),
    );

    return Job.fromJson(response as Map<String, dynamic>);
  }

  /// Cancel a job (CLIENT or CONTRACTOR)
  Future<Job> cancelJob(String jobId) async {
    final response = await _api.patchWithoutBody(
      ApiConstants.cancelJob(jobId),
    );

    return Job.fromJson(response as Map<String, dynamic>);
  }

  /// Get jobs by status
  /// Client-side filtering
  Future<List<Job>> getJobsByStatus(JobStatus status) async {
    final jobs = await getJobs();
    return jobs.where((job) => job.status == status).toList();
  }

  /// Get pending jobs
  Future<List<Job>> getPendingJobs() async {
    return getJobsByStatus(JobStatus.pending);
  }

  /// Get accepted jobs
  Future<List<Job>> getAcceptedJobs() async {
    return getJobsByStatus(JobStatus.accepted);
  }

  /// Get completed jobs
  Future<List<Job>> getCompletedJobs() async {
    return getJobsByStatus(JobStatus.completed);
  }

  /// Get cancelled jobs
  Future<List<Job>> getCancelledJobs() async {
    return getJobsByStatus(JobStatus.cancelled);
  }
}
