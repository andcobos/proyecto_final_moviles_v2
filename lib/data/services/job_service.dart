import '../../core/constants.dart';
import '../models/job.dart';
import 'api_service.dart';

class JobService {
  final ApiService _api = ApiService();

  /// Crear nuevo trabajo
  Future<Job?> createJob(CreateJobRequest request) async {
    final response = await _api.post(ApiConstants.jobs, request.toJson());

    if (response == null) {
      throw Exception('Respuesta vacía del servidor');
    }

    final data = (response is Map<String, dynamic> && response.containsKey('job'))
        ? response['job']
        : response;

    return Job.fromJson(data as Map<String, dynamic>);
  }

  /// Obtener trabajos
  Future<List<Job>> getJobs() async {
    final response = await _api.get(ApiConstants.jobs);
    return (response as List)
        .map((json) => Job.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// ✅ Aceptar trabajo (usa /jobs/:id/accept)
  Future<Job> acceptJob(String jobId) async {
    final response = await _api.patchWithoutBody(
      ApiConstants.acceptJob(jobId),
    );
    return Job.fromJson(response as Map<String, dynamic>);
  }

  /// ✅ Completar trabajo (usa /jobs/:id/complete)
  Future<Job> completeJob(String jobId) async {
    final response = await _api.patchWithoutBody(
      ApiConstants.completeJob(jobId),
    );
    return Job.fromJson(response as Map<String, dynamic>);
  }

  /// ✅ Cancelar trabajo (usa /jobs/:id/cancel)
  Future<Job> cancelJob(String jobId) async {
    final response = await _api.patchWithoutBody(
      ApiConstants.cancelJob(jobId),
    );
    return Job.fromJson(response as Map<String, dynamic>);
  }
}
