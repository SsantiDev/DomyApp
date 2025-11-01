import 'dart:math';
import '../../features/auth/domain/entities/user.dart';
import '../../core/services/mock_auth_service.dart';

class OperariaInfo {
  final User user;
  final double rating;
  final int completedServices;
  final List<String> specialties;
  final String description;

  OperariaInfo({
    required this.user,
    required this.rating,
    required this.completedServices,
    required this.specialties,
    required this.description,
  });
}

class MockOperariasService {
  MockOperariasService._private();
  static final MockOperariasService instance = MockOperariasService._private();

  late final List<OperariaInfo> _operarias = [];
  bool _initialized = false;

  /// Inicializar operarias - Crea operarias mock si no existen
  void initialize() {
    if (_initialized) return;

    // Primero intenta obtener operarias reales del servicio de auth
    final allUsers = MockAuthService.instance.allUsers();
    final realOperarias =
        allUsers.where((u) => u.role == 'operaria').toList();

    // Si hay operarias reales, úsalas
    if (realOperarias.isNotEmpty) {
      _operarias.addAll(
        realOperarias.asMap().entries.map((entry) {
          final index = entry.key;
          final user = entry.value;

          final ratingsList = [4.9, 4.8, 4.7, 4.6];
          final servicesList = [124, 98, 156, 87];
          final specialtiesList = [
            ['Limpieza profunda', 'Desinfección', 'Organización'],
            ['Limpieza general', 'Baños', 'Cocinas'],
            ['Limpieza post-construcción', 'Desengrase', 'Ventanas'],
            ['Limpieza de hogares', 'Cuidado de plantas', 'Organización'],
          ];
          final descriptionsList = [
            'Operaria experimentada con más de 5 años en el servicio',
            'Especialista en limpiezas rápidas y eficientes',
            'Experta en limpiezas difíciles y trabajos especializados',
            'Perfecta para limpiezas regulares y mantenimiento del hogar',
          ];

          return OperariaInfo(
            user: user,
            rating: ratingsList[index % ratingsList.length],
            completedServices: servicesList[index % servicesList.length],
            specialties:
                specialtiesList[index % specialtiesList.length],
            description: descriptionsList[index % descriptionsList.length],
          );
        }).toList(),
      );
    } else {
      // Si NO hay operarias reales, crea operarias MOCK
      // (Esto es para MVP/testing sin necesidad de registrar operarias)
      _createMockOperarias();
    }

    _initialized = true;
  }

  /// Crea operarias mock para testing
  void _createMockOperarias() {
    final mockOperarias = [
      OperariaInfo(
        user: User(
          id: 'mock_op_1',
          name: 'María González',
          email: 'maria@domy.com',
          role: 'operaria',
          phone: '3001234567',
          address: 'Medellín, Laureles',
        ),
        rating: 4.9,
        completedServices: 124,
        specialties: ['Limpieza profunda', 'Desinfección', 'Organización'],
        description:
            'Operaria experimentada con más de 5 años en el servicio',
      ),
      OperariaInfo(
        user: User(
          id: 'mock_op_2',
          name: 'Jessica Martínez',
          email: 'jessica@domy.com',
          role: 'operaria',
          phone: '3007654321',
          address: 'Medellín, Envigado',
        ),
        rating: 4.8,
        completedServices: 98,
        specialties: ['Limpieza general', 'Baños', 'Cocinas'],
        description: 'Especialista en limpiezas rápidas y eficientes',
      ),
      OperariaInfo(
        user: User(
          id: 'mock_op_3',
          name: 'Carmen Rodríguez',
          email: 'carmen@domy.com',
          role: 'operaria',
          phone: '3009876543',
          address: 'Medellín, Sabaneta',
        ),
        rating: 4.7,
        completedServices: 156,
        specialties: ['Limpieza post-construcción', 'Desengrase', 'Ventanas'],
        description:
            'Experta en limpiezas difíciles y trabajos especializados',
      ),
      OperariaInfo(
        user: User(
          id: 'mock_op_4',
          name: 'Ana Pérez',
          email: 'ana@domy.com',
          role: 'operaria',
          phone: '3005555555',
          address: 'Medellín, Itaguí',
        ),
        rating: 4.6,
        completedServices: 87,
        specialties: ['Limpieza de hogares', 'Cuidado de plantas', 'Organización'],
        description:
            'Perfecta para limpiezas regulares y mantenimiento del hogar',
      ),
      OperariaInfo(
        user: User(
          id: 'mock_op_5',
          name: 'Sofía López',
          email: 'sofia@domy.com',
          role: 'operaria',
          phone: '3004444444',
          address: 'Medellín, Bello',
        ),
        rating: 4.9,
        completedServices: 145,
        specialties: ['Limpieza ecológica', 'Alérgenos', 'Mascotas'],
        description:
            'Especialista en limpiezas sostenibles y alérgeno-friendly',
      ),
      OperariaInfo(
        user: User(
          id: 'mock_op_6',
          name: 'Rosa Díaz',
          email: 'rosa@domy.com',
          role: 'operaria',
          phone: '3003333333',
          address: 'Medellín, Copacabana',
        ),
        rating: 4.8,
        completedServices: 112,
        specialties: ['Oficinas', 'Comercios', 'Cristales'],
        description: 'Experta en limpieza de espacios comerciales',
      ),
    ];

    _operarias.addAll(mockOperarias);
  }

  List<OperariaInfo> getAllOperarias() {
    if (!_initialized) initialize();
    return List.unmodifiable(_operarias);
  }

  List<OperariaInfo> searchOperarias(String query) {
    if (!_initialized) initialize();

    if (query.isEmpty) return getAllOperarias();
    return _operarias
        .where((op) =>
            op.user.name.toLowerCase().contains(query.toLowerCase()) ||
            op.specialties.any((s) =>
                s.toLowerCase().contains(query.toLowerCase())))
        .toList();
  }

  List<OperariaInfo> getTopRated() {
    if (!_initialized) initialize();

    final sorted = List<OperariaInfo>.from(_operarias);
    sorted.sort((a, b) => b.rating.compareTo(a.rating));
    return sorted;
  }

  List<OperariaInfo> getMostExperienced() {
    if (!_initialized) initialize();

    final sorted = List<OperariaInfo>.from(_operarias);
    sorted.sort((a, b) => b.completedServices.compareTo(a.completedServices));
    return sorted;
  }

  /// Obtener info de una operaria por su userId
  OperariaInfo? getOperariaByUserId(String userId) {
    if (!_initialized) initialize();

    try {
      return _operarias.firstWhere((op) => op.user.id == userId);
    } catch (e) {
      return null;
    }
  }
}