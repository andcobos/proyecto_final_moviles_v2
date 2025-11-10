import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// IMPORTA PANTALLAS DE AUTENTICACIÓN
import '../../screens/landing_login/landing_page.dart';
import '../../screens/landing_login/client_login_page.dart';
import '../../screens/landing_login/client_register_page.dart';
import '../../screens/landing_login/provider_login_page.dart';
import '../../screens/landing_login/provider_register_page.dart';

// IMPORTA PANTALLAS DE CLIENTE
import '../../screens/client/home_screen.dart';
import '../../screens/client/categories.dart';
import '../../screens/client/servicios.dart';
import '../../screens/client/solicitar_servicio.dart';
import '../../screens/client/notificaciones.dart';
import '../../screens/client/payment_screen.dart';
import '../../screens/provider/prof_settings.dart';
import '../../screens/client/details_service.dart';
import '../../screens/client/reseña.dart';
import '../../screens/client/profile.dart';


// IMPORTA PANTALLAS DE PROVEEDOR
import '../../screens/provider/provider_home.dart';
import '../../screens/provider/provider_jobs.dart';
import '../../screens/provider/provider_services.dart';
import '../../screens/provider/provider_agenda.dart';
import '../../screens/provider/provider_profile.dart';
import '../../screens/provider/provider_service_details.dart';
import '../../screens/provider/provider_edit_profile.dart';
import '../../screens/provider/provider_profile_settings.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    // 1) Landing (compartida)
    GoRoute(
      path: '/',
      name: LandingPage.name,
      builder: (context, state) => const LandingPage(),
    ),

    // 2) Auth CLIENTE
    GoRoute(
      path: '/auth/client/login',
      name: ClientLoginPage.name,
      builder: (context, state) => const ClientLoginPage(),
    ),
    GoRoute(
      path: '/auth/client/register',
      name: ClientRegisterPage.name,
      builder: (context, state) => const ClientRegisterPage(),
    ),

    // 3) Auth PROVEEDOR
    GoRoute(
      path: '/auth/provider/login',
      name: ProviderLoginPage.name,
      builder: (context, state) => const ProviderLoginPage(),
    ),
    GoRoute(
      path: '/auth/provider/register',
      name: ProviderRegisterPage.name,
      builder: (context, state) => const ProviderRegisterPage(),
    ),

    // 4) FLUJO CLIENTE - Buscar Servicios
    GoRoute(
      path: '/home',
      name: HomeScreen.name,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/buscar',
      name: CategoriesPage.name,
      builder: (context, state) => const CategoriesPage(),
    ),
    GoRoute(
      path: '/servicios',
      name: MyServicesPage.name,
      builder: (context, state) => const MyServicesPage(),
    ),
    GoRoute(
      path: '/perfil',
      name: ProfilePage.name,
      builder: (context, state) => const ProfilePage(),
    ),
GoRoute(
      path: '/solicitar-servicio/:id',
      name: SolicitarServicioPage.name,
      builder: (context, state) {
        // 🧠 Recoge el id desde parámetros de la URL
        final serviceId = state.pathParameters['id'];
        debugPrint('🟩 ID recibido desde URL: $serviceId');
        return SolicitarServicioPage(serviceId: serviceId);
      },
    ),

    GoRoute(
      path: '/notificaciones',
      name: NotificacionesPage.name,
      builder: (context, state) => const NotificacionesPage(),
    ),
    GoRoute(
      path: '/servicio/detalles',
      name: DetailsServicePage.name,
      builder: (context, state) => const DetailsServicePage(),
    ),
    GoRoute(
      path: '/dejar-resena',
      name: ReviewScreen.name,
      builder: (context, state) => const ReviewScreen(),
    ),
    GoRoute(
      path: '/pago',
      name: PaymentScreen.name,
      builder: (context, state) => const PaymentScreen(),
    ),
    GoRoute(
      path: '/ajustes',
      name: UserSettingsScreen.name,
      builder: (context, state) => const UserSettingsScreen(),
    ),

    // 5) FLUJO PROVEEDOR - Brindar Servicios
    GoRoute(
      path: '/pro/home',
      name: ProviderHomeScreen.name,
      builder: (context, state) => const ProviderHomeScreen(),
    ),
    GoRoute(
      path: '/pro/trabajos',
      name: ProviderJobsScreen.name,
      builder: (context, state) => const ProviderJobsScreen(),
    ),
    GoRoute(
      path: '/pro/servicios',
      name: ProviderServicesScreen.name,
      builder: (context, state) => const ProviderServicesScreen(),
    ),
    GoRoute(
      path: '/pro/agenda',
      name: ProviderAgendaScreen.name,
      builder: (context, state) => const ProviderAgendaScreen(),
    ),
    GoRoute(
      path: '/pro/perfil',
      name: ProviderProfileScreen.name,
      builder: (context, state) => const ProviderProfileScreen(),
    ),
    GoRoute(
      path: '/pro/servicio/detalles',
      name: ProviderServiceDetailsScreen.name,
      builder: (context, state) => const ProviderServiceDetailsScreen(),
    ),
    GoRoute(
      path: '/pro/editar-perfil',
      name: ProviderEditProfileScreen.name,
      builder: (context, state) => const ProviderEditProfileScreen(),
    ),
    GoRoute(
      path: '/pro/ajustes',
      name: ProviderProfileSettingsScreen.name,
      builder: (context, state) => const ProviderProfileSettingsScreen(),
    ),
  ],
);
