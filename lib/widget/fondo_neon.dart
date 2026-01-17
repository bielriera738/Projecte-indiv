import 'package:flutter/material.dart';

class NeonBackground extends StatelessWidget {
  final Widget child;

  const NeonBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.white, child: child);
  }
}

class _NeonCircle extends StatelessWidget {
  final double size;
  final Color color;

  const _NeonCircle(this.size, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [BoxShadow(color: color, blurRadius: 100, spreadRadius: 60)],
      ),
    );
  }
}
