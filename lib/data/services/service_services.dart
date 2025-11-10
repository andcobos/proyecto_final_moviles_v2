import '../../core/constants.dart';
import '../models/service.dart';
import 'api_service.dart';

/// ServiceService
/// Maneja la obtención y creación de servicios en el backend
class ServiceService {
  final ApiService _api = ApiService();

  /// Obtener todos los servicios disponibles
  Future<List<dynamic>> getAllServices() async {
  final response = await _api.get(ApiConstants.services);
  return response as List;
  }


  /// Obtener un servicio específico por su ID
  Future<Service> getServiceById(String id) async {
    final response = await _api.get('${ApiConstants.services}/$id');
    return Service.fromJson(response as Map<String, dynamic>);
  }

  /// Crear un nuevo servicio (solo para proveedores)
  Future<Service> createService(ServiceInput input) async {
    final response = await _api.post(ApiConstants.services, input.toJson());
    return Service.fromJson(response as Map<String, dynamic>);
  }

  /// Eliminar un servicio
  Future<void> deleteService(String id) async {
    await _api.delete('${ApiConstants.services}/$id');
  }
}
