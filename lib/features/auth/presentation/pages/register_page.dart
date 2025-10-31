import 'package:flutter/material.dart';
import '../../../../core/services/mock_auth_service.dart';
import '/core/widgets/custom_form_field.dart';
import '/core/widgets/role_selector.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  String _role = 'cliente';
  bool _isLoading = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  bool _isEmailValid(String email) {
    final r = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return r.hasMatch(email);
  }

  Future<void> _onRegisterPressed() async {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameCtrl.text.trim();
    final email = _emailCtrl.text.trim();
    final phone = _phoneCtrl.text.trim();
    final address = _addressCtrl.text.trim();
    final password = _passwordCtrl.text;

    setState(() => _isLoading = true);

    try {
      final user = await MockAuthService.instance.register(
        name: name,
        email: email,
        password: password,
        role: _role,
        phone: phone,
        address: address.isEmpty ? null : address,
      );

      if (!mounted) return;
      _showSuccessSnackBar('Registro correcto. ¡Bienvenido ${user.name}!');

      await Future.delayed(const Duration(milliseconds: 700));
      if (!mounted) return;

      Navigator.pushReplacementNamed(context, '/home', arguments: user.role);
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
        title: const Text('Crear cuenta'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 32),
                _buildFormFields(),
                const SizedBox(height: 32),
                _buildSubmitButton(),
                const SizedBox(height: 16),
                _buildLoginLink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Crea tu cuenta',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Únete a Domy y comienza hoy',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: const Color(0xFFCBD5E1),
          ),
        ),
      ],
    );
  }

  Widget _buildFormFields() {
    return Column(
      children: [
        CustomFormField(
          label: 'Nombre completo',
          controller: _nameCtrl,
          prefixIcon: Icons.person,
          keyboardType: TextInputType.name,
          validator: (v) => (v == null || v.trim().isEmpty) 
              ? 'Ingresa tu nombre' 
              : null,
        ),
        const SizedBox(height: 16),
        CustomFormField(
          label: 'Correo electrónico',
          controller: _emailCtrl,
          prefixIcon: Icons.email,
          keyboardType: TextInputType.emailAddress,
          validator: (v) {
            if (v == null || v.trim().isEmpty) return 'Ingresa un correo';
            if (!_isEmailValid(v.trim())) return 'Correo inválido';
            return null;
          },
        ),
        const SizedBox(height: 16),
        CustomFormField(
          label: 'Teléfono',
          controller: _phoneCtrl,
          prefixIcon: Icons.phone,
          keyboardType: TextInputType.phone,
          validator: (v) => (v == null || v.trim().isEmpty) 
              ? 'Ingresa tu teléfono' 
              : null,
        ),
        const SizedBox(height: 16),
        CustomFormField(
          label: 'Dirección',
          controller: _addressCtrl,
          prefixIcon: Icons.location_on,
          keyboardType: TextInputType.streetAddress,
          optional: true,
        ),
        const SizedBox(height: 24),
        RoleSelector(
          selectedRole: _role,
          onRoleChanged: (newRole) {
            setState(() => _role = newRole);
          },
        ),
        const SizedBox(height: 24),
        CustomFormField(
          label: 'Contraseña',
          controller: _passwordCtrl,
          prefixIcon: Icons.lock,
          obscureText: true,
          validator: (v) {
            if (v == null || v.isEmpty) return 'Ingresa una contraseña';
            if (v.length < 6) return 'Mínimo 6 caracteres';
            return null;
          },
        ),
        const SizedBox(height: 16),
        CustomFormField(
          label: 'Confirmar contraseña',
          controller: _confirmCtrl,
          prefixIcon: Icons.lock,
          obscureText: true,
          validator: (v) {
            if (v == null || v.isEmpty) return 'Confirma la contraseña';
            if (v != _passwordCtrl.text) return 'Las contraseñas no coinciden';
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _onRegisterPressed,
        child: _isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              )
            : const Text('Crear cuenta'),
      ),
    );
  }

  Widget _buildLoginLink() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '¿Ya tienes cuenta? ',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          TextButton(
            onPressed: _isLoading ? null : () => Navigator.pop(context),
            child: const Text('Iniciar sesión'),
          ),
        ],
      ),
    );
  }
}