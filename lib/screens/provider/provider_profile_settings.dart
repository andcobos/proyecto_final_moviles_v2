import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'provider_nav_bar.dart';
import '../../providers/theme_provider.dart';

class ProviderProfileSettingsScreen extends ConsumerWidget {
  const ProviderProfileSettingsScreen({super.key});
  static const String name = 'ProviderProfileSettingsScreen';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final themeNotifier = ref.read(themeNotifierProvider.notifier);
    final appTheme = ref.watch(themeNotifierProvider);

    // 🎨 Colores adaptables
    final primaryTextColor = isDarkMode ? Colors.white : Colors.black;
    final secondaryTextColor =
        isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600;
    final tileBackgroundColor =
        isDarkMode ? Colors.grey.shade800 : Colors.grey.shade100;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryTextColor),
          onPressed: () => context.pop(),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Ajustes',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: primaryTextColor,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // PERFIL
            Text(
              'Perfil',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: primaryTextColor,
              ),
            ),
            const SizedBox(height: 12),
            _buildSettingsItem(
              context,
              icon: Icons.person_outline,
              title: 'Información del Perfil',
              subtitle: 'Editar tu información personal',
              onTap: () => context.push('/pro/editar-perfil'),
              primaryTextColor: primaryTextColor,
              secondaryTextColor: secondaryTextColor,
              tileColor: tileBackgroundColor,
            ),
            _buildSettingsItem(
              context,
              icon: Icons.lock_outline,
              title: 'Seguridad',
              subtitle: 'Cambiar tu contraseña',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Función de seguridad en desarrollo'),
                  ),
                );
              },
              primaryTextColor: primaryTextColor,
              secondaryTextColor: secondaryTextColor,
              tileColor: tileBackgroundColor,
            ),
            const SizedBox(height: 24),

            // PREFERENCIAS
            Text(
              'Preferencias',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: primaryTextColor,
              ),
            ),
            const SizedBox(height: 12),
            _buildSettingsItem(
              context,
              icon: Icons.notifications_outlined,
              title: 'Notificaciones',
              subtitle: 'Configurar tus notificaciones',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Notificaciones en desarrollo'),
                  ),
                );
              },
              primaryTextColor: primaryTextColor,
              secondaryTextColor: secondaryTextColor,
              tileColor: tileBackgroundColor,
            ),

            // Toggle modo oscuro
            Container(
              margin: const EdgeInsets.symmetric(vertical: 4),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: tileBackgroundColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    appTheme.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                    color: primaryTextColor,
                  ),
                ),
                title: Text(
                  'Modo oscuro',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: primaryTextColor,
                  ),
                ),
                subtitle: Text(
                  appTheme.isDarkMode
                      ? 'Tema oscuro activado'
                      : 'Tema claro activado',
                  style: TextStyle(color: secondaryTextColor, fontSize: 12),
                ),
                trailing: Switch(
                  value: appTheme.isDarkMode,
                  onChanged: (_) => themeNotifier.toggleDarkmode(),
                  activeColor: const Color(0xFF1D3557),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // LEGAL
            Text(
              'Legal',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: primaryTextColor,
              ),
            ),
            const SizedBox(height: 12),
            _buildSettingsItem(
              context,
              icon: Icons.privacy_tip_outlined,
              title: 'Política de Privacidad',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Política de privacidad en desarrollo'),
                  ),
                );
              },
              primaryTextColor: primaryTextColor,
              secondaryTextColor: secondaryTextColor,
              tileColor: tileBackgroundColor,
            ),
            _buildSettingsItem(
              context,
              icon: Icons.description_outlined,
              title: 'Términos de Servicio',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Términos de servicio en desarrollo'),
                  ),
                );
              },
              primaryTextColor: primaryTextColor,
              secondaryTextColor: secondaryTextColor,
              tileColor: tileBackgroundColor,
            ),
            const SizedBox(height: 32),

            // BOTÓN CERRAR SESIÓN
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showLogoutDialog(context),
                icon: const Icon(Icons.logout),
                label: const Text('Cerrar Sesión'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const ProviderNavBar(currentIndex: 4),
    );
  }

  // 🔹 Método de diálogo de cierre de sesión (versión igual a tu ejemplo)
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Text('Cerrar Sesión'),
          content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.go('/');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Sesión cerrada correctamente'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: Text(
                'Cerrar Sesión',
                style: TextStyle(color: Colors.red.shade700),
              ),
            ),
          ],
        );
      },
    );
  }

  // 🔹 Reutilizable: item de configuración
  Widget _buildSettingsItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    required Color primaryTextColor,
    required Color secondaryTextColor,
    required Color tileColor,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: tileColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: primaryTextColor),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: primaryTextColor,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: TextStyle(color: secondaryTextColor, fontSize: 13),
            )
          : null,
      onTap: onTap,
    );
  }
}
