import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProviderNavBar extends StatelessWidget {
  final int currentIndex;

  const ProviderNavBar({super.key, required this.currentIndex});

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/pro/home'); // Inicio
        break;
      case 1:
        context.go('/pro/trabajos'); // Trabajos Asignados
        break;
      case 2:
        context.go('/pro/servicios'); // Mis Servicios
        break;
      case 3:
        context.go('/pro/agenda'); // Mi Agenda
        break;
      case 4:
        context.go('/pro/perfil'); // Perfil
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      selectedItemColor: const Color(0xFF1D3557),
      unselectedItemColor: Colors.grey,
      onTap: (index) => _onItemTapped(context, index),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: "Inicio",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.work_outline),
          activeIcon: Icon(Icons.work),
          label: "Trabajos",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.build_outlined),
          activeIcon: Icon(Icons.build),
          label: "Servicios",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today_outlined),
          activeIcon: Icon(Icons.calendar_today),
          label: "Agenda",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: "Perfil",
        ),
      ],
    );
  }
}
