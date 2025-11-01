import 'package:flutter/material.dart';
import '../../../../core/services/mock_operarias_service.dart';
import '/core/widgets/operaria_card.dart';
import '/core/widgets/empty_state.dart';

class OperariasListPage extends StatefulWidget {
  const OperariasListPage({super.key});

  @override
  State<OperariasListPage> createState() => _OperariasListPageState();
}

class _OperariasListPageState extends State<OperariasListPage> {
  final _searchController = TextEditingController();
  late List<OperariaInfo> _operarias;
  List<OperariaInfo> _filteredOperarias = [];
  bool _isLoading = true;
  String _filterType = 'todas'; // 'todas', 'topRated', 'mostExperienced'

  @override
  void initState() {
    super.initState();
    _loadOperarias();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadOperarias() {
    Future.delayed(const Duration(milliseconds: 500), () {
      final all = MockOperariasService.instance.getAllOperarias();
      setState(() {
        _operarias = all;
        _filteredOperarias = all;
        _isLoading = false;
      });
    });
  }

  void _filterOperarias(String query) {
    final filtered = MockOperariasService.instance.searchOperarias(query);
    setState(() {
      _filteredOperarias = _applyTypeFilter(filtered);
    });
  }

  List<OperariaInfo> _applyTypeFilter(List<OperariaInfo> list) {
    switch (_filterType) {
      case 'topRated':
        return list..sort((a, b) => b.rating.compareTo(a.rating));
      case 'mostExperienced':
        return list
          ..sort((a, b) => b.completedServices.compareTo(a.completedServices));
      default:
        return list;
    }
  }

  void _solicitarServicio(OperariaInfo operaria) {
    _showSuccessSnackBar('Solicitud enviada a ${operaria.user.name}');
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
        title: const Text('Operarias disponibles'),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                _buildSearchAndFilters(),
                Expanded(
                  child: _filteredOperarias.isEmpty
                      ? EmptyState(
                          title: 'No se encontraron operarias',
                          subtitle:
                              'Intenta con otros criterios de búsqueda',
                          icon: Icons.person_search,
                          actionButton: () {
                            _searchController.clear();
                            _filterOperarias('');
                            setState(() => _filterType = 'todas');
                          },
                          actionLabel: 'Limpiar filtros',
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.only(bottom: 20),
                          itemCount: _filteredOperarias.length,
                          itemBuilder: (context, index) {
                            final op = _filteredOperarias[index];
                            return OperariaCard(
                              user: op.user,
                              rating: op.rating,
                              completedServices: op.completedServices,
                              specialties: op.specialties,
                              description: op.description,
                              onSolicitar: () =>
                                  _solicitarServicio(op),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }

  Widget _buildSearchAndFilters() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Barra de búsqueda
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: 'Buscar operaria o especialidad',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _filterOperarias('');
                      },
                    )
                  : null,
            ),
            onChanged: _filterOperarias,
          ),
          const SizedBox(height: 12),
          
          // Filtros
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip(
                  label: 'Todas',
                  value: 'todas',
                  isSelected: _filterType == 'todas',
                  onTap: () {
                    setState(() => _filterType = 'todas');
                    _filterOperarias(_searchController.text);
                  },
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  label: 'Mejor calificadas',
                  value: 'topRated',
                  isSelected: _filterType == 'topRated',
                  onTap: () {
                    setState(() => _filterType = 'topRated');
                    _filterOperarias(_searchController.text);
                  },
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  label: 'Más experiencia',
                  value: 'mostExperienced',
                  isSelected: _filterType == 'mostExperienced',
                  onTap: () {
                    setState(() => _filterType = 'mostExperienced');
                    _filterOperarias(_searchController.text);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required String value,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF3B82F6)
              : const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
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
            color: isSelected ? Colors.white : const Color(0xFFCBD5E1),
          ),
        ),
      ),
    );
  }
}