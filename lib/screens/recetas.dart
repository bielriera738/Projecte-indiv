import 'package:flutter/material.dart';

/// 📌 Pantalla de recetas personalizadas y planes (chat nutricional)
class RecetasScreen extends StatefulWidget {
  const RecetasScreen({super.key});

  @override
  State<RecetasScreen> createState() => _RecetasScreenState();
}

class _RecetasScreenState extends State<RecetasScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _mensajes = [];

  void _enviarMensaje(String texto) {
    if (texto.isEmpty) return;

    setState(() {
      _mensajes.add({"role": "user", "text": texto});
      _controller.clear();
    });

    Future.delayed(const Duration(milliseconds: 600), () {
      String respuesta = _generarRespuesta(texto);
      setState(() {
        _mensajes.add({"role": "bot", "text": respuesta});
      });
    });
  }

  /// 📌 Generador de respuestas automáticas extendidas
  String _generarRespuesta(String texto) {
    texto = texto.toLowerCase();

    if (texto.contains("Quiero definición") || texto.contains("definición")) {
      return "✅ *Plan Definición (Bajar grasa y mantener músculo)*\n\n"
          "🍳 Desayuno: Tortilla de claras + avena 🥚\n"
          "🍎 Snack: Yogur natural con manzana 🍏\n"
          "🥗 Almuerzo: Pollo a la plancha con ensalada verde 🥗\n"
          "🥜 Merienda: Batido de proteína + frutos secos 🥤\n"
          "🐟 Cena: Salmón al horno con verduras al vapor 🐟\n"
          "🌙 Snack nocturno: Requesón bajo en grasa con canela 🧀";
    } else if (texto.contains("Quiero volumen") ||texto.contains("volumen")) {
      return "💪 *Plan Volumen (Ganar músculo y fuerza)*\n\n"
          "🥞 Desayuno: Avena con plátano + mantequilla de cacahuete 🍌🥜\n"
          "🥤 Snack: Batido de proteína + leche entera 🥛\n"
          "🍛 Almuerzo: Arroz con pollo y verduras 🍛\n"
          "🥪 Merienda: Bocadillo integral de atún con aguacate 🥑\n"
          "🍝 Cena: Pasta integral con atún y brócoli 🍝\n"
          "🍫 Post-entreno: Batido de cacao con proteína y avena 🍫";
    } else if (texto.contains("Quiero mantenimiento") ||texto.contains("mantenimiento")) {
      return "⚖️ *Plan Mantenimiento (Equilibrio y energía estable)*\n\n"
          "🥣 Desayuno: Yogur con granola y frutos rojos 🍓\n"
          "🥜 Snack: Tostada integral con crema de almendras 🥜\n"
          "🥩 Almuerzo: Filete de ternera con patata asada 🥩\n"
          "🥗 Merienda: Ensalada de garbanzos con tomate y pepino 🥗\n"
          "🐟 Cena: Ensalada de quinoa con salmón y aguacate 🥑\n"
          "🍵 Infusión nocturna: Té verde o manzanilla 🌿";
    } else {
      return "🤖 *Opciones disponibles:*\n\n"
          "- Recetas para **definición** 🥗\n"
          "- Recetas para **volumen** 💪\n"
          "- Recetas para **mantenimiento ** 👨‍🔧\n"
          "👉 Escríbeme tu objetivo y te daré un plan completo.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat Nutricional Inteligente "),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/fondochat.png"), // 👈 tu imagen
            fit: BoxFit.contain,
          ),
        ),
        child: Column(
          children: [
            /// 📌 Mensajes tipo chat
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: _mensajes.length,
                itemBuilder: (context, index) {
                  final msg = _mensajes[index];
                  final isUser = msg["role"] == "user";
                  return Align(
                    alignment:
                        isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isUser ? Colors.teal : Colors.green.shade700,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        msg["text"]!,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                },
              ),
            ),

            /// 📌 Caja de texto para escribir
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: "Escribe tu objetivo (ej: recetas para volumen)...",
                        filled: true,
                        fillColor: Color(0xFF7FFFD4), // mismo azul translúcido
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.tealAccent),
                    onPressed: () => _enviarMensaje(_controller.text),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}