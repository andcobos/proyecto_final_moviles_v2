import '../../core/constants.dart';
import '../models/service.dart';
import 'api_service.dart';

/// ServiceService
/// Maneja la obtención y creación de servicios en el backend
class ServiceService {
  final ApiService _api = ApiService();

  /// ✅ Obtener los servicios del contratista autenticado
  Future<List<Service>> getMyServices() async {
    final response = await _api.get('${ApiConstants.users}/me', includeAuth: true);

    // ⚙️ El backend devuelve { "services": [ {...}, {...} ] }
    final data = (response is Map<String, dynamic> && response.containsKey('services'))
        ? response['services']
        : [];

    if (data is List) {
      return data
          .map((json) => Service.fromJson(json as Map<String, dynamic>))
          .toList();
    }

    return [];
  }

  /// ✅ Obtener todos los servicios ofrecidos por todos los contratistas
Future<List<Service>> getAllServices() async {
  final response = await _api.get(ApiConstants.contractors, includeAuth: true);

  final allServices = <Service>[];

  if (response is List) {
    for (var contractor in response) {
      if (contractor['services'] != null) {
        for (var s in contractor['services']) {
          allServices.add(Service.fromJson(s as Map<String, dynamic>));
        }
      }
    }
  }

  return allServices;
}


  /// ✅ Obtener un servicio específico por su ID
  Future<Service> getServiceById(String id) async {
    final response = await _api.get('${ApiConstants.services}/$id');
    return Service.fromJson(response as Map<String, dynamic>);
  }

  /// ✅ Crear un nuevo servicio (solo para proveedores)
  Future<Service> createService(ServiceInput input) async {
    final response = await _api.post(ApiConstants.services, input.toJson());
    return Service.fromJson(response as Map<String, dynamic>);
  }

  /// ✅ Eliminar un servicio
  Future<void> deleteService(String id) async {
    await _api.delete('${ApiConstants.services}/$id');
  }

  /// ✅ Obtener los servicios ofrecidos por un proveedor específico
  Future<List<Service>> getServicesByContractor(String contractorId) async {
    final response =
        await _api.get('${ApiConstants.services}?contractorId=$contractorId');

    // El backend puede devolver directamente una lista o un objeto con "services"
    final data = (response is Map<String, dynamic> && response.containsKey('services'))
        ? response['services']
        : response;

    if (data is List) {
      return data
          .map((json) => Service.fromJson(json as Map<String, dynamic>))
          .toList();
    }

    return [];
  }

  Future<void> updateMyServices(Map<String, dynamic> payload) async {
    await _api.patch(ApiConstants.updateServices, payload, includeAuth: true);
  }



}
