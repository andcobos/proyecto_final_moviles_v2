import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/job.dart';
import '../../data/services/job_service.dart';
import 'auth_provider.dart'; // Asegúrate que este import apunte bien a tu auth_provider.dart

final contractorActiveJobsProvider = FutureProvider<List<Job>>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return [];

  final allJobs = await JobService().getJobs();
  
  final activeJobs = allJobs.where((job) {
    final isMine = job.contractorId.toString() == user.id.toString();
    final isActive =
        job.status == JobStatus.pending || job.status == JobStatus.accepted;
    return isMine && isActive;
  }).toList();

  return activeJobs;
});
