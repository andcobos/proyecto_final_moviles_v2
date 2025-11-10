import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/service.dart';
import '../../../data/services/service_services.dart';
import 'provider_nav_bar.dart';

class ProviderEditProfileScreen extends ConsumerStatefulWidget {
  const ProviderEditProfileScreen({super.key});
  static const String name = 'ProviderEditProfileScreen';

  @override
  ConsumerState<ProviderEditProfileScreen> createState() =>
      _ProviderEditProfileScreenState();
}

class _ProviderEditProfileScreenState
    extends ConsumerState<ProviderEditProfileScreen> {
  final List<ServiceInput> _services = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadExistingServices();
  }

  Future<void> _loadExistingServices() async {
    try {
      final serviceService = ServiceService();
      final existing = await serviceService.getMyServices();

      setState(() {
        _services.clear();
        _services.addAll(
          existing.map((s) => ServiceInput(
            name: s.name,
            description: s.description,
            rate: s.rate,
          )),
        );
      });
    } catch (e) {
      debugPrint("Error cargando servicios: $e");
    }
  }

  void _addService() {
    setState(() {
      _services.add(ServiceInput(name: '', description: '', rate: 0));
    });
  }

  void _removeService(int index) {
    setState(() {
      _services.removeAt(index);
    });
  }

  Future<void> _saveServices() async {
    setState(() => _isLoading = true);

    try {
      final serviceService = ServiceService();
      final payload = {
        "services": _services.map((s) => s.toJson()).toList(),
      };

      await serviceService.updateMyServices(payload);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Servicios actualizados correctamente"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error al guardar: $e"),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFF1D3557);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Perfil'),
        centerTitle: true,
        backgroundColor: accent,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Servicios ofrecidos",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Agrega los servicios que ofreces junto con su descripción y tarifa.",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 16),

              if (_services.isEmpty)
                const Center(
                  child: Text(
                    "No tienes servicios aún. Agrega uno nuevo.",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),

              ..._services.asMap().entries.map((entry) {
                final index = entry.key;
                final service = entry.value;
                return _buildServiceCard(service, index, isDark);
              }),

              const SizedBox(height: 16),
              Center(
                child: OutlinedButton.icon(
                  onPressed: _addService,
                  icon: const Icon(Icons.add),
                  label: const Text("Agregar servicio"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: accent,
                    side: BorderSide(color: accent),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _saveServices,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.save),
                  label: Text(
                      _isLoading ? "Guardando..." : "Guardar cambios"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const ProviderNavBar(currentIndex: 4),
    );
  }

  Widget _buildServiceCard(ServiceInput service, int index, bool isDark) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: TextEditingController(text: service.name),
              decoration: const InputDecoration(
                labelText: 'Nombre del servicio',
                prefixIcon: Icon(Icons.build),
              ),
              onChanged: (value) => service.name = value,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: TextEditingController(text: service.description),
              decoration: const InputDecoration(
                labelText: 'Descripción',
                prefixIcon: Icon(Icons.description),
              ),
              onChanged: (value) => service.description = value,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: TextEditingController(text: service.rate.toString()),
              decoration: const InputDecoration(
                labelText: 'Tarifa (\$)',
                prefixIcon: Icon(Icons.monetization_on),
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              onChanged: (value) =>
                  service.rate = double.tryParse(value) ?? 0.0,
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(Icons.delete, color: Colors.redAccent),
                onPressed: () => _removeService(index),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
