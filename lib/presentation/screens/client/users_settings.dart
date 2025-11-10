import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'nav_bar.dart';

class UserSettingsScreen extends StatelessWidget {
  const UserSettingsScreen({super.key});
  static const String name = 'UserSettingsScreen';

  static const Color primaryColor = Color(0xFF1D3557);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      // 5. Agregar la barra de navegación inferior de la imagen
      bottomNavigationBar: const NavBar(currentIndex: -1), // Asumiendo 'Perfil' es el índice 3
      
      appBar: AppBar(
        // 3. Ajuste de diseño del AppBar
        backgroundColor: Colors.white,
        elevation: 0, 
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black), // Ícono negro
          onPressed: () => context.pop(),
        ),
        centerTitle: true,
        title: Text(
          // La imagen muestra 'Ajustes del usuario' arriba y 'Ajustes' en el centro
          // Usaremos 'Ajustes' para el título central como en tu script original
          'Ajustes',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: Colors.black, // Título en negro
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0), // Ajustar padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título superior 'Ajustes del usuario' (como se ve en la imagen)
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Text(
                  'Ajustes del usuario',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),

              // Sección Perfil
              _buildSettingsSection(
                context,
                'Perfil',
                [
                  _buildSettingsItem(
                    icon: Icons.person_outline,
                    title: 'Información del Perfil',
                    subtitle: 'Editar tu información personal', // 2. Subtítulo ajustado
                    onTap: () => _showDevelopingSnackbar(context),
                  ),
                  _buildSettingsItem(
                    icon: Icons.lock_outline, // Candado para Seguridad
                    title: 'Seguridad',
                    subtitle: 'Cambiar tu contraseña', // 2. Subtítulo ajustado
                    onTap: () => _showDevelopingSnackbar(context),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Sección Preferencias (Ajustada a solo Notificaciones según la imagen)
              _buildSettingsSection(
                context,
                'Preferencias',
                [
                  _buildSettingsItem(
                    icon: Icons.notifications_outlined,
                    title: 'Notificaciones',
                    subtitle: 'Configurar tus notificaciones', // 2. Subtítulo ajustado
                    onTap: () => _showDevelopingSnackbar(context),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Sección Legal
              _buildSettingsSection(
                context,
                'Legal',
                [
                  _buildSettingsItem(
                    icon: Icons.shield_outlined, // 2. Ícono ajustado (escudo para privacidad)
                    title: 'Política de Privacidad',
                    subtitle: 'Política de Privacidad', // 2. Subtítulo ajustado
                    onTap: () => _showDevelopingSnackbar(context),
                  ),
                  _buildSettingsItem(
                    icon: Icons.description_outlined,
                    title: 'Términos de Servicio',
                    subtitle: 'Términos de Servicio', // 2. Subtítulo ajustado
                    onTap: () => _showDevelopingSnackbar(context),
                  ),
                  // Nota: La imagen solo muestra 2 ítems en Legal, quitaremos "Ayuda y Soporte"
                  // para coincidir exactamente.
                ],
              ),
              const SizedBox(height: 32),

              // Botón Cerrar Sesión
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    // 3. Estilos del botón ajustados a los colores de la imagen (azul oscuro)
                    backgroundColor: primaryColor, // Fondo azul oscuro
                    foregroundColor: Colors.white, // Texto en blanco
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5, // Un poco de sombra
                  ),
                  onPressed: () {
                    _showLogoutDialog(context);
                  },
                  child: const Text(
                    'Cerrar Sesión',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // Utilidad para mostrar el Snackbar de "Función en desarrollo"
  void _showDevelopingSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Función en desarrollo')),
    );
  }


  // Modificación del método para usar el color primario
  Widget _buildSettingsSection(BuildContext context, String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: primaryColor, // Título de sección en azul oscuro
            ),
          ),
        ),
        // Contenedor principal de la sección con un diseño más limpio
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8), // Ajustar a un radio más pequeño
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              // El primer ítem no debe tener un divisor superior
              for (int i = 0; i < items.length; i++)
                Column(
                  children: [
                    items[i],
                    // Añadir un divisor entre los ítems
                    if (i < items.length - 1)
                      const Divider(
                        height: 1,
                        indent: 65, // Alineado con el texto
                        endIndent: 16,
                      ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }

  // Modificación del método para usar el color primario y el diseño de la imagen
  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: primaryColor.withOpacity(0.1), // Fondo de ícono más claro
          borderRadius: BorderRadius.circular(10), // Borde ligeramente redondeado
        ),
        child: Icon(
          icon,
          color: primaryColor, // Ícono en azul oscuro
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: Colors.black87,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: Colors.grey.shade600,
          fontSize: 13, // Subtítulo un poco más pequeño
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 14, // Ícono más pequeño
        color: Colors.grey,
      ),
      onTap: onTap,
    );
  }

  // Diálogo de Cerrar Sesión (sin cambios, ya está bien implementado)
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
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
                context.go('/'); // Navegar a la ruta de inicio (login)
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Sesión cerrada correctamente'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text(
                'Cerrar Sesión',
                style: TextStyle(color: primaryColor), // Usar color primario
              ),
            ),
          ],
        );
      },
    );
  }
}