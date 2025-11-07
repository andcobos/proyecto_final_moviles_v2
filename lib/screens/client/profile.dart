import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'nav_bar.dart' as customNavBar;

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
        centerTitle: true,
        title: Text(
          'Mi Perfil',
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push('/ajustes'),
          ),
        ],
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 48,
                backgroundImage: NetworkImage(
                  'https://images.unsplash.com/photo-1607746882042-944635dfe10e?w=800',
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Sofía Ramírez',
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Servicios del Hogar',
                style: textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 20),

              // Servicios Agendados
              _SectionHeader('Servicios Agendados'),
              const _ServiceList(),
              const SizedBox(height: 20),

              // Portafolio
              _SectionHeader('Portafolio'),
              const SizedBox(height: 8),
              const _PortfolioList(),
              const SizedBox(height: 20),

              // Testimonios
              _SectionHeader('Testimonios'),
              const SizedBox(height: 12),
              const _TestimonialCard(
                avatarUrl:
                    'https://images.unsplash.com/photo-1547425260-76bcadfb4f2c?w=200',
                name: 'Carlos R.',
                when: 'Hace 1 mes',
                rating: 5,
                comment:
                    'Sofía fue muy amable cuando fui a trabajar en su casa.',
                likes: 1,
                replies: 0,
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: const customNavBar.NavBar(currentIndex: 3),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String text;
  const _SectionHeader(this.text);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}

// LISTA DE SERVICIOS AGENDADOS
class _ServiceList extends StatelessWidget {
  const _ServiceList();

  @override
  Widget build(BuildContext context) {
    final services = [
      ['Limpieza del Hogar', Icons.cleaning_services],
      ['Cuidado de Mascotas', Icons.pets],
      ['Jardinería', Icons.local_florist],
    ];

    return Column(
      children: services
          .map(
            (s) => ListTile(
              dense: true,
              leading: Icon(s[1] as IconData, color: Colors.blueAccent),
              title: Text(
                s[0] as String,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          )
          .toList(),
    );
  }
}

// PORTAFOLIO
class _PortfolioList extends StatelessWidget {
  const _PortfolioList();

  @override
  Widget build(BuildContext context) {
    final items = [
      ['https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=800', 'Sala de estar moderna'],
      ['https://images.unsplash.com/photo-1497366754035-f200968a6e72?w=800', 'Cocina minimalista'],
      ['https://images.unsplash.com/photo-1493666438817-866a91353ca9?w=800', 'Baño elegante'],
    ];

    return SizedBox(
      height: 165,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  items[i][0],
                  width: 160,
                  height: 110,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _fallbackImg(160,110),
                ),
              ),
              const SizedBox(height: 6),
              SizedBox(
                width: 150,
                child: Text(
                  items[i][1],
                  style: const TextStyle(fontWeight: FontWeight.w600),
                  maxLines: 2,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// TESTIMONIOS
class _TestimonialCard extends StatelessWidget {
  final String avatarUrl;
  final String name;
  final String when;
  final int rating;
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

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(backgroundImage: NetworkImage(avatarUrl)),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    Text(when, style: TextStyle(color: Colors.grey.shade600)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: List.generate(5, (i) => Icon(
                i < rating ? Icons.star : Icons.star_border,
                size: 18,
                color: Colors.amber.shade700,
              )),
            ),
            const SizedBox(height: 8),
            Text(comment, style: textTheme.bodyMedium),
            const SizedBox(height: 10),
            Row(
              children: const [
                Icon(Icons.thumb_up_alt_outlined, size: 18),
                SizedBox(width: 4),
                Text('1'),
                SizedBox(width: 16),
                Icon(Icons.mode_comment_outlined, size: 18),
                SizedBox(width: 4),
                Text('0'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget _fallbackImg(double w, double h) {
  return Container(
    width: w,
    height: h,
    color: Colors.grey.shade200,
    child: const Icon(Icons.image_not_supported),
  );
}
