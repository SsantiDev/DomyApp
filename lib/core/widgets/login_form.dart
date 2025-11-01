import 'package:flutter/material.dart';
import '../../../../core/services/mock_auth_service.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onLoginPressed() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    // Validación básica
    if (email.isEmpty || password.isEmpty) {
      _showErrorSnackBar('Por favor completa todos los campos');
      return;
    }

    if (!_isEmailValid(email)) {
      _showErrorSnackBar('Por favor ingresa un email válido');
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Llamar al servicio de autenticación
      final user = await MockAuthService.instance.login(
        email: email,
        password: password,
      );

      if (!mounted) return;

      _showSuccessSnackBar('¡Inicio de sesión exitoso!');

      // Esperar a que se muestre el mensaje
      await Future.delayed(const Duration(milliseconds: 500));

      if (!mounted) return;

      // Navegar a home con el rol del usuario
      Navigator.pushReplacementNamed(
        context,
        '/home',
        arguments: user.role,
      );
    } catch (e) {
      if (!mounted) return;
      _showErrorSnackBar(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  bool _isEmailValid(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
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
    return Column(
      children: [
        // Campo de email
        TextField(
          controller: _emailController,
          enabled: !_isLoading,
          decoration: InputDecoration(
            labelText: 'Correo Electrónico',
            prefixIcon: const Icon(Icons.email_outlined),
            prefixIconColor: const Color(0xFF94A3B8),
          ),
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
        ),
        
        const SizedBox(height: 16),
        
        // Campo de contraseña
        TextField(
          controller: _passwordController,
          enabled: !_isLoading,
          decoration: InputDecoration(
            labelText: 'Contraseña',
            prefixIcon: const Icon(Icons.lock_outlined),
            prefixIconColor: const Color(0xFF94A3B8),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: () {
                setState(() => _obscurePassword = !_obscurePassword);
              },
              color: const Color(0xFF94A3B8),
            ),
          ),
          obscureText: _obscurePassword,
          textInputAction: TextInputAction.done,
        ),
        
        const SizedBox(height: 12),
        
        // Link "Olvidé mi contraseña"
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: _isLoading ? null : () {
              // Navegar a recuperar contraseña
            },
            child: const Text('¿Olvidaste tu contraseña?'),
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Botón de login
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _onLoginPressed,
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  )
                : const Text('Iniciar Sesión'),
          ),
        ),
      ],
    );
  }
}