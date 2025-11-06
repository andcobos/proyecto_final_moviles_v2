import 'package:flutter/material.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final TextEditingController reviewController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Reseña",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            // Perfil
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.network(
                    "https://i.pravatar.cc/150?img=12",
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Icon(Icons.person),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Carlos Ramirez",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Text("Electricista", style: TextStyle(fontSize: 14, color: Colors.grey)),
                  ],
                )
              ],
            ),

            const SizedBox(height: 20),

            // Rating
            const Text(
              "4.8",
              style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
            ),

            Row(
              children: List.generate(5, (index) {
                return const Icon(Icons.star, size: 22, color: Colors.orange);
              }),
            ),

            const SizedBox(height: 6),
            const Text("124 reviews", style: TextStyle(color: Colors.grey)),

            const SizedBox(height: 20),

            // Barras de rating
            _ratingBar("5", 0.70),
            _ratingBar("4", 0.20),
            _ratingBar("3", 0.05),
            _ratingBar("2", 0.03),
            _ratingBar("1", 0.02),

            const SizedBox(height: 25),

            const Text(
              "Agregar comentario",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Input comentario
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: reviewController,
                maxLines: 4,
                decoration: const InputDecoration.collapsed(
                  hintText: "Deja aquí tu comentario o testimonio de esta persona",
                ),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () {
            // Acción guardar o enviar
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF003049),
            minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text(
            "Listo",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

Widget _ratingBar(String stars, double value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Row(
      children: [
        Text(stars),
        const SizedBox(width: 4),
        Expanded(
          child: LinearProgressIndicator(
            value: value,
            minHeight: 6,
          ),
        ),
        const SizedBox(width: 4),
        Text("${(value * 100).round()}%"),
      ],
    ),
  );
}
