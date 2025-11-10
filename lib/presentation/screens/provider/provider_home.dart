import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/theme_provider.dart';
import '../../providers/auth_provider.dart';
import 'provider_nav_bar.dart';
import '../../../data/models/job.dart';
import 'provider_jobs.dart';

class ProviderHomeScreen extends ConsumerWidget {
  const ProviderHomeScreen({super.key});
  static const String name = 'ProviderHomeScreen';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeNotifierProvider).isDarkMode;
    final user = ref.watch(currentUserProvider);
    final jobsAsync = ref.watch(contractorActiveJobsProvider);

    // Colores adaptativos
    final primaryText = isDarkMode ? Colors.white : Colors.black;
    final secondaryText =
        isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600;
    final cardColor =
        isDarkMode ? Colors.grey.shade900.withOpacity(0.6) : Colors.white;
    final borderColor =
        isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200;
    final boxShadowColor =
        isDarkMode ? Colors.transparent : Colors.black.withOpacity(0.05);

    final userName = user?.fullName ?? "Usuario";
    final userRole = user?.role == "CONTRACTOR" ? "Contratista" : "Cliente";

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Fixea Pro",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: primaryText,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      body: jobsAsync.when(
        data: (jobs) {
          // --- Filtros dinámicos ---
          final acceptedJobs =
              jobs.where((job) => job.status == JobStatus.accepted).toList();
          final pendingJobs =
              jobs.where((job) => job.status == JobStatus.pending).toList();
          final completedJobs =
              jobs.where((job) => job.status == JobStatus.completed).toList();

          final today = DateTime.now();
          final jobsToday = acceptedJobs.where((job) =>
              job.createdAt.year == today.year &&
              job.createdAt.month == today.month &&
              job.createdAt.day == today.day);

          return Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                // 👤 Nombre dinámico
                Text(
                  "Hola, $userName",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: primaryText,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "$userRole • 4.8 ⭐ • 124 reseñas",
                  style: TextStyle(fontSize: 14, color: secondaryText),
                ),
                const SizedBox(height: 20),

                // Estadísticas dinámicas
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        "Trabajos Hoy",
                        jobsToday.length.toString(),
                        Icons.work_outline,
                        Colors.blue,
                        cardColor,
                        boxShadowColor,
                        primaryText,
                        secondaryText,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        "Pendientes",
                        pendingJobs.length.toString(),
                        Icons.pending_outlined,
                        Colors.orange,
                        cardColor,
                        boxShadowColor,
                        primaryText,
                        secondaryText,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        "Completados",
                        completedJobs.length.toString(),
                        Icons.check_circle_outline,
                        Colors.green,
                        cardColor,
                        boxShadowColor,
                        primaryText,
                        secondaryText,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Acciones rápidas
                Text(
                  "Acciones rápidas",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: primaryText,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildActionCard(
                        "Ver Trabajos",
                        Icons.work_outline,
                        Colors.blue,
                        () => context.go('/pro/trabajos'),
                        cardColor,
                        boxShadowColor,
                        primaryText,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildActionCard(
                        "Mi Agenda",
                        Icons.calendar_today,
                        Colors.green,
                        () => context.go('/pro/agenda'),
                        cardColor,
                        boxShadowColor,
                        primaryText,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Próximos trabajos (solo ACEPTADOS)
                Text(
                  "Próximos trabajos",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: primaryText,
                  ),
                ),
                const SizedBox(height: 12),

                if (acceptedJobs.isEmpty)
                  Text(
                    "No tienes trabajos próximos.",
                    style: TextStyle(color: secondaryText),
                  ),
                ...acceptedJobs.map(
                  (job) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: _buildJobCard(
                      job.description,
                      "Cliente ID: ${job.clientId}",
                      "Creado: ${_formatDate(job.createdAt)}",
                      "Servicio ID: ${job.serviceId}",
                      Icons.build,
                      Colors.blue,
                      cardColor,
                      borderColor,
                      secondaryText,
                      primaryText,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Ingresos del mes (placeholder)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? Colors.green.shade900.withOpacity(0.3)
                        : Colors.green.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDarkMode
                          ? Colors.green.shade700
                          : Colors.green.shade200,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.attach_money,
                          color: Colors.green.shade600, size: 32),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Ingresos del mes",
                              style: TextStyle(
                                color: Colors.green.shade600,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "\$2,450.00", // luego: sumar Job completados * Service.rate
                              style: TextStyle(
                                color: Colors.green.shade600,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.trending_up, color: Colors.green.shade600),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text("Error al cargar trabajos: $e")),
      ),
      bottomNavigationBar: const ProviderNavBar(currentIndex: 0),
    );
  }

  // --- Widgets auxiliares ---

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
    Color cardColor,
    Color boxShadow,
    Color primaryText,
    Color secondaryText,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: boxShadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(fontSize: 12, color: secondaryText),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(String title, IconData icon, Color color,
      VoidCallback onTap, Color cardColor, Color boxShadow, Color textColor) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: boxShadow,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJobCard(
    String service,
    String client,
    String time,
    String address,
    IconData icon,
    Color color,
    Color cardColor,
    Color borderColor,
    Color secondaryText,
    Color primaryText,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
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
                Text(
                  service,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: primaryText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(client,
                    style: TextStyle(fontSize: 14, color: secondaryText)),
                const SizedBox(height: 4),
                Text(time,
                    style: TextStyle(fontSize: 12, color: secondaryText)),
                const SizedBox(height: 4),
                Text(
                  address,
                  style: TextStyle(fontSize: 12, color: secondaryText),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios,
              size: 16, color: secondaryText.withOpacity(0.7)),
        ],
      ),
    );
  }

  static String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/"
        "${date.month.toString().padLeft(2, '0')}/"
        "${date.year}";
  }
}
