import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../models/job.dart';
import '../../providers/auth_provider.dart';
import '../../services/job_service.dart';
import 'nav_bar.dart';

class SolicitarServicioPage extends ConsumerStatefulWidget {
  final String? serviceId; // ✅ AHORA ES OPCIONAL (nullable)
  const SolicitarServicioPage({super.key, this.serviceId});

  static const String name = 'SolicitarServicioPage';

  @override
  ConsumerState<SolicitarServicioPage> createState() =>
      _SolicitarServicioPageState();
}

class _SolicitarServicioPageState
    extends ConsumerState<SolicitarServicioPage> {
  String? selectedDate;
  String? selectedTime;
  String? selectedAddress;

  bool isLoading = false;

  final TextEditingController _descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(), // ✅ vuelve a la pantalla anterior
        ),
        centerTitle: true,
        title: const Text(
          'Solicitar servicio',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle('Descripción del trabajo'),
              const SizedBox(height: 8),
              TextField(
                controller: _descController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Describe el trabajo que necesitas...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              _sectionTitle('Fecha y hora preferidas'),
              const SizedBox(height: 12),
              _buildDateTimePickers(),
              const SizedBox(height: 24),

              _sectionTitle('Dirección'),
              const SizedBox(height: 12),
              _buildAddressInput(),
              const SizedBox(height: 32),

              _submitButton(colorScheme, user),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const NavBar(currentIndex: 2),
    );
  }

  Widget _sectionTitle(String text) => Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      );

  Widget _buildDateTimePickers() {
    return Column(
      children: [
        GestureDetector(
          onTap: _selectDate,
          child: _inputBox(
            icon: Icons.calendar_today,
            label: selectedDate ?? 'Seleccionar fecha',
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: _selectTime,
          child: _inputBox(
            icon: Icons.access_time,
            label: selectedTime ?? 'Seleccionar hora',
          ),
        ),
      ],
    );
  }

  Widget _inputBox({required IconData icon, required String label}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey.shade700),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              color: label.contains('Seleccionar')
                  ? Colors.grey.shade600
                  : Colors.black,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressInput() {
    return TextField(
      onChanged: (value) => selectedAddress = value,
      decoration: InputDecoration(
        hintText: 'Ingresar dirección',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _submitButton(ColorScheme colorScheme, user) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        onPressed: isLoading
            ? null
            : () async {
                if (_descController.text.isEmpty ||
                    selectedDate == null ||
                    selectedTime == null ||
                    selectedAddress == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Por favor completa todos los campos'),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                  return;
                }

                // 🚨 Validamos si serviceId llegó correctamente
                if (widget.serviceId == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'Error: No se recibió el ID del servicio. Intenta nuevamente.'),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                  return;
                }

                setState(() => isLoading = true);
                try {
                  final newJob = CreateJobRequest(
                    serviceId: widget.serviceId!,
                    description: _descController.text,
                  );

                  final createdJob = await JobService().createJob(newJob);

                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          createdJob != null
                              ? 'Trabajo creado con éxito: ${createdJob.id}'
                              : 'Trabajo creado con éxito',
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );
                    context.go('/pago');
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error al enviar la solicitud: $e'),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                } finally {
                  if (mounted) setState(() => isLoading = false);
                }
              },
        child: isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text(
                'Enviar solicitud',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        selectedDate = '${picked.day}/${picked.month}/${picked.year}';
      });
    }
  }

  Future<void> _selectTime() async {
    final picked =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null) {
      setState(() {
        selectedTime =
            '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      });
    }
  }
}
