import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProviderEditProfileScreen extends StatefulWidget {
  const ProviderEditProfileScreen({super.key});
  static const String name = 'ProviderEditProfileScreen';

  @override
  State<ProviderEditProfileScreen> createState() => _ProviderEditProfileScreenState();
}

class _ProviderEditProfileScreenState extends State<ProviderEditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController(text: 'Ricardo Mendoza');
  final _professionCtrl = TextEditingController(text: 'Electricista');
  final _services = ['Reparaciones', 'Instalaciones', 'Mantenimiento'];
  final List<String> _portfolioImages = [];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _professionCtrl.dispose();
    super.dispose();
  }

  void _addService() async {
    final newService = await showDialog<String>(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return AlertDialog(
          title: const Text('Agregar servicio'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Nombre del servicio',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, controller.text.trim()),
              child: const Text('Agregar'),
            ),
          ],
        );
      },
    );

    if (newService != null && newService.isNotEmpty) {
      setState(() => _services.add(newService));
    }
  }

  void _removeService(String service) {
    setState(() => _services.remove(service));
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      // Aquí podrías actualizar los datos globales o backend
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perfil actualizado correctamente')),
      );
      context.pop(); // Regresa al perfil principal
    }
  }

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
        title: const Text('Editar Perfil'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nombre
                Text('Nombre', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nameCtrl,
                  validator: (v) => v == null || v.isEmpty ? 'Campo obligatorio' : null,
                  decoration: const InputDecoration(
                    hintText: 'Tu nombre completo',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),

                // Profesión
                Text('Profesión', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _professionCtrl,
                  validator: (v) => v == null || v.isEmpty ? 'Campo obligatorio' : null,
                  decoration: const InputDecoration(
                    hintText: 'Ej. Electricista, Plomero, Pintor...',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),

                // Servicios ofrecidos
                Text('Servicios ofrecidos', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ..._services.map((s) => Chip(
                          label: Text(s),
                          backgroundColor: colorScheme.primary.withOpacity(0.1),
                          deleteIcon: const Icon(Icons.close, size: 16),
                          onDeleted: () => _removeService(s),
                        )),
                    ActionChip(
                      label: const Text('Agregar'),
                      onPressed: _addService,
                      avatar: const Icon(Icons.add, size: 18),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Portafolio
                Text('Portafolio', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                SizedBox(
                  height: 120,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      ..._portfolioImages.map((img) => Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(img, width: 120, fit: BoxFit.cover),
                            ),
                          )),
                      GestureDetector(
                        onTap: () {
                          // Simulación de agregar imagen
                          setState(() => _portfolioImages.add(
                              'https://images.unsplash.com/photo-1581091215367-59ab6a903399?w=400'));
                        },
                        child: Container(
                          width: 120,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade400),
                          ),
                          child: const Icon(Icons.add_a_photo, size: 40, color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                // Guardar cambios
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1D3557),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Guardar Cambios',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
