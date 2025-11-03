import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/theme_provider.dart';
import 'package:go_router/go_router.dart';

class ProviderServiceDetailsScreen extends ConsumerWidget {
  const ProviderServiceDetailsScreen({super.key});
  static const String name = 'ProviderServiceDetailsScreen';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDarkMode = ref.watch(themeNotifierProvider).isDarkMode;

    final primaryText = isDarkMode ? Colors.white : Colors.black;
    final secondaryText =
        isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600;
    final cardColor =
        isDarkMode ? Colors.grey.shade900.withOpacity(0.7) : Colors.white;
    final accentColor = const Color.fromARGB(255, 143, 184, 242);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryText),
          onPressed: () => context.pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Detalles del Servicio",
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: primaryText,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildClientInfo(cardColor, primaryText, secondaryText, accentColor),
              const SizedBox(height: 20),
              _buildServiceInfo(cardColor, primaryText, secondaryText, accentColor),
              const SizedBox(height: 20),
              _buildAddressInfo(cardColor, primaryText, secondaryText, accentColor),
              const SizedBox(height: 20),
              _buildClientNotes(cardColor, primaryText, secondaryText, accentColor, isDarkMode),
              const SizedBox(height: 20),
              _buildAttachedPhotos(cardColor, primaryText, accentColor),
              const SizedBox(height: 32),
              _buildActionButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClientInfo(Color cardColor, Color primaryText,
      Color secondaryText, Color accentColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Información del Cliente",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: accentColor)),
          const SizedBox(height: 16),
          Row(
            children: [
              const CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(
                  'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=400',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Sofía Ramírez",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: primaryText)),
                    const SizedBox(height: 4),
                    Text("Cliente desde 2023",
                        style:
                            TextStyle(fontSize: 14, color: secondaryText)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star,
                            size: 16, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text("4.9 (23 reseñas)",
                            style: TextStyle(
                                fontSize: 12, color: secondaryText)),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(Icons.phone, color: accentColor),
              const SizedBox(width: 8),
              Icon(Icons.message, color: accentColor),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildServiceInfo(Color cardColor, Color primaryText,
      Color secondaryText, Color accentColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Información del Servicio",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: accentColor)),
          const SizedBox(height: 16),
          _buildInfoRow("Servicio:", "Reparación de tuberías", primaryText, secondaryText),
          _buildInfoRow("Fecha:", "Hoy, 15 de julio de 2024", primaryText, secondaryText),
          _buildInfoRow("Hora:", "10:00 AM - 12:00 PM", primaryText, secondaryText),
          _buildInfoRow("Duración estimada:", "2 horas", primaryText, secondaryText),
          _buildInfoRow("Costo:", "\$150.00", primaryText, secondaryText),
          _buildInfoRow("Estado:", "Pendiente", primaryText, secondaryText),
        ],
      ),
    );
  }

  Widget _buildAddressInfo(Color cardColor, Color primaryText,
      Color secondaryText, Color accentColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Dirección del Servicio",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: accentColor)),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.location_on, color: Colors.red.shade400, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Calle Principal 123",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: primaryText)),
                    const SizedBox(height: 4),
                    Text("Colonia Centro, Ciudad de México",
                        style: TextStyle(fontSize: 14, color: secondaryText)),
                    const SizedBox(height: 4),
                    Text("Código postal: 06000",
                        style: TextStyle(fontSize: 14, color: secondaryText)),
                  ],
                ),
              ),
              Icon(Icons.directions, color: accentColor),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildClientNotes(Color cardColor, Color primaryText,
      Color secondaryText, Color accentColor, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Notas del Cliente",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: accentColor)),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? Colors.blue.shade900.withOpacity(0.3)
                  : Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: isDarkMode
                      ? Colors.blue.shade800
                      : Colors.blue.shade200),
            ),
            child: Text(
              "Por favor llamar al llegar. El timbre no funciona correctamente. La tubería está en el baño principal del segundo piso.",
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: primaryText,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachedPhotos(Color cardColor, Color primaryText, Color accentColor) {
    final photos = [
      'https://images.unsplash.com/photo-1581578731548-c6a0c3f2fcc0?w=400',
      'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=400',
      'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=400',
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Fotos Adjuntas",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: accentColor)),
          const SizedBox(height: 16),
          SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: photos.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    photos[index],
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 100,
                        height: 100,
                        color: Colors.grey.shade700,
                        child: const Icon(Icons.image_not_supported,
                            color: Colors.white70),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Servicio completado')),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: const Text(
          'Marcar como Completado',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
      String label, String value, Color primaryText, Color secondaryText) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: secondaryText,
              )),
          Text(value,
              style: TextStyle(
                  fontWeight: FontWeight.w600, color: primaryText)),
        ],
      ),
    );
  }
}
