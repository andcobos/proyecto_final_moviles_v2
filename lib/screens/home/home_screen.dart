import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/theme_provider.dart';
import 'nav_bar.dart' as customNavBar;
import 'package:go_router/go_router.dart';


class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});
  static const String name = 'HomeScreen';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeNotifierProvider).isDarkMode;

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
            const Text(
              "Hola, Ricardo",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Barra de búsqueda
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

            //El switch de tema
            SwitchListTile(
              title: const Text("Modo oscuro"),
              value: isDarkMode,
              onChanged: (_) {
                ref.read(themeNotifierProvider.notifier).toggleDarkmode();
              },
            ),

            const SizedBox(height: 20),

            // Pedidos de servicios actuales
            const Text(
              "Pedidos actuales",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 180,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _currentServiceCard(
                    "Dentista",
                    "Dr. María González",
                    "Hoy, 2:00 PM",
                    "Consulta general",
                    "https://images.unsplash.com/photo-1612349317150-e413f6a5b16d?w=400",
                  ),
                  const SizedBox(width: 12),
                  _currentServiceCard(
                    "Fontanero",
                    "Carlos Mendoza",
                    "Mañana, 10:00 AM",
                    "Reparación de tubería",
                    "https://images.unsplash.com/photo-1581578731548-c6a0c3f2fcc0?w=400",
                  ),
                  const SizedBox(width: 12),
                  _currentServiceCard(
                    "Electricista",
                    "Roberto Silva",
                    "Pasado mañana, 3:00 PM",
                    "Instalación de lámpara",
                    "https://images.unsplash.com/photo-1621905251189-08b45d6a269e?w=400",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Ofertas destacadas
            const Text(
              "Ofertas destacadas",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _offerCard(
              "20% de descuento en limpieza profunda",
              "Solo por tiempo limitado - Aprovecha esta oferta especial",
              "https://images.unsplash.com/photo-1581578731548-c6a0c3f2fcc0?w=400",
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

      // Bottom Navigation
      bottomNavigationBar: customNavBar.NavBar(currentIndex: 0),
    );
  }

  Widget _currentServiceCard(String service, String professional, String time, String description, String imageUrl) {
    return SizedBox(
      width: 160,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    professional,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    time,
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 11,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _offerCard(String title, String description, String imageUrl, String badge) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        height: 120,
        child: Row(
          children: [
            // Imagen
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(16),
              ),
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
            // Contenido
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
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
