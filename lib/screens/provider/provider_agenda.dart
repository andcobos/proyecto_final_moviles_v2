import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'provider_nav_bar.dart';

class ProviderAgendaScreen extends StatefulWidget {
  const ProviderAgendaScreen({super.key});
  static const String name = 'ProviderAgendaScreen';

  @override
  State<ProviderAgendaScreen> createState() => _ProviderAgendaScreenState();
}

class _ProviderAgendaScreenState extends State<ProviderAgendaScreen> {
  DateTime selectedDate = DateTime.now();

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
        centerTitle: true,
        title: Text(
          "Mi Agenda",
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.today),
            onPressed: _selectDate,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Calendario mensual
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Header del calendario
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${_getMonthName(selectedDate.month)} ${selectedDate.year}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.chevron_left),
                              onPressed: () {
                                setState(() {
                                  selectedDate = DateTime(
                                    selectedDate.year,
                                    selectedDate.month - 1,
                                  );
                                });
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.chevron_right),
                              onPressed: () {
                                setState(() {
                                  selectedDate = DateTime(
                                    selectedDate.year,
                                    selectedDate.month + 1,
                                  );
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Grid del calendario
                    _buildCalendarGrid(),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Citas programadas
              const Text(
                "Citas Programadas",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _buildScheduledAppointments(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const ProviderNavBar(currentIndex: 3),
    );
  }

  Widget _buildCalendarGrid() {
    final firstDayOfMonth = DateTime(selectedDate.year, selectedDate.month, 1);
    final lastDayOfMonth = DateTime(selectedDate.year, selectedDate.month + 1, 0);
    final firstWeekday = firstDayOfMonth.weekday;
    final daysInMonth = lastDayOfMonth.day;

    // Días de la semana
    final weekDays = ['L', 'M', 'X', 'J', 'V', 'S', 'D'];

    return Column(
      children: [
        // Header de días de la semana
        Row(
          children: weekDays.map((day) => Expanded(
            child: Center(
              child: Text(
                day,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
          )).toList(),
        ),
        const SizedBox(height: 8),
        // Grid de días
        ...List.generate(6, (weekIndex) {
          return Row(
            children: List.generate(7, (dayIndex) {
              final dayNumber = weekIndex * 7 + dayIndex - firstWeekday + 2;
              
              if (dayNumber < 1 || dayNumber > daysInMonth) {
                return const Expanded(child: SizedBox(height: 40));
              }

              final isToday = DateTime.now().year == selectedDate.year &&
                             DateTime.now().month == selectedDate.month &&
                             DateTime.now().day == dayNumber;

              final hasAppointment = _hasAppointment(dayNumber);

              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedDate = DateTime(selectedDate.year, selectedDate.month, dayNumber);
                    });
                  },
                  child: Container(
                    height: 40,
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: isToday 
                          ? const Color(0xFF1D3557)
                          : hasAppointment 
                              ? Colors.orange.shade100
                              : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        '$dayNumber',
                        style: TextStyle(
                          color: isToday 
                              ? Colors.white
                              : hasAppointment 
                                  ? Colors.orange.shade800
                                  : Colors.black,
                          fontWeight: isToday || hasAppointment 
                              ? FontWeight.bold 
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          );
        }),
      ],
    );
  }

  Widget _buildScheduledAppointments() {
    final appointments = _getAppointmentsForDate(selectedDate);

    if (appointments.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(Icons.event_available, size: 48, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            Text(
              "No hay citas programadas",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "para el ${selectedDate.day} de ${_getMonthName(selectedDate.month)}",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: appointments.map((appointment) => 
        _buildAppointmentCard(appointment)
      ).toList(),
    );
  }

  Widget _buildAppointmentCard(Map<String, dynamic> appointment) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: appointment['color'].withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                appointment['icon'],
                color: appointment['color'],
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appointment['service'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Cliente: ${appointment['client']}",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 14, color: Colors.grey.shade500),
                      const SizedBox(width: 4),
                      Text(
                        appointment['time'],
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 14, color: Colors.grey.shade500),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          appointment['address'],
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: appointment['statusColor'].withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                appointment['status'],
                style: TextStyle(
                  fontSize: 12,
                  color: appointment['statusColor'],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  String _getMonthName(int month) {
    const months = [
      'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
    ];
    return months[month - 1];
  }

  bool _hasAppointment(int day) {
    // Simular citas en ciertos días
    final appointments = [15, 18, 22, 25, 28];
    return appointments.contains(day);
  }

  List<Map<String, dynamic>> _getAppointmentsForDate(DateTime date) {
    // Simular citas para la fecha seleccionada
    if (date.day == 15) {
      return [
        {
          'service': 'Reparación de tuberías',
          'client': 'Sofía Ramírez',
          'time': '10:00 AM',
          'address': 'Calle Principal 123',
          'status': 'Pendiente',
          'statusColor': Colors.orange,
          'color': Colors.blue,
          'icon': Icons.plumbing,
        },
        {
          'service': 'Instalación eléctrica',
          'client': 'Carlos Mendoza',
          'time': '2:00 PM',
          'address': 'Avenida Central 456',
          'status': 'Confirmado',
          'statusColor': Colors.green,
          'color': Colors.orange,
          'icon': Icons.electrical_services,
        },
      ];
    } else if (date.day == 18) {
      return [
        {
          'service': 'Mantenimiento de jardín',
          'client': 'Ana López',
          'time': '9:00 AM',
          'address': 'Calle Secundaria 789',
          'status': 'Confirmado',
          'statusColor': Colors.green,
          'color': Colors.green,
          'icon': Icons.local_florist,
        },
      ];
    }
    return [];
  }
}
