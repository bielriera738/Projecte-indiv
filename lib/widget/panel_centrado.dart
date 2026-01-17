import 'package:flutter/material.dart';

/// Panel centrado con ancho máximo y borde neón (estilo login/menú).
class CenteredPanel extends StatelessWidget {
  final double maxWidth;
  final EdgeInsetsGeometry padding;
  final Widget child;

  const CenteredPanel({
    super.key,
    this.maxWidth = 420,
    this.padding = const EdgeInsets.all(22),
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: Colors.white.withOpacity(0.06),
            border: Border.all(
              color: Colors.tealAccent.withOpacity(0.7),
              width: 1.4,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.35),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
