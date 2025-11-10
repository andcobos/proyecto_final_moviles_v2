import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/job.dart';
import '../../providers/auth_provider.dart';
import '../../../data/services/job_service.dart';
import 'provider_nav_bar.dart';

final contractorActiveJobsProvider = FutureProvider<List<Job>>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return [];

  final allJobs = await JobService().getJobs();

  final myJobs = allJobs.where((job) {
    final isMine = job.contractorId.toString() == user.id.toString();
    final isActive = [
      JobStatus.pending,
      JobStatus.accepted,
    ].contains(job.status);
    return isMine && isActive;
  }).toList();

  return myJobs;
});



/// Pantalla principal de trabajos asignados al contratista
class ProviderJobsScreen extends ConsumerWidget {
  const ProviderJobsScreen({super.key});
  static const String name = 'ProviderJobsScreen';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 👇 Cambiado: ahora usamos contractorActiveJobsProvider
    final jobsAsync = ref.watch(contractorActiveJobsProvider);

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
                child: Text("No tienes trabajos activos por ahora."),
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

/// Tarjeta individual para cada trabajo
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
            // 🔹 Cabecera
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

            // 🔹 Fechas
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

            // 🔸 Acciones según estado
            if (job.status == JobStatus.pending)
              Row(
                children: [
                  // ❌ Botón Rechazar
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        try {
                          await JobService().cancelJob(job.id);
                          ref.invalidate(contractorActiveJobsProvider);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Trabajo rechazado"),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Error al rechazar: $e"),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                        }
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

                  // Botón Aceptar
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        try {
                          // 1. Llamamos al backend para aceptar el trabajo
                          await JobService().acceptJob(job.id);

                          // 2. Invalidamos el provider (limpia la caché)
                          ref.invalidate(contractorActiveJobsProvider);

                          // 3. Esperamos un momento y forzamos la recarga
                          await Future.delayed(
                            const Duration(milliseconds: 200),
                          );
                          await ref.refresh(
                            contractorActiveJobsProvider.future,
                          );

                          // 4. Mostramos confirmación
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("✅ Trabajo aceptado correctamente"),
                              backgroundColor: Colors.green,
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Error al aceptar: $e"),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                        }
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

            // 🟩 Botón “Marcar como completado”
            if (job.status == JobStatus.accepted)
              ElevatedButton(
                onPressed: () async {
                  try {
                    await JobService().completeJob(job.id);
                    ref.invalidate(contractorActiveJobsProvider);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Trabajo completado"),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Error al completar: $e"),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                  }
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
