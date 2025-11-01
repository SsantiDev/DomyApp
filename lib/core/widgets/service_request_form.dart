import 'package:flutter/material.dart';
import 'package:domy/features/auth/domain/entities/user.dart';
import '../../../core/services/service_request_service.dart';
import '../../../core/services/mock_auth_service.dart';

class ServiceRequestForm extends StatefulWidget {
  final User operaria;

  const ServiceRequestForm({
    Key? key,
    required this.operaria,
  }) : super(key: key);

  @override
  State<ServiceRequestForm> createState() => _ServiceRequestFormState();
}

class _ServiceRequestFormState extends State<ServiceRequestForm> {
  final _formKey = GlobalKey<FormState>();
  final _serviceTypeCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();

  DateTime? _selectedDate;
  bool _isLoading = false;

  @override
  void dispose() {
    _serviceTypeCtrl.dispose();
    _descriptionCtrl.dispose();
    _addressCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDate == null) {
      _showErrorSnackBar('Por favor selecciona una fecha');
      return;
    }

    final client = MockAuthService.instance.currentUser;
    if (client == null) {
      _showErrorSnackBar('Debes iniciar sesión');
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Asegurarse de usar el ID correcto de la operaria
      // (puede ser mock_op_X o un ID real)
      final operariaId = widget.operaria.id;
      
      print('=== CREANDO SOLICITUD ===');
      print('Cliente ID: ${client.id}');
      print('Operaria ID: $operariaId');
      print('Operaria Nombre: ${widget.operaria.name}');
      
      final request = await ServiceRequestService.instance.createRequest(
        clientId: client.id,
        operariaId: operariaId,
        serviceType: _serviceTypeCtrl.text.trim(),
        description: _descriptionCtrl.text.trim(),
        address: _addressCtrl.text.trim(),
        requestedDate: _selectedDate!,
        estimatedPrice: double.parse(_priceCtrl.text.trim()),
      );
      
      print('Solicitud creada exitosamente con ID: ${request.id}');

      if (!mounted) return;
      _showSuccessSnackBar(
        'Solicitud enviada a ${widget.operaria.name}',
      );

      await Future.delayed(const Duration(milliseconds: 700));
      if (!mounted) return;

      Navigator.pop(context, request);
    } catch (e) {
      if (!mounted) return;
      _showErrorSnackBar(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Solicitar a ${widget.operaria.name}'),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Detalles del servicio',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _serviceTypeCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Tipo de servicio',
                    prefixIcon: Icon(Icons.cleaning_services),
                    hintText: 'Ej: Limpieza profunda',
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Ingresa el tipo de servicio'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Descripción del trabajo',
                    prefixIcon: Icon(Icons.description),
                    hintText: 'Detalla qué necesitas que se limpie',
                  ),
                  maxLines: 3,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Ingresa una descripción'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _addressCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Dirección',
                    prefixIcon: Icon(Icons.location_on),
                    hintText: 'Dirección completa del servicio',
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Ingresa la dirección'
                      : null,
                ),
                const SizedBox(height: 20),
                Text(
                  'Fecha y precio',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: _selectDate,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF334155),
                        width: 1.5,
                      ),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          color: Color(0xFF94A3B8),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Fecha del servicio',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF94A3B8),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _selectedDate == null
                                  ? 'Selecciona una fecha'
                                  : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _priceCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Precio estimado',
                    prefixIcon: Icon(Icons.attach_money),
                    hintText: '0.00',
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty)
                      return 'Ingresa un precio';
                    if (double.tryParse(v) == null)
                      return 'Ingresa un número válido';
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _onSubmit,
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor:
                                  AlwaysStoppedAnimation(Colors.white),
                            ),
                          )
                        : const Text('Enviar solicitud'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}