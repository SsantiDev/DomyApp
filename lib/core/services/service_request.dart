import 'package:domy/features/auth/domain/entities/user.dart';

enum RequestStatus {
  pending,   // Pendiente (operaria no ha respondido)
  accepted,  // Aceptada por la operaria
  rejected,  // Rechazada por la operaria
  completed, // Completada
  cancelled, // Cancelada por el cliente
}

class ServiceRequest {
  final String id;
  final String clientId;        // Usuario que solicita
  final String operariaId;      // Operaria asignada
  final String serviceType;     // Tipo de servicio (ej: "Limpieza general")
  final String description;     // Descripción del trabajo
  final String address;         // Dirección donde se realizará
  final DateTime requestedDate; // Fecha solicitada
  final double estimatedPrice;  // Precio estimado
  final RequestStatus status;
  final DateTime createdAt;
  final DateTime? completedAt;
  final double? rating;         // Calificación de la operaria (1-5)
  final String? review;         // Comentario del cliente

  ServiceRequest({
    required this.id,
    required this.clientId,
    required this.operariaId,
    required this.serviceType,
    required this.description,
    required this.address,
    required this.requestedDate,
    required this.estimatedPrice,
    this.status = RequestStatus.pending,
    required this.createdAt,
    this.completedAt,
    this.rating,
    this.review,
  });

  // Copiar con cambios
  ServiceRequest copyWith({
    String? id,
    String? clientId,
    String? operariaId,
    String? serviceType,
    String? description,
    String? address,
    DateTime? requestedDate,
    double? estimatedPrice,
    RequestStatus? status,
    DateTime? createdAt,
    DateTime? completedAt,
    double? rating,
    String? review,
  }) {
    return ServiceRequest(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      operariaId: operariaId ?? this.operariaId,
      serviceType: serviceType ?? this.serviceType,
      description: description ?? this.description,
      address: address ?? this.address,
      requestedDate: requestedDate ?? this.requestedDate,
      estimatedPrice: estimatedPrice ?? this.estimatedPrice,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      rating: rating ?? this.rating,
      review: review ?? this.review,
    );
  }
}