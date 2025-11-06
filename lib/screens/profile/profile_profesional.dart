import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../home/nav_bar.dart' as customNavBar;

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  static const String name = 'ProfilePage';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        centerTitle: true,
        title: Text(
          'Perfil',
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              const SizedBox(height: 8),

              // Avatar + nombre + oficio
              const CircleAvatar(
                radius: 48,
                backgroundImage: NetworkImage(
                  'https://images.unsplash.com/photo-1599566150163-29194dcaad36?w=800',
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Ricardo Mendoza',
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Electricista',
                style: textTheme.titleMedium?.copyWith(
                  color: textTheme.bodyMedium?.color?.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 12),

              // Botón Contactar (ahora usa tema dinámico)
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: colorScheme.surfaceContainerHighest,
                    foregroundColor: colorScheme.onSurface,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () => ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('Contactar'))),
                  child: const Text(
                    'Contactar',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Botón Ajustes
              SizedBox(
                width: double.infinity,
                child: FilledButton.tonal(
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () => context.go('/ajustes'),
                  child: const Text(
                    'Ajustes',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Servicios - card
              _SectionTitle(text: 'Servicios'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: const [
                  _ServiceCard(icon: Icons.build, label: 'Reparaciones'),
                  _ServiceCard(icon: Icons.brush, label: 'Pintura'),
                  _ServiceCard(icon: Icons.plumbing, label: 'Instalaciones'),
                ],
              ),
              const SizedBox(height: 20),

              // Trabajos galería horizontal
              _SectionTitle(text: 'Trabajos'),
              const SizedBox(height: 8),
              SizedBox(
                height: 170,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _works.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final w = _works[index];
                    return SizedBox(
                      width: 180,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Image.network(
                              w.imageUrl,
                              height: 120,
                              width: 180,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            w.caption,
                            style: textTheme.bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),

              // Testimonios
              _SectionTitle(text: 'Testimonios'),
              const SizedBox(height: 8),
              const _TestimonialCard(
                avatarUrl:
                    'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200',
                name: 'Sofía G.',
                when: 'Hace 2 semanas',
                rating: 5,
                comment:
                    'Ricardo hizo un trabajo excelente en mi casa. Muy profesional y eficiente.',
                likes: 2,
                replies: 0,
              ),
              const SizedBox(height: 12),
              const _TestimonialCard(
                avatarUrl:
                    'https://images.unsplash.com/photo-1547425260-76bcadfb4f2c?w=200',
                name: 'Carlos R.',
                when: 'Hace 1 mes',
                rating: 4,
                comment: 'Buen servicio, aunque hubo un pequeño retraso.',
                likes: 1,
                replies: 0,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const customNavBar.NavBar(currentIndex: 3),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle({required this.text});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: Theme.of(context)
            .textTheme
            .titleLarge
            ?.copyWith(fontWeight: FontWeight.w800),
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final IconData icon;
  final String label;
  const _ServiceCard({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: colorScheme.outline.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: colorScheme.primary),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}

class _TestimonialCard extends StatelessWidget {
  final String avatarUrl;
  final String name;
  final String when;
  final int rating; // 1..5
  final String comment;
  final int likes;
  final int replies;

  const _TestimonialCard({
    required this.avatarUrl,
    required this.name,
    required this.when,
    required this.rating,
    required this.comment,
    required this.likes,
    required this.replies,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: colorScheme.outline.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                CircleAvatar(backgroundImage: NetworkImage(avatarUrl)),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      when,
                      style: textTheme.bodySmall?.copyWith(
                        color: textTheme.bodySmall?.color?.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Rating
            Row(
              children: List.generate(
                5,
                (i) => Icon(
                  i < rating ? Icons.star : Icons.star_border,
                  size: 18,
                  color: Colors.amber.shade700,
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Comment
            Text(comment, style: textTheme.bodyMedium),

            const SizedBox(height: 10),

            // Actions
            Row(
              children: [
                const Icon(Icons.thumb_up_alt_outlined, size: 18),
                const SizedBox(width: 6),
                Text('$likes'),
                const SizedBox(width: 16),
                const Icon(Icons.mode_comment_outlined, size: 18),
                const SizedBox(width: 6),
                Text('$replies'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _WorkItem {
  final String imageUrl;
  final String caption;
  const _WorkItem(this.imageUrl, this.caption);
}

const _works = <_WorkItem>[
  _WorkItem(
    'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=800',
    'Instalación eléctrica',
  ),
  _WorkItem(
    'https://images.unsplash.com/photo-1497366754035-f200968a6e72?w=800',
    'Pintura de interiores',
  ),
  _WorkItem(
    'https://images.unsplash.com/photo-1493666438817-866a91353ca9?w=800',
    'Reparación eléctrica',
  ),
];
