import 'package:flutter/material.dart';
import 'package:nutrivision_ai/screens/macros.dart';
import 'package:nutrivision_ai/screens/recetas.dart';
import 'package:nutrivision_ai/screens/perfil.dart';
import 'package:nutrivision_ai/widget/panel_menu.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 850),
      vsync: this,
    );

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    _slide = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: false,
        title: const Text(
          "NutriVision AI",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.teal,
          ),
        ),
      ),
      body: Center(
        child: FadeTransition(
          opacity: _fade,
          child: SlideTransition(
            position: _slide,
            child: MenuPanel(
              width: size.width * 0.87,
              onMacrosTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MacrosScreen()),
              ),
              onRecetasTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => RecetasScreen()),
              ),
              onPerfilTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => MiPerfil()),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
