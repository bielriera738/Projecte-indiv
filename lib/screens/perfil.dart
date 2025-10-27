import 'package:flutter/material.dart';

class MiPerfil extends StatelessWidget {
  const MiPerfil({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  backgroundColor: const Color(0xFF0B2E26),
  elevation: 0,
  centerTitle: true,
  leading: IconButton(
    icon: const Icon(Icons.arrow_back, color: Colors.white),
    onPressed: () {
      Navigator.pop(context); // 🔙 vuelve al menú
    },
  ),
  title: const Text(
    "Mi Perfil",
    style: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
  ),
),
      body: Container(
        // 🌿 Fondo degradado verde para difuminar con la imagen
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0B3D2E), // Verde muy oscuro arriba
              Color(0xFF124F3B), // Verde más suave abajo
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: Stack(
          children: [


            // Contenido principal con scroll
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
              child: Column(
                children: [

                  // Campos de texto
                  TextField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white70,
                      labelText: 'Nombre',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  TextField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white70,
                      labelText: 'Peso (kg)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),

                  TextField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white70,
                      labelText: 'Altura (cm)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 30),

                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent[700],
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Guardar perfil",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
