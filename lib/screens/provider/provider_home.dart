import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/theme_provider.dart';
import 'provider_nav_bar.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';

class ProviderHomeScreen extends ConsumerWidget {
  const ProviderHomeScreen({super.key});
  static const String name = 'ProviderHomeScreen';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeNotifierProvider).isDarkMode;
    final user = ref.watch(currentUserProvider);

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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
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
              "Electricista • 4.8 ⭐ • 124 reseñas",
              style: TextStyle(fontSize: 14, color: secondaryText),
            ),
            const SizedBox(height: 20),

            // Estadísticas rápidas
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    "Trabajos Hoy",
                    "3",
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
                    "5",
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
                    "24",
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

            // Próximos trabajos
            Text(
              "Próximos trabajos",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryText,
              ),
            ),
            const SizedBox(height: 12),
            _buildJobCard(
              "Reparación de tuberías",
              "Sofía Ramírez",
              "Hoy, 10:00 AM",
              "Calle Principal 123",
              Icons.plumbing,
              Colors.blue,
              cardColor,
              borderColor,
              secondaryText,
              primaryText,
            ),
            const SizedBox(height: 8),
            _buildJobCard(
              "Instalación de lámpara",
              "Carlos Mendoza",
              "Mañana, 2:00 PM",
              "Avenida Central 456",
              Icons.electrical_services,
              Colors.orange,
              cardColor,
              borderColor,
              secondaryText,
              primaryText,
            ),

            const SizedBox(height: 24),

            // Ingresos del mes
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
                          "\$2,450.00",
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
      ),
      bottomNavigationBar: const ProviderNavBar(currentIndex: 0),
    );
  }

  // --- Widgets ---

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
                Text(
                  client,
                  style: TextStyle(fontSize: 14, color: secondaryText),
                ),
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
}
