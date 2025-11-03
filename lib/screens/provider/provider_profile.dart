import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'provider_nav_bar.dart';

class ProviderProfileScreen extends StatelessWidget {
  const ProviderProfileScreen({super.key});
  static const String name = 'ProviderProfileScreen';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    final backgroundColor = isDarkMode ? const Color(0xFF121212) : Colors.grey.shade100;
    final cardColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final primaryTextColor = isDarkMode ? Colors.white : const Color(0xFF1D3557);
    final secondaryTextColor = isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600;
    final accentColor = const Color(0xFF1D3557);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: cardColor,
        centerTitle: true,
        title: Text(
          "Mi Perfil",
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: primaryTextColor,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: primaryTextColor),
            onPressed: () => context.push('/pro/ajustes'),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    if (!isDarkMode)
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                  ],
                ),
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(
                        'https://images.unsplash.com/photo-1599566150163-29194dcaad36?w=800',
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Ricardo Mendoza',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: primaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Electricista • 4.8 ⭐ • 124 reseñas',
                      style: TextStyle(fontSize: 14, color: secondaryTextColor),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: _buildStatItem('Trabajos', '156', primaryTextColor, secondaryTextColor)),
                        Expanded(child: _buildStatItem('Clientes', '89', primaryTextColor, secondaryTextColor)),
                        Expanded(child: _buildStatItem('Años Exp.', '8', primaryTextColor, secondaryTextColor)),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => context.push('/pro/editar-perfil'),
                  icon: const Icon(Icons.edit),
                  label: const Text('Editar Perfil'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              _buildSection(
                title: 'Servicios Ofrecidos',
                children: [
                  _buildServiceChip('Reparaciones Eléctricas', accentColor, isDarkMode),
                  _buildServiceChip('Instalaciones', accentColor, isDarkMode),
                  _buildServiceChip('Mantenimiento', accentColor, isDarkMode),
                  _buildServiceChip('Consultoría', accentColor, isDarkMode),
                ],
                cardColor: cardColor,
                primaryTextColor: primaryTextColor,
                isDarkMode: isDarkMode,
              ),

              const SizedBox(height: 24),

              _buildPortfolioSection(cardColor, primaryTextColor, isDarkMode),

              const SizedBox(height: 24),

              _buildTestimonialsSection(cardColor, primaryTextColor, secondaryTextColor, isDarkMode),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const ProviderNavBar(currentIndex: 4),
    );
  }

  Widget _buildStatItem(String label, String value, Color textColor, Color secondary) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12, color: secondary)),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
    required Color cardColor,
    required Color primaryTextColor,
    required bool isDarkMode,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          if (!isDarkMode)
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryTextColor)),
          const SizedBox(height: 16),
          Wrap(spacing: 8, runSpacing: 8, children: children),
        ],
      ),
    );
  }

  Widget _buildServiceChip(String service, Color accentColor, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isDarkMode ? accentColor.withOpacity(0.25) : accentColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accentColor.withOpacity(0.3)),
      ),
      child: Text(
        service,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: isDarkMode ? Colors.white : accentColor,
        ),
      ),
    );
  }

  Widget _buildPortfolioSection(Color cardColor, Color textColor, bool isDarkMode) {
    final works = [
      {'image': 'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=400', 'title': 'Instalación eléctrica'},
      {'image': 'https://images.unsplash.com/photo-1497366754035-f200968a6e72?w=400', 'title': 'Reparación de panel'},
      {'image': 'https://images.unsplash.com/photo-1493666438817-866a91353ca9?w=400', 'title': 'Cableado moderno'},
      {'image': 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400', 'title': 'Iluminación LED'},
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          if (!isDarkMode)
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Portafolio',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                )),
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add, size: 16),
              label: const Text('Agregar'),
            ),
          ]),
          const SizedBox(height: 16),
          SizedBox(
            height: 160, 
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: works.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final work = works[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: SizedBox(
                        width: 120,
                        height: 120,
                        child: Image.network(
                          work['image']!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: Colors.grey.shade800,
                            child: const Icon(Icons.image_not_supported, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: 120,
                      child: Text(
                        work['title']!,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestimonialsSection(Color cardColor, Color textColor, Color secondary, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          if (!isDarkMode)
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Testimonios',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
          const SizedBox(height: 16),
          _buildTestimonialCard('Sofía G.', 'Hace 2 semanas', 5,
              'Ricardo hizo un trabajo excelente en mi casa. Muy profesional y eficiente.', isDarkMode),
          const SizedBox(height: 12),
          _buildTestimonialCard('Carlos R.', 'Hace 1 mes', 4,
              'Buen servicio, aunque hubo un pequeño retraso.', isDarkMode),
          const SizedBox(height: 12),
          _buildTestimonialCard('Ana M.', 'Hace 2 meses', 5,
              'Excelente profesional, muy recomendado. Trabajo de calidad.', isDarkMode),
        ],
      ),
    );
  }

  Widget _buildTestimonialCard(
      String name, String time, int rating, String comment, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF2A2A2A) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            CircleAvatar(
              radius: 16,
              backgroundColor:
                  isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
              child: Text(name[0],
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: isDarkMode ? Colors.white : Colors.black)),
                  Text(time,
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                ],
              ),
            ),
            Row(
              children: List.generate(
                5,
                (i) => Icon(
                  i < rating ? Icons.star : Icons.star_border,
                  size: 16,
                  color: Colors.amber.shade700,
                ),
              ),
            ),
          ]),
          const SizedBox(height: 8),
          Text(comment,
              style: TextStyle(
                  fontSize: 14,
                  color: isDarkMode ? Colors.white70 : Colors.grey.shade700)),
        ],
      ),
    );
  }
}
