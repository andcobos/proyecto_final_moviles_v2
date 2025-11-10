import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/theme_provider.dart';
import '../../providers/auth_provider.dart';
import '../../../data/services/service_services.dart';
import '../../../data/models/service.dart';
import 'nav_bar.dart' as customNavBar;

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});
  static const String name = 'HomeScreen';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeNotifierProvider).isDarkMode;
    final user = ref.watch(currentUserProvider);
    final userName = user?.fullName ?? "Usuario";

    final serviceService = ServiceService();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Fixea",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () => context.push('/notificaciones'),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            // 👋 Nombre dinámico
            Text(
              "Hola, $userName",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            // 🔍 Barra de búsqueda
            TextField(
              decoration: InputDecoration(
                hintText: "Buscar servicios",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade200,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 🌙 Modo oscuro
            SwitchListTile(
              title: const Text("Modo oscuro"),
              value: isDarkMode,
              onChanged: (_) {
                ref.read(themeNotifierProvider.notifier).toggleDarkmode();
              },
            ),

            const SizedBox(height: 20),

            // 🔧 Servicios disponibles (dinámicos)
            const Text(
              "Servicios disponibles",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            FutureBuilder<List<dynamic>>(
              future: ServiceService().getAllServices(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      "Error al cargar servicios: ${snapshot.error}",
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }

                
                final data = snapshot.data ?? [];

                final allServices = <Service>[];

                // Verifica si la respuesta es una lista de JSON o lista de modelos
                for (var item in data) {
                  // Si el item ya es un Service (por ejemplo, tu ServiceService().getAllServices() ya hace el fromJson)
                  if (item is Service) {
                    allServices.add(item);
                  }
                  // Si viene como un Map (ej: JSON de worker con services)
                  else if (item is Map<String, dynamic> &&
                      item['services'] != null) {
                    for (var s in item['services']) {
                      allServices.add(
                        Service.fromJson(s as Map<String, dynamic>),
                      );
                    }
                  }
                }


                if (allServices.isEmpty) {
                  return const Center(
                    child: Text("No hay servicios disponibles."),
                  );
                }

                return SizedBox(
                  height: 180,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: allServices.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final service = allServices[index];

                      return GestureDetector(
                        onTap: () {
                          final id = service.id;
                          debugPrint('🟩 Navegando con ID del servicio: $id');
                          context.push('/solicitar-servicio/$id');
                        },
                        child: _serviceCard(service),
                      );
                    },
                  ),
                );

              },
            ),

            const SizedBox(height: 24),

            // 🎯 Ofertas destacadas
            const Text(
              "Ofertas destacadas",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            _offerCard(
              "20% de descuento en limpieza profunda",
              "Solo por tiempo limitado - Aprovecha esta oferta especial",
              "https://images.unsplash.com/photo-1521791136064-7986c2920216?w=400",
              "20% OFF",
            ),
            const SizedBox(height: 12),

            _offerCard(
              "Paquete completo de jardinería",
              "Incluye poda, riego y mantenimiento por un mes",
              "https://images.unsplash.com/photo-1416879595882-3373a0480b5b?w=400",
              "Paquete",
            ),
          ],
        ),
      ),

      bottomNavigationBar: customNavBar.NavBar(currentIndex: 0),
    );
  }

  // 🧱 Tarjeta de servicio dinámico
  Widget _serviceCard(Service service) {
    return SizedBox(
      width: 160,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.handyman, color: Colors.blueAccent, size: 32),
              const SizedBox(height: 8),
              Text(
                service.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                service.description,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🏷️ Tarjeta de oferta destacada
  Widget _offerCard(
    String title,
    String description,
    String imageUrl,
    String badge,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        height: 120,
        child: Row(
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.horizontal(left: Radius.circular(16)),
              child: Image.network(
                imageUrl,
                width: 120,
                height: 120,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 120,
                    height: 120,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.image_not_supported),
                  );
                },
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1D3557),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        badge,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Flexible(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Flexible(
                      child: Text(
                        description,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 11,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
