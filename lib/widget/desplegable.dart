import 'package:flutter/material.dart';

/// Dropdown reutilizable con estilo oscuro/neón para formularios.
class StyledDropdown extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> items;
  final void Function(String?)? onChanged;
  final IconData? icon;
  final bool enabled;
  final String? Function(String?)? validator;

  const StyledDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    this.onChanged,
    this.icon,
    this.enabled = true,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        initialValue: value == null || value!.isEmpty ? null : value,
        dropdownColor: const Color(0xFF072119),
        style: const TextStyle(color: Colors.white, fontSize: 16),
        disabledHint: Text(
          value == null || value!.isEmpty ? label : value!,
          style: const TextStyle(color: Colors.white70),
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.tealAccent),
          prefixIcon: icon != null
              ? Icon(icon, color: Colors.tealAccent)
              : null,
          filled: true,
          fillColor: enabled
              ? const Color(0xFF04221E)
              : const Color(0xFF051D16),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.tealAccent, width: 1.5),
            borderRadius: BorderRadius.circular(12),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white24, width: 1),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: enabled ? onChanged : null,
        validator: validator,
      ),
    );
  }
}
