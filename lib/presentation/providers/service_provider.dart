import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/service.dart';
import 'auth_provider.dart';
import '../../data/services/service_services.dart';

/// Provider que obtiene los servicios del contratista autenticado
final contractorServicesProvider = FutureProvider<List<Service>>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return [];

  final serviceService = ServiceService();
  // ✅ ahora obtiene los servicios del usuario autenticado correctamente
  return await serviceService.getMyServices();
});
