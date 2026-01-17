import 'package:flutter/material.dart';

class LogoAnimado extends StatefulWidget {
  const LogoAnimado({super.key});

  @override
  State<LogoAnimado> createState() => _LogoAnimadoState();
}

class _LogoAnimadoState extends State<LogoAnimado>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.9, end: 1.1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: Image.asset(
        'assets/images/Logo.png', // o Logo.svg si usas svg
        height: 50,
      ),
    );
  }
}
