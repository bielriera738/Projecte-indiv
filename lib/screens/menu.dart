import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // 👈 necesario para SVG
import 'package:nutrivision_ai/screens/macros.dart';
import 'package:nutrivision_ai/screens/recetas.dart';
import 'package:nutrivision_ai/screens/perfil.dart'; // 👈 pantalla de perfil

/// 📌 Pantalla del Menú Principal
class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NutriVision AI',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.lightGreen,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            color: Colors.tealAccent,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          titleSpacing: 12,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 🌟 Logo SVG animado (ajustado)
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.95, end: 1.05),
                duration: const Duration(seconds: 2),
                curve: Curves.easeInOut,
                builder: (context, scale, child) {
                  return Transform.scale(
                    scale: scale,
                    child: child,
                  );
                },
                child: SvgPicture.asset(
                  'assets/images/Logo.svg',
                  height: 65,
                ),
              ),
              const SizedBox(width: 2),
              const Text(
                "NutriVision AI",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 23,
                ),
              ),
            ],
          ),
          actions: [
            PopupMenuButton<String>(
              color: const Color(0xFF0B2E26),
              icon: const Icon(Icons.more_vert, color: Colors.white),
              onSelected: (value) {
                if (value == 'recetas') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RecetasScreen()),
                  );
                } else if (value == 'macros') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MacrosScreen()),
                  );
                } else if (value == 'perfil') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MiPerfil()),
                  );
                }
              },
              itemBuilder: (BuildContext context) {
                return [
                  const PopupMenuItem(
                    value: 'recetas',
                    child: Text(
                      "Generador de recetas y planes de nutrición",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'macros',
                    child: Text(
                      "Calcular Macros (API)",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'perfil',
                    child: Text(
                      "Perfil del Usuario",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ];
              },
            ),
          ],
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            color: Color(0xFF0B2E26),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Bienvenido a NutriVision AI 🍏",
                    style: TextStyle(
                      color: Colors.tealAccent,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Tu asistente inteligente para una nutrición saludable y personalizada.",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Column(
                    children: [
                      InkWell(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MacrosScreen()),
                        ),
                        child: const Text(
                          "🧠 Analiza tus necesidades calóricas y macronutrientes",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            height: 1.6,
                            decoration: TextDecoration.underline,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      InkWell(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RecetasScreen()),
                        ),
                        child: const Text(
                          "🍽️ Genera recetas y planes de nutrición adaptados a ti",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            height: 1.6,
                            decoration: TextDecoration.underline,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      InkWell(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MiPerfil()),
                        ),
                        child: const Text(
                          "👤 Gestiona tu perfil para mejorar tus hábitos alimenticios",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            height: 1.6,
                            decoration: TextDecoration.underline,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}