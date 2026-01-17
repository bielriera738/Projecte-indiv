import 'package:flutter/material.dart';

class MenuPanel extends StatelessWidget {
  final double width;
  final double maxWidth;
  final VoidCallback onMacrosTap;
  final VoidCallback onRecetasTap;
  final VoidCallback onPerfilTap;

  const MenuPanel({
    super.key,
    required this.width,
    this.maxWidth = 420,
    required this.onMacrosTap,
    required this.onRecetasTap,
    required this.onPerfilTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(26),
      width: width,
      constraints: BoxConstraints(maxWidth: maxWidth),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300, width: 1.4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            '¿Qué quieres hacer?',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w800,
              color: Colors.teal,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 28),
          MenuCard(
            icon: Icons.calculate_outlined,
            text: '¿Cuánto debo comer?',
            color: Colors.teal,
            onTap: onMacrosTap,
          ),
          const SizedBox(height: 20),
          MenuCard(
            icon: Icons.restaurant_menu,
            text: 'Ideas de recetas',
            color: Colors.orange,
            onTap: onRecetasTap,
          ),
          const SizedBox(height: 20),
          MenuCard(
            icon: Icons.person,
            text: 'Mis datos',
            color: Colors.blue,
            onTap: onPerfilTap,
          ),
        ],
      ),
    );
  }
}

class MenuCard extends StatefulWidget {
  final IconData icon;
  final String text;
  final Color color;
  final VoidCallback onTap;

  const MenuCard({
    super.key,
    required this.icon,
    required this.text,
    required this.color,
    required this.onTap,
  });

  @override
  State<MenuCard> createState() => _MenuCardState();
}

class _MenuCardState extends State<MenuCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      duration: const Duration(milliseconds: 130),
      scale: _pressed ? 0.96 : 1.0,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapCancel: () => setState(() => _pressed = false),
        onTapUp: (_) {
          setState(() => _pressed = false);
          widget.onTap();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: Colors.grey.shade50,
            border: Border.all(color: widget.color, width: 1.3),
            boxShadow: [
              BoxShadow(
                color: widget.color.withOpacity(0.15),
                blurRadius: 8,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(widget.icon, color: widget.color, size: 32),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  widget.text,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.black38,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
