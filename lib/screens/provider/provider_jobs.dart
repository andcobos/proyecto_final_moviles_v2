import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/job.dart';
import '../../providers/auth_provider.dart';
import '../../services/job_service.dart';
import 'provider_nav_bar.dart';

final contractorJobsProvider = FutureProvider<List<Job>>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return [];
  // Tu backend ya devuelve solo los trabajos del usuario autenticado
  return await JobService().getJobs();
});

class ProviderJobsScreen extends ConsumerWidget {
  const ProviderJobsScreen({super.key});
  static const String name = 'ProviderJobsScreen';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobsAsync = ref.watch(contractorJobsProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Trabajos Asignados",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: jobsAsync.when(
          data: (jobs) {
            if (jobs.isEmpty) {
              return const Center(
                child: Text("No tienes trabajos asignados por ahora."),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: jobs.length,
              itemBuilder: (context, index) {
                final job = jobs[index];
                return _JobCard(job: job);
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, st) => Center(child: Text("Error: $e")),
        ),
      ),
      bottomNavigationBar: const ProviderNavBar(currentIndex: 1),
    );
  }
}

class _JobCard extends ConsumerWidget {
  final Job job;
  const _JobCard({required this.job});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Color stateColor;
    switch (job.status) {
      case JobStatus.pending:
        stateColor = Colors.orange;
        break;
      case JobStatus.accepted:
        stateColor = Colors.blue;
        break;
      case JobStatus.completed:
        stateColor = Colors.green;
        break;
      case JobStatus.cancelled:
        stateColor = Colors.red;
        break;
    }

    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabecera
            Row(
              children: [
                Icon(Icons.work_outline, color: stateColor, size: 24),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    job.description,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: stateColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    job.status.displayName,
                    style: TextStyle(
                      color: stateColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Fechas
            Row(
              children: [
                const Icon(Icons.access_time, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  "Creado: ${job.createdAt.toLocal()}",
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.refresh, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  "Actualizado: ${job.updatedAt.toLocal()}",
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Botones de acción según estado
            if (job.status == JobStatus.pending)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        await JobService().cancelJob(job.id);
                        ref.invalidate(contractorJobsProvider);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Trabajo rechazado"),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.red.shade300),
                      ),
                      child: Text(
                        "Rechazar",
                        style: TextStyle(color: Colors.red.shade700),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        await JobService().acceptJob(job.id);
                        ref.invalidate(contractorJobsProvider);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Trabajo aceptado"),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1D3557),
                      ),
                      child: const Text(
                        "Aceptar",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),

            if (job.status == JobStatus.accepted)
              ElevatedButton(
                onPressed: () async {
                  await JobService().completeJob(job.id);
                  ref.invalidate(contractorJobsProvider);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Trabajo completado"),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                ),
                child: const Text("Marcar como completado"),
              ),
          ],
        ),
      ),
    );
  }
}
