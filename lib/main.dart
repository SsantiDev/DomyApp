import 'package:flutter/material.dart';

void main() {
  runApp(const AseoApp());
}

class AseoApp extends StatelessWidget {
  const AseoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aseo App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar Sesión')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Bienvenido a Domy'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Aquí iría la navegación hacia el registro o el dashboard
              },
              child: const Text('Continuar'),
            ),
          ],
        ),
      ),
    );
  }
}
