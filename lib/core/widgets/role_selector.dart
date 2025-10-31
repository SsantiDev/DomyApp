import 'package:flutter/material.dart';

class RoleSelector extends StatelessWidget {
  final String selectedRole;
  final Function(String) onRoleChanged;

  const RoleSelector({
    Key? key,
    required this.selectedRole,
    required this.onRoleChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Registrarme como',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildRoleOption(
                label: 'Cliente',
                value: 'cliente',
                isSelected: selectedRole == 'cliente',
                icon: Icons.home,
                onTap: () => onRoleChanged('cliente'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildRoleOption(
                label: 'Operaria',
                value: 'operaria',
                isSelected: selectedRole == 'operaria',
                icon: Icons.person_4,
                onTap: () => onRoleChanged('operaria'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRoleOption({
    required String label,
    required String value,
    required bool isSelected,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF3B82F6) : const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF3B82F6) : const Color(0xFF334155),
            width: 2,
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        child: Column(
          children: [
            Icon(
              icon,
              size: 28,
              color: isSelected ? Colors.white : const Color(0xFF94A3B8),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : const Color(0xFFCBD5E1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}