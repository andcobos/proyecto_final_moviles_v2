import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'provider_nav_bar.dart';
import 'provider_jobs.dart'; 
import '../../../data/models/job.dart';
import '../../providers/auth_provider.dart';
import '../../../data/services/job_service.dart';

/// Provider que devuelve todos los trabajos del contratista
final contractorAllJobsProvider = FutureProvider<List<Job>>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return [];

  final allJobs = await JobService().getJobs();

  final myJobs = allJobs.where((job) {
    return job.contractorId.toString() == user.id.toString();
  }).toList();

  return myJobs;
});

class ProviderServicesScreen extends ConsumerWidget {
  const ProviderServicesScreen({super.key});
  static const String name = 'ProviderServicesScreen';


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final jobsAsync = ref.watch(contractorAllJobsProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Mis Servicios",
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: jobsAsync.when(
          data: (jobs) {
            
            final acceptedJobs =
                jobs.where((job) => job.status == JobStatus.accepted).toList();

            final completedJobs =
                jobs.where((job) => job.status == JobStatus.completed).toList();

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Campo de búsqueda
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Buscar servicios",
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor:
                          colorScheme.surfaceContainerHighest.withOpacity(0.3),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Próximos servicios (Aceptados)
                  const Text(
                    "Próximos trabajos",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  if (acceptedJobs.isEmpty)
                    const Text("No tienes trabajos próximos."),
                  ...acceptedJobs.map(
                    (job) => _buildServiceCard(
                      job.description,
                      "Cliente ID: ${job.clientId}",
                      "Creado: ${_formatDate(job.createdAt)}",
                      "Servicio ID: ${job.serviceId}",
                      Icons.build,
                      Colors.blue,
                      job.status.displayName,
                      Colors.green,
                      () => context.push('/pro/servicio/detalles'),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Completados
                  const Text(
                    "Completados",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (completedJobs.isEmpty)
                    const Text("Aún no tienes servicios completados."),
                  ...completedJobs.map(
                    (job) => _buildServiceCard(
                      job.description,
                      "Cliente ID: ${job.clientId}",
                      "Actualizado: ${_formatDate(job.updatedAt)}",
                      "Servicio ID: ${job.serviceId}",
                      Icons.done_all,
                      Colors.grey,
                      job.status.displayName,
                      Colors.green,
                      () => context.push('/pro/servicio/detalles'),
                    ),
                  ),
                ],
              ),
            );
          },
          loading: () =>
              const Center(child: CircularProgressIndicator.adaptive()),
          error: (e, st) =>
              Center(child: Text("Error al cargar servicios: $e")),
        ),
      ),
      bottomNavigationBar: const ProviderNavBar(currentIndex: 2),
    );
  }

  // --- Widgets auxiliares ---

  Widget _buildServiceCard(
    String service,
    String client,
    String time,
    String address,
    IconData icon,
    Color color,
    String status,
    Color statusColor,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            service,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            status,
                            style: TextStyle(
                              fontSize: 12,
                              color: statusColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      client,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.access_time,
                            size: 14, color: Colors.grey.shade500),
                        const SizedBox(width: 4),
                        Text(
                          time,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.location_on,
                            size: 14, color: Colors.grey.shade500),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            address,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios,
                  size: 16, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }

  static String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/"
        "${date.month.toString().padLeft(2, '0')}/"
        "${date.year}";
  }
}
