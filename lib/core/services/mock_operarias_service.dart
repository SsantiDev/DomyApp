import '../../features/auth/domain/entities/user.dart';

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

  final List<OperariaInfo> _operarias = [
    OperariaInfo(
      user: User(
        id: '1',
        name: 'María González',
        email: 'maria@domy.com',
        role: 'operaria',
        phone: '3001234567',
        address: 'Medellín, Laureles',
      ),
      rating: 4.9,
      completedServices: 124,
      specialties: ['Limpieza profunda', 'Desinfección', 'Organización'],
      description: 'Operaria experimentada con más de 5 años en el servicio',
    ),
    OperariaInfo(
      user: User(
        id: '2',
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
        id: '3',
        name: 'Carmen Rodríguez',
        email: 'carmen@domy.com',
        role: 'operaria',
        phone: '3009876543',
        address: 'Medellín, Sabaneta',
      ),
      rating: 4.7,
      completedServices: 156,
      specialties: ['Limpieza post-construcción', 'Desengrase', 'Ventanas'],
      description: 'Experta en limpiezas difíciles y trabajos especializados',
    ),
    OperariaInfo(
      user: User(
        id: '4',
        name: 'Ana Pérez',
        email: 'ana@domy.com',
        role: 'operaria',
        phone: '3005555555',
        address: 'Medellín, Itaguí',
      ),
      rating: 4.6,
      completedServices: 87,
      specialties: ['Limpieza de hogares', 'Cuidado de plantas', 'Organización'],
      description: 'Perfecta para limpiezas regulares y mantenimiento del hogar',
    ),
    OperariaInfo(
      user: User(
        id: '5',
        name: 'Sofía López',
        email: 'sofia@domy.com',
        role: 'operaria',
        phone: '3004444444',
        address: 'Medellín, Bello',
      ),
      rating: 4.9,
      completedServices: 145,
      specialties: ['Limpieza ecológica', 'Alérgenos', 'Mascotas'],
      description: 'Especialista en limpiezas sostenibles y alérgeno-friendly',
    ),
    OperariaInfo(
      user: User(
        id: '6',
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

  List<OperariaInfo> getAllOperarias() {
    return List.unmodifiable(_operarias);
  }

  List<OperariaInfo> searchOperarias(String query) {
    if (query.isEmpty) return getAllOperarias();
    return _operarias
        .where((op) =>
            op.user.name.toLowerCase().contains(query.toLowerCase()) ||
            op.specialties.any((s) => s.toLowerCase().contains(query.toLowerCase())))
        .toList();
  }

  List<OperariaInfo> getTopRated() {
    final sorted = List<OperariaInfo>.from(_operarias);
    sorted.sort((a, b) => b.rating.compareTo(a.rating));
    return sorted;
  }

  List<OperariaInfo> getMostExperienced() {
    final sorted = List<OperariaInfo>.from(_operarias);
    sorted.sort((a, b) => b.completedServices.compareTo(a.completedServices));
    return sorted;
  }
}