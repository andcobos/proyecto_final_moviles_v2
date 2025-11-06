import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'provider_nav_bar.dart';

class ProviderJobsScreen extends StatelessWidget {
  const ProviderJobsScreen({super.key});
  static const String name = 'ProviderJobsScreen';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Trabajos Asignados",
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Campo de búsqueda
              TextField(
                decoration: InputDecoration(
                  hintText: "Buscar trabajos",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: colorScheme.surfaceContainerHighest.withOpacity(0.3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
              const SizedBox(height: 16),

              // Filtros
              Row(
                children: [
                  _buildFilterChip("Todos", true),
                  const SizedBox(width: 8),
                  _buildFilterChip("Pendientes", false),
                  const SizedBox(width: 8),
                  _buildFilterChip("Aceptados", false),
                ],
              ),
              const SizedBox(height: 20),

              // Lista de trabajos asignados
              _buildJobAssignmentCard(
                context,
                "Plomería",
                "María González",
                "Reparación de tubería en baño",
                "Calle Principal 123, Ciudad",
                "Hoy, 2:00 PM",
                "https://images.unsplash.com/photo-1521791136064-7986c2920216?w=400",
                Icons.plumbing,
                Colors.blue,
              ),
              const SizedBox(height: 12),
              _buildJobAssignmentCard(
                context,
                "Electricidad",
                "Carlos Ramírez",
                "Instalación de ventilador",
                "Avenida Central 456, Ciudad",
                "Mañana, 10:00 AM",
                "https://images.unsplash.com/photo-1621905251189-08b45d6a269e?w=400",
                Icons.electrical_services,
                Colors.orange,
              ),
              const SizedBox(height: 12),
              _buildJobAssignmentCard(
                context,
                "Jardinería",
                "Ana López",
                "Mantenimiento de jardín",
                "Calle Secundaria 789, Ciudad",
                "Pasado mañana, 9:00 AM",
                "https://images.unsplash.com/photo-1416879595882-3373a0480b5b?w=400",
                Icons.local_florist,
                Colors.green,
              ),
              const SizedBox(height: 12),
              _buildJobAssignmentCard(
                context,
                "Limpieza",
                "Roberto Silva",
                "Limpieza profunda del hogar",
                "Boulevard Norte 321, Ciudad",
                "Viernes, 3:00 PM",
                "https://images.unsplash.com/photo-1521791136064-7986c2920216?w=400",
                Icons.cleaning_services,
                Colors.purple,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const ProviderNavBar(currentIndex: 1),
    );
  }

  Widget _buildFilterChip(String label, bool selected) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      selectedColor: const Color(0xFF1D3557).withOpacity(0.2),
      labelStyle: TextStyle(
        color: selected ? const Color(0xFF1D3557) : Colors.grey.shade700,
        fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
      ),
      onSelected: (_) {
        // TODO: Implementar filtrado
      },
    );
  }

Widget _buildJobAssignmentCard(
  BuildContext context,
  String service,
  String client,
  String description,
  String address,
  String time,
  String imageUrl,
  IconData icon,
  Color color,
)
 {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con servicio y cliente
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        client,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "Nuevo",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.orange.shade800,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Imagen del trabajo
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imageUrl,
                width: double.infinity,
                height: 120,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: double.infinity,
                    height: 120,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.image_not_supported, size: 40),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),

            // Descripción y detalles
            Text(
              description,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.location_on, size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    address,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.access_time, size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Botones de acción
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Trabajo rechazado')),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.red.shade300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
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
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Trabajo aceptado')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1D3557),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Aceptar",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // void _showAcceptDialog(BuildContext context, String service, String client) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text('Aceptar Trabajo'),
  //         content: Text('¿Estás seguro de que quieres aceptar el trabajo de $service para $client?'),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.of(context).pop(),
  //             child: const Text('Cancelar'),
  //           ),
  //           ElevatedButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //               ScaffoldMessenger.of(context).showSnackBar(
  //                 const SnackBar(
  //                   content: Text('¡Trabajo aceptado exitosamente!'),
  //                   backgroundColor: Colors.green,
  //                 ),
  //               );
  //             },
  //             style: ElevatedButton.styleFrom(
  //               backgroundColor: const Color(0xFF1D3557),
  //             ),
  //             child: const Text('Aceptar'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  // void _showRejectDialog(BuildContext context, String service, String client) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text('Rechazar Trabajo'),
  //         content: Text('¿Estás seguro de que quieres rechazar el trabajo de $service para $client?'),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.of(context).pop(),
  //             child: const Text('Cancelar'),
  //           ),
  //           ElevatedButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //               ScaffoldMessenger.of(context).showSnackBar(
  //                 const SnackBar(
  //                   content: Text('Trabajo rechazado'),
  //                   backgroundColor: Colors.orange,
  //                 ),
  //               );
  //             },
  //             style: ElevatedButton.styleFrom(
  //               backgroundColor: Colors.red,
  //             ),
  //             child: const Text('Rechazar'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
}
