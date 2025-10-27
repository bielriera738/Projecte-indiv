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
          centerTitle: false, // ⬅️ Desactivado para que el logo y texto se alineen bien
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
      tween: Tween(begin: 0.95, end: 1.05), // 🔹 animación más suave
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
    const SizedBox(width:2),
    const Text(
      "NutriVision AI",
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 23, // 
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
            image: DecorationImage(
              image: AssetImage("assets/images/imagenfondo.png"),
              alignment: Alignment.center,
              fit: BoxFit.contain, // 🔹 puedes cambiar a cover si prefieres
            ),
          ),
          child: const Center(),
        ),
      ),
    );
  }
}
