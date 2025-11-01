import 'package:flutter/material.dart';
import '../../../../core/services/mock_auth_service.dart';
import '../../../../core/services/service_request_service.dart';
import 'package:domy/core/services/service_request.dart';
import '/core/widgets/empty_state.dart';
import 'package:domy/core/widgets/request_detail_card.dart';

class OperariaRequestsPage extends StatefulWidget {
  const OperariaRequestsPage({super.key});

  @override
  State<OperariaRequestsPage> createState() => _OperariaRequestsPageState();
}

class _OperariaRequestsPageState extends State<OperariaRequestsPage> {
  String _filterStatus = 'pending'; // 'pending', 'accepted', 'completed', 'all'
  bool _isLoading = true;
  List<ServiceRequest> _requests = [];

  @override
  void initState() {
    super.initState();
    _loadRequests();
  }

  void _loadRequests() {
    Future.delayed(const Duration(milliseconds: 500), () {
      final operaria = MockAuthService.instance.currentUser;
      if (operaria == null) {
        setState(() => _isLoading = false);
        return;
      }

      // Obtener todas las solicitudes dirigidas a esta operaria
      final allRequests =
          ServiceRequestService.instance.getOperariaRequests(operaria.id);
      
      // Debugging: imprime para ver qué se obtiene
      print('Operaria ID: ${operaria.id}');
      print('Solicitudes encontradas: ${allRequests.length}');
      for (var req in allRequests) {
        print('  - Solicitud para operaria: ${req.operariaId}');
      }
      
      setState(() {
        _requests = allRequests;
        _isLoading = false;
      });
    });
  }

  List<ServiceRequest> _getFilteredRequests() {
    if (_filterStatus == 'all') return _requests;

    return _requests.where((r) {
      switch (_filterStatus) {
        case 'pending':
          return r.status == RequestStatus.pending;
        case 'accepted':
          return r.status == RequestStatus.accepted;
        case 'completed':
          return r.status == RequestStatus.completed;
        default:
          return true;
      }
    }).toList();
  }

  Future<void> _acceptRequest(ServiceRequest request) async {
    try {
      await ServiceRequestService.instance.acceptRequest(request.id);
      _loadRequests();
      _showSuccessSnackBar('Solicitud aceptada');
    } catch (e) {
      _showErrorSnackBar(e.toString());
    }
  }

  Future<void> _rejectRequest(ServiceRequest request) async {
    try {
      await ServiceRequestService.instance.rejectRequest(request.id);
      _loadRequests();
      _showErrorSnackBar('Solicitud rechazada');
    } catch (e) {
      _showErrorSnackBar(e.toString());
    }
  }

  Future<void> _completeRequest(ServiceRequest request) async {
    try {
      await ServiceRequestService.instance.completeRequest(request.id);
      _loadRequests();
      _showSuccessSnackBar('Servicio marcado como completado');
    } catch (e) {
      _showErrorSnackBar(e.toString());
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: const Color(0xFFEF4444),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Solicitudes de servicio'),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildFilterChips(),
                Expanded(
                  child: _buildRequestsList(),
                ),
              ],
            ),
    );
  }

  Widget _buildFilterChips() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterChip('Pendientes', 'pending'),
            const SizedBox(width: 8),
            _buildFilterChip('Aceptadas', 'accepted'),
            const SizedBox(width: 8),
            _buildFilterChip('Completadas', 'completed'),
            const SizedBox(width: 8),
            _buildFilterChip('Todas', 'all'),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    return GestureDetector(
      onTap: () => setState(() => _filterStatus = value),
      child: Container(
        decoration: BoxDecoration(
          color: _filterStatus == value
              ? const Color(0xFF3B82F6)
              : const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _filterStatus == value
                ? const Color(0xFF3B82F6)
                : const Color(0xFF334155),
            width: 1.5,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: _filterStatus == value
                ? Colors.white
                : const Color(0xFFCBD5E1),
          ),
        ),
      ),
    );
  }

  Widget _buildRequestsList() {
    final filtered = _getFilteredRequests();

    if (filtered.isEmpty) {
      return EmptyState(
        title: 'No hay solicitudes',
        subtitle: 'Aquí aparecerán las solicitudes de los clientes',
        icon: Icons.assignment_outlined,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 20),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final request = filtered[index];
        return RequestDetailCard(
          request: request,
          onAccept: () => _acceptRequest(request),
          onReject: () => _rejectRequest(request),
          onComplete: () => _completeRequest(request),
        );
      },
    );
  }
}