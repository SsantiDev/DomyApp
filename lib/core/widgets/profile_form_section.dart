import 'package:flutter/material.dart';
import '/core/widgets/custom_form_field.dart';

class ProfileFormSection extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController addressController;
  final bool isLoading;
  final VoidCallback onSave;

  const ProfileFormSection({
    Key? key,
    required this.nameController,
    required this.phoneController,
    required this.addressController,
    required this.isLoading,
    required this.onSave,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Información personal',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          CustomFormField(
            label: 'Nombre completo',
            controller: nameController,
            prefixIcon: Icons.person,
            validator: (v) => (v == null || v.trim().isEmpty)
                ? 'Ingresa tu nombre'
                : null,
          ),
          const SizedBox(height: 16),
          CustomFormField(
            label: 'Teléfono',
            controller: phoneController,
            prefixIcon: Icons.phone,
            keyboardType: TextInputType.phone,
            validator: (v) => (v == null || v.trim().isEmpty)
                ? 'Ingresa tu teléfono'
                : null,
          ),
          const SizedBox(height: 16),
          CustomFormField(
            label: 'Dirección / Ciudad',
            controller: addressController,
            prefixIcon: Icons.location_on,
            keyboardType: TextInputType.streetAddress,
            optional: true,
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isLoading ? null : onSave,
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    )
                  : const Text('Guardar cambios'),
            ),
          ),
        ],
      ),
    );
  }
}