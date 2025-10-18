import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'provider_nav_bar.dart';

class ProviderServicesScreen extends StatelessWidget {
  const ProviderServicesScreen({super.key});
  static const String name = 'ProviderServicesScreen';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        centerTitle: true,
        title: Text(
          "Mis Servicios",
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
                  hintText: "Buscar servicios",
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
                  _buildFilterChip("Próximos", false),
                  const SizedBox(width: 8),
                  _buildFilterChip("Completados", false),
                ],
              ),
              const SizedBox(height: 20),

              // Próximos servicios
              const Text(
                "Próximos",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _buildServiceCard(
                "Reparación de tuberías",
                "Sofía Ramírez",
                "Hoy, 10:00 AM",
                "Calle Principal 123",
                Icons.plumbing,
                Colors.blue,
                "Pendiente",
                Colors.orange,
                () => context.go('/pro/servicio/detalles'),
              ),
              const SizedBox(height: 8),
              _buildServiceCard(
                "Instalación de lámpara",
                "Carlos Mendoza",
                "Mañana, 2:00 PM",
                "Avenida Central 456",
                Icons.electrical_services,
                Colors.orange,
                "Confirmado",
                Colors.green,
                () => context.go('/pro/servicio/detalles'),
              ),

              const SizedBox(height: 24),

              // Completados
              const Text(
                "Completados",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _buildServiceCard(
                "Reparación de muebles",
                "Ana López",
                "Ayer, 3:00 PM",
                "Calle Secundaria 789",
                Icons.build,
                Colors.brown,
                "Completado",
                Colors.green,
                () => context.go('/pro/servicio/detalles'),
              ),
              const SizedBox(height: 8),
              _buildServiceCard(
                "Pintura de interiores",
                "Roberto Silva",
                "Hace 2 días, 9:00 AM",
                "Boulevard Norte 321",
                Icons.brush,
                Colors.purple,
                "Completado",
                Colors.green,
                () => context.go('/pro/servicio/detalles'),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const ProviderNavBar(currentIndex: 2),
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
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                      "Cliente: $client",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 14, color: Colors.grey.shade500),
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
                        Icon(Icons.location_on, size: 14, color: Colors.grey.shade500),
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
              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }
}
