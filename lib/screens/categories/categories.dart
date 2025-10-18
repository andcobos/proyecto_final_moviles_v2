import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../home/nav_bar.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});
  static const String name = 'CategoriesPage';

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        centerTitle: true,
        title: Text(
          'Buscar',
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Barra de búsqueda (no funcional)
              TextField(
                readOnly: true,
                onTap: () => ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Búsqueda'))),
                decoration: InputDecoration(
                  hintText: 'Buscar',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: const Color(0xFFF1F3F5),
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Título categorías
              Text(
                'Categorías populares',
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),

              // ---------- GRID de categorías (sin overflow) ----------
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _categories.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  // Más alto que ancho para que quepa imagen + label
                  childAspectRatio: 0.78, // prueba 0.75–0.80 si necesitas
                ),
                itemBuilder: (context, i) => _CategoryCard(cat: _categories[i]),
              ),

              const SizedBox(height: 24),

              // recomendados
              Text(
                'Servicios recomendados',
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),

              const _RecommendedTile(
                title: 'Reparación de electrodomésticos',
                description:
                    'Encuentra profesionales para reparar lavadoras, neveras y más.',
                imageUrl:
                    'https://images.unsplash.com/photo-1581579188871-c0d5f5f6d0f0?w=800',
              ),
              const SizedBox(height: 12),
              const _RecommendedTile(
                title: 'Instalación de aire acondicionado',
                description:
                    'Instalación y mantenimiento de sistemas de aire acondicionado.',
                imageUrl:
                    'https://images.unsplash.com/photo-1581091215367-59ab7b75c59b?w=800',
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),

      // Botón flotante para solicitar servicio
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.go('/solicitar-servicio');
        },
        backgroundColor: const Color(0xFF0D2B45),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Solicitar Servicio',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),

      // Bottom nav inline
      bottomNavigationBar: const NavBar(currentIndex: 1),
    );
  }
}

/* =====================  DATA  ===================== */

class _Cat {
  final String title, imageUrl;
  const _Cat(this.title, this.imageUrl);
}

const _categories = <_Cat>[
  _Cat(
    'Electricistas',
    'https://images.unsplash.com/photo-1581092795360-fd1ca04f0952?w=800',
  ),
  _Cat(
    'Fontaneros',
    'https://images.unsplash.com/photo-1562232576-cd4b4e42e6f5?w=800',
  ),
  _Cat(
    'Pintores',
    'https://images.unsplash.com/photo-1506629082955-511b1aa562c8?w=800',
  ),
  _Cat(
    'Carpinteros',
    'https://images.unsplash.com/photo-1519710164239-da123dc03ef4?w=800',
  ),
  _Cat(
    'Jardineros',
    'https://images.unsplash.com/photo-1466692476868-aef1dfb1e735?w=800',
  ),
  _Cat(
    'Limpieza',
    'https://images.unsplash.com/photo-1581578017421-38b6a6b98d0a?w=800',
  ),
];

/* ==============  WIDGETS DE LA PANTALLA  ============== */

class _CategoryCard extends StatelessWidget {
  final _Cat cat;
  const _CategoryCard({required this.cat});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen cuadrada
          AspectRatio(
            aspectRatio: 1,
            child: Image.network(
              cat.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: Colors.grey.shade200,
                child: const Center(child: Icon(Icons.broken_image_outlined)),
              ),
            ),
          ),
          // Label con altura controlada (evita desbordes)
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
            child: Text(
              cat.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: t.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecommendedTile extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;
  const _RecommendedTile({
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ConstrainedBox(
        // altura mínima para alinear bien texto e imagen
        constraints: const BoxConstraints(minHeight: 110),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Texto (con límites de líneas para evitar "vertical letters")
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Imagen fija
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  imageUrl,
                  width: 96,
                  height: 96,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 96,
                    height: 96,
                    color: Colors.grey.shade200,
                    child: const Center(
                      child: Icon(Icons.broken_image_outlined),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
