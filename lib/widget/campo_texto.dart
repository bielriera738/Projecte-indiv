import 'package:flutter/material.dart';

/// Campo de texto reutilizable con estilo oscuro/neón para formularios.
class StyledTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? hint;
  final IconData? icon;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final bool enabled;
  final void Function(String)? onSubmitted;
  final String? Function(String?)? validator;

  const StyledTextField({
    super.key,
    required this.label,
    required this.controller,
    this.hint,
    this.icon,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.enabled = true,
    this.onSubmitted,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        enabled: enabled,
        onFieldSubmitted: onSubmitted,
        validator: validator,
        style: const TextStyle(color: Colors.white, fontSize: 16),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          labelStyle: const TextStyle(color: Colors.tealAccent),
          hintStyle: const TextStyle(color: Colors.white38),
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
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.redAccent, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 14,
          ),
        ),
      ),
    );
  }
}
