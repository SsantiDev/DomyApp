import 'package:flutter/material.dart';
import 'package:domy/features/auth/domain/entities/user.dart';
import 'package:domy/core/services/service_request.dart';
import '../../../../core/services/mock_auth_service.dart';

class RequestDetailCard extends StatelessWidget {
  final ServiceRequest request;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;
  final VoidCallback? onComplete;

  const RequestDetailCard({
    Key? key,
    required this.request,
    this.onAccept,
    this.onReject,
    this.onComplete,
  }) : super(key: key);

  User? _getClientUser() {
    try {
      final allUsers = MockAuthService.instance.allUsers();
      return allUsers.firstWhere((u) => u.id == request.clientId);
    } catch (e) {
      return null;
    }
  }

  String _getStatusLabel(RequestStatus status) {
    switch (status) {
      case RequestStatus.pending:
        return 'Pendiente';
      case RequestStatus.accepted:
        return 'Aceptada';
      case RequestStatus.rejected:
        return 'Rechazada';
      case RequestStatus.completed:
        return 'Completada';
      case RequestStatus.cancelled:
        return 'Cancelada';
    }
  }

  Color _getStatusColor(RequestStatus status) {
    switch (status) {
      case RequestStatus.pending:
        return const Color(0xFFF59E0B);
      case RequestStatus.accepted:
        return const Color(0xFF10B981);
      case RequestStatus.rejected:
        return const Color(0xFFEF4444);
      case RequestStatus.completed:
        return const Color(0xFF3B82F6);
      case RequestStatus.cancelled:
        return const Color(0xFF6B7280);
    }
  }

  @override
  Widget build(BuildContext context) {
    final client = _getClientUser();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF334155),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Cliente y estado
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        client?.name ?? 'Cliente desconocido',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Solicitud #${request.id.substring(0, 8)}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: _getStatusColor(request.status).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Text(
                    _getStatusLabel(request.status),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _getStatusColor(request.status),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Detalles del servicio
            _buildDetailRow(
              icon: Icons.cleaning_services,
              label: 'Servicio',
              value: request.serviceType,
            ),
            _buildDetailRow(
              icon: Icons.description,
              label: 'Descripción',
              value: request.description,
              maxLines: 2,
            ),
            _buildDetailRow(
              icon: Icons.location_on,
              label: 'Ubicación',
              value: request.address,
            ),
            _buildDetailRow(
              icon: Icons.calendar_today,
              label: 'Fecha',
              value:
                  '${request.requestedDate.day}/${request.requestedDate.month}/${request.requestedDate.year}',
            ),
            _buildDetailRow(
              icon: Icons.attach_money,
              label: 'Precio estimado',
              value: '\$${request.estimatedPrice.toStringAsFixed(2)}',
              isPrice: true,
            ),
            const SizedBox(height: 16),

            // Acciones
            if (request.status == RequestStatus.pending)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onReject,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFEF4444)),
                      ),
                      child: const Text(
                        'Rechazar',
                        style: TextStyle(color: Color(0xFFEF4444)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onAccept,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF10B981),
                      ),
                      child: const Text('Aceptar'),
                    ),
                  ),
                ],
              )
            else if (request.status == RequestStatus.accepted)
              ElevatedButton(
                onPressed: onComplete,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3B82F6),
                ),
                child: const SizedBox(
                  width: double.infinity,
                  child: Text(
                    'Marcar como completado',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    int? maxLines,
    bool isPrice = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 18,
            color: const Color(0xFF94A3B8),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF94A3B8),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isPrice ? FontWeight.bold : FontWeight.w500,
                    color: isPrice
                        ? const Color(0xFF10B981)
                        : const Color(0xFFCBD5E1),
                  ),
                  maxLines: maxLines,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}