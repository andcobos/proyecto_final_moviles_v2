import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'nav_bar.dart' as customNavBar;

class ServiceCompletedPage extends StatelessWidget {
  const ServiceCompletedPage({super.key});
  static const String name = 'ServiceCompletedPage';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        centerTitle: true,
        title: const Text(
          'Detalles del servicio',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User & professional info
            Row(
              children: [
                const CircleAvatar(
                  radius: 26,
                  backgroundImage: NetworkImage(
                    'https://images.unsplash.com/photo-1599566150163-29194dcaad36?w=800',
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Carlos Ramirez',
                        style: textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    Text('Electricista',
                        style:
                            textTheme.bodyMedium?.copyWith(color: Colors.grey)),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Rating summary
            Row(
              children: [
                Column(
                  children: [
                    Text(
                      '4.8',
                      style: textTheme.headlineLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: List.generate(
                        5,
                        (i) => Icon(
                          Icons.star,
                          size: 18,
                          color: Colors.amber.shade700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '124 reviews',
                      style: textTheme.bodySmall
                          ?.copyWith(color: Colors.grey.shade600),
                    ),
                  ],
                ),
                const SizedBox(width: 24),

                // Rating bars
                Expanded(
                  child: Column(
                    children: const [
                      _RatingBar(label: '5', percent: 0.70),
                      _RatingBar(label: '4', percent: 0.20),
                      _RatingBar(label: '3', percent: 0.05),
                      _RatingBar(label: '2', percent: 0.03),
                      _RatingBar(label: '1', percent: 0.02),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Section title
            Text(
              'Detalles del trabajo',
              style: textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Job details grid
            const _JobDetailRow(
              title: 'Fecha y hora',
              value: '15 de octubre, 2024,\n10:00 AM',
            ),
            const SizedBox(height: 14),
            const _JobDetailRow(
              title: 'Dirección',
              value: 'Calle Principal 123, Ciudad',
            ),
            const SizedBox(height: 14),
            const _JobDetailRow(
              title: 'Costo final',
              value: '\$150',
            ),
            const SizedBox(height: 14),
            const _JobDetailRow(
              title: 'Estado',
              value: 'Completado',
            ),

            const SizedBox(height: 32),

            // Review Button
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: const Color(0xFF063B59),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () => context.go('/dejar-resena'),
                child: const Text(
                  'Dejar una reseña',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),

      bottomNavigationBar: const customNavBar.NavBar(currentIndex: 2),
    );
  }
}

class _RatingBar extends StatelessWidget {
  final String label;
  final double percent;
  const _RatingBar({required this.label, required this.percent});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 14, child: Text(label)),
        const SizedBox(width: 6),
        Expanded(
          child: LinearProgressIndicator(
            value: percent,
            minHeight: 8,
            backgroundColor: Colors.grey.shade300,
          ),
        ),
        const SizedBox(width: 6),
        Text('${(percent * 100).round()}%'),
      ],
    );
  }
}

class _JobDetailRow extends StatelessWidget {
  final String title;
  final String value;

  const _JobDetailRow({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              )),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}
