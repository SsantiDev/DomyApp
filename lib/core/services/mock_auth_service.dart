import 'dart:math';
import '../../features/auth/domain/entities/user.dart';

class MockAuthService {
  MockAuthService._private();
  static final MockAuthService instance = MockAuthService._private();

  final List<Map<String, String>> _credentials = []; // {email, password}
  final List<User> _users = [];

  /// Registra un usuario. Lanza Exception si email ya existe.
  Future<User> register({
    required String name,
    required String email,
    required String password,
    required String role,
    required String phone,
    String? address,
  }) async {
    await Future.delayed(const Duration(milliseconds: 700)); // simula red

    // check existing
    final exists = _credentials.any((c) => c['email'] == email);
    if (exists) throw Exception('El correo ya está registrado');

    // crear id simple
    final id = _randomId();

    _credentials.add({'email': email, 'password': password});
    final user = User(
      id: id,
      name: name,
      email: email,
      role: role,
      phone: phone,
      address: address,
    );
    _users.add(user);
    return user;
  }

  Future<User> login({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final cred = _credentials.firstWhere(
      (c) => c['email'] == email && c['password'] == password,
      orElse: () => {},
    );
    if (cred.isEmpty) throw Exception('Credenciales inválidas');

    final user = _users.firstWhere((u) => u.email == email);
    return user;
  }

  List<User> allUsers() => List.unmodifiable(_users);

  String _randomId() => DateTime.now().millisecondsSinceEpoch.toRadixString(16) +
      Random().nextInt(9999).toString();
}
