import 'package:flutter/material.dart';
import '/core/widgets/quick_action_card.dart';
import '/core/widgets/stat_card.dart';

class HomePage extends StatelessWidget {
  final String userRole; // Puede ser 'cliente' o 'operaria'

  const HomePage({super.key, required this.userRole});

  bool get _isCliente => userRole == 'cliente';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeSection(),
              const SizedBox(height: 32),
              if (_isCliente)
                _buildClienteContent(context)
              else
                _buildOperariaContent(context),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      title: Text(
        _isCliente ? 'Panel del Cliente' : 'Panel de la Operaria',
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: false,
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () {
            // Navegar a notificaciones
          },
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.person_outlined),
                onPressed: () {
                  Navigator.pushNamed(context, '/profile');
                },
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'logout') {
                    _showLogoutDialog(context);
                  }
                },
                itemBuilder: (BuildContext context) => [
                  const PopupMenuItem<String>(
                    value: 'logout',
                    child: Row(
                      children: [
                        Icon(Icons.logout, size: 20),
                        SizedBox(width: 8),
                        Text('Cerrar sesión'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cerrar sesión'),
          content: const Text('¿Estás seguro de que deseas cerrar sesión?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // Navegar a login reemplazando todas las rutas anteriores
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/',
                  (route) => false,
                );
              },
              child: const Text(
                'Cerrar sesión',
                style: TextStyle(color: Color(0xFFEF4444)),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildWelcomeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _isCliente ? '¡Hola, Cliente!' : '¡Hola, Operario!',
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _isCliente
              ? 'Encuentra los mejores servicios de aseo'
              : 'Gestiona tus servicios y solicitudes',
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFFCBD5E1),
          ),
        ),
      ],
    );
  }

  Widget _buildClienteContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Acciones rápidas',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        QuickActionCard(
          icon: Icons.person_search,
          title: 'Ver operarios disponibles',
          description: 'Explora y contrata operarias para tu hogar',
          onTap: () {
            Navigator.pushNamed(context, '/operarias');
          },
          color: const Color(0xFF3B82F6),
        ),
        const SizedBox(height: 16),
        QuickActionCard(
          icon: Icons.history,
          title: 'Mis servicios',
          description: 'Revisa el historial de tus servicios',
          onTap: () {
            // Navegar a mis servicios
          },
          color: const Color(0xFF10B981),
        ),
        const SizedBox(height: 32),
        _buildStatsSection(context),
      ],
    );
  }

  Widget _buildOperariaContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gestión de servicios',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        QuickActionCard(
          icon: Icons.assignment,
          title: 'Ver solicitudes',
          description: 'Consulta las nuevas solicitudes de servicios',
          onTap: () {
            Navigator.pushNamed(context, '/solicitudes');
          },
          color: const Color(0xFF3B82F6),
        ),
        const SizedBox(height: 16),
        QuickActionCard(
          icon: Icons.task_alt,
          title: 'Mis servicios activos',
          description: 'Monitorea tus servicios en progreso',
          onTap: () {
            // Navegar a servicios activos
          },
          color: const Color(0xFF10B981),
        ),
        const SizedBox(height: 16),
        QuickActionCard(
          icon: Icons.star,
          title: 'Mis calificaciones',
          description: 'Revisa tu desempeño y reseñas',
          onTap: () {
            // Navegar a calificaciones
          },
          color: const Color(0xFFF59E0B),
        ),
        const SizedBox(height: 32),
        _buildStatsSection(context),
      ],
    );
  }

  Widget _buildStatsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _isCliente ? 'Resumen de actividad' : 'Estadísticas',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            if (_isCliente)
              Expanded(
                child: StatCard(
                  title: 'Servicios contratados',
                  value: '12',
                  icon: Icons.check_circle,
                  color: const Color(0xFF10B981),
                ),
              )
            else
              Expanded(
                child: StatCard(
                  title: 'Servicios completados',
                  value: '24',
                  icon: Icons.check_circle,
                  color: const Color(0xFF10B981),
                ),
              ),
            const SizedBox(width: 12),
            Expanded(
              child: StatCard(
                title: 'Calificación',
                value: _isCliente ? '4.8' : '4.9',
                icon: Icons.star,
                color: const Color(0xFFF59E0B),
              ),
            ),
          ],
        ),
      ],
    );
  }
}