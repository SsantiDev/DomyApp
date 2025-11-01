import 'dart:math';
import '../../features/auth/domain/entities/user.dart';
import 'package:domy/core/services/service_request.dart';
class ServiceRequestService {
  ServiceRequestService._private();
  static final ServiceRequestService instance = ServiceRequestService._private();

  final List<ServiceRequest> _requests = [];

  /// Crear una nueva solicitud de servicio
  Future<ServiceRequest> createRequest({
    required String clientId,
    required String operariaId,
    required String serviceType,
    required String description,
    required String address,
    required DateTime requestedDate,
    required double estimatedPrice,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final id = _generateId();
    final now = DateTime.now();

    final request = ServiceRequest(
      id: id,
      clientId: clientId,
      operariaId: operariaId,
      serviceType: serviceType,
      description: description,
      address: address,
      requestedDate: requestedDate,
      estimatedPrice: estimatedPrice,
      status: RequestStatus.pending,
      createdAt: now,
    );

    _requests.add(request);
    return request;
  }

  /// Obtener todas las solicitudes de un cliente
  List<ServiceRequest> getClientRequests(String clientId) {
    return _requests.where((r) => r.clientId == clientId).toList();
  }

  /// Obtener todas las solicitudes recibidas por una operaria
  List<ServiceRequest> getOperariaRequests(String operariaId) {
    return _requests.where((r) => r.operariaId == operariaId).toList();
  }

  /// Aceptar una solicitud
  Future<ServiceRequest> acceptRequest(String requestId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final idx = _requests.indexWhere((r) => r.id == requestId);
    if (idx == -1) throw Exception('Solicitud no encontrada');

    final updated = _requests[idx].copyWith(status: RequestStatus.accepted);
    _requests[idx] = updated;
    return updated;
  }

  /// Rechazar una solicitud
  Future<ServiceRequest> rejectRequest(String requestId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final idx = _requests.indexWhere((r) => r.id == requestId);
    if (idx == -1) throw Exception('Solicitud no encontrada');

    final updated = _requests[idx].copyWith(status: RequestStatus.rejected);
    _requests[idx] = updated;
    return updated;
  }

  /// Completar una solicitud
  Future<ServiceRequest> completeRequest(
    String requestId, {
    double? rating,
    String? review,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final idx = _requests.indexWhere((r) => r.id == requestId);
    if (idx == -1) throw Exception('Solicitud no encontrada');

    final updated = _requests[idx].copyWith(
      status: RequestStatus.completed,
      completedAt: DateTime.now(),
      rating: rating,
      review: review,
    );
    _requests[idx] = updated;
    return updated;
  }

  /// Cancelar una solicitud (solo cliente)
  Future<ServiceRequest> cancelRequest(String requestId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final idx = _requests.indexWhere((r) => r.id == requestId);
    if (idx == -1) throw Exception('Solicitud no encontrada');

    final updated = _requests[idx].copyWith(status: RequestStatus.cancelled);
    _requests[idx] = updated;
    return updated;
  }

  /// Obtener todas las solicitudes
  List<ServiceRequest> getAllRequests() => List.unmodifiable(_requests);

  String _generateId() =>
      DateTime.now().millisecondsSinceEpoch.toRadixString(16) +
      Random().nextInt(9999).toString();
}