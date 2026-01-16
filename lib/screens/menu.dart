import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:nutrivision_ai/screens/macros.dart';
import 'package:nutrivision_ai/screens/recetas.dart' hide Text;
import 'package:nutrivision_ai/screens/perfil.dart';

  class MenuScreen extends StatefulWidget {
    const MenuScreen({super.key});

    @override
    State<MenuScreen> createState() => _MenuScreenState();
  }

  class _MenuScreenState extends State<MenuScreen> with SingleTickerProviderStateMixin {
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

      _fade = CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      );

      _slide = Tween<Offset>(
        begin: const Offset(0, 0.12),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
      );

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
        extendBodyBehindAppBar: true,
        backgroundColor: const Color(0xFF051D16),

        // 🔷 APPBAR ELEGANTE CON BLUR Y GLOW
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          flexibleSpace: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                color: Colors.black.withOpacity(0.2),
              ),
            ),
          ),
          centerTitle: false,
          title: const Text(
            "NutriVision AI",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.tealAccent,
              shadows: [
                Shadow(color: Colors.tealAccent, blurRadius: 12),
              ],
            ),
          )
        ),

        body: Stack(
          children: [

            // 🌈 GRADIENTE + EFECTO BOKEH SUAVE
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF083227), Color(0xFF051D16)],
                ),
              ),
            ),

            // 🔥 LUCES NEÓN DECORATIVAS
            Positioned(
              top: -80,
              right: -40,
              child: _neonCircle(180, Colors.tealAccent.withOpacity(0.28)),
            ),
            Positioned(
              bottom: -100,
              left: -30,
              child: _neonCircle(200, Colors.greenAccent.withOpacity(0.22)),
            ),

            Center(
              child: FadeTransition(
                opacity: _fade,
                child: SlideTransition(
                  position: _slide,
                  child: Container(
                    padding: const EdgeInsets.all(26),
                    width: size.width * 0.87,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      color: Colors.white.withOpacity(0.06),
                      border: Border.all(
                        color: Colors.tealAccent.withOpacity(0.7),
                        width: 1.4,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          blurRadius: 18,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),

                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Menú Principal",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w800,
                            color: Colors.tealAccent,
                            letterSpacing: 0.8,
                            shadows: [Shadow(color: Colors.tealAccent, blurRadius: 12)],
                          ),
                        ),

                        const SizedBox(height: 28),

                        MenuCard(
                          icon: Icons.calculate_outlined,
                          text: "Calcular Macros",
                          color: Colors.tealAccent,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const MacrosScreen()),
                          ),
                        ),

                        const SizedBox(height: 20),

                        MenuCard(
                          icon: Icons.restaurant_menu,
                          text: "Generador de Recetas",
                          color: Colors.orangeAccent,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => RecetasScreen()),
                          ),
                        ),

                        const SizedBox(height: 20),

                        MenuCard(
                          icon: Icons.person,
                          text: "Mi Perfil",
                          color: Colors.blueAccent,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) =>  MiPerfil()),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      );
    }

    Widget _neonCircle(double size, Color color) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          boxShadow: [
            BoxShadow(color: color, blurRadius: 100, spreadRadius: 60),
          ],
        ),
      );
    }
  }

  //------------------------------------------------------
  // ⭐ TARJETAS PREMIUM DEL MENÚ — 3D + ANIMACIÓN
  //------------------------------------------------------
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
              color: Colors.white.withOpacity(0.07),
              border: Border.all(color: widget.color, width: 1.3),
              boxShadow: [
                BoxShadow(
                  color: widget.color.withOpacity(0.3),
                  blurRadius: 16,
                  spreadRadius: 1,
                )
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
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
              ],
            ),
          ),
        ),
      );
    }
  }