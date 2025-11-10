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

  @override
  void initState() {
    super.initState();
    // Mostrar mensaje inicial al abrir el chat
    Future.delayed(Duration.zero, () {
      _enviarMensaje("inicio");
    });
  }

  void _enviarMensaje(String texto) {
    if (texto.isEmpty) return;

    setState(() {
      if (texto != "inicio") {
        _mensajes.add({"role": "user", "text": texto});
      }
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
    // Convertir a minúsculas y eliminar acentos para mejor detección
    texto = texto.toLowerCase()
        .replaceAll(RegExp(r'á'), 'a')
        .replaceAll(RegExp(r'é'), 'e')
        .replaceAll(RegExp(r'í'), 'i')
        .replaceAll(RegExp(r'ó'), 'o')
        .replaceAll(RegExp(r'ú'), 'u');

    // Patrones de búsqueda más flexibles
    final patronesDesayuno = RegExp(r'desayun|breakfast|morning|mañana');
    final patronesDefinicion = RegExp(r'defin|adelgaz|perder\s*peso|diet|cut|lean|bajar');
    final patronesVolumen = RegExp(r'volum|masa|musc|bulk|ganar\s*peso|subir');
    final patronesMantenimiento = RegExp(r'manten|mantener|equilibr|balanc');

    if (patronesDesayuno.hasMatch(texto)) {
      return "🌅 *Ideas para Desayunos Saludables:*\n\n"
          "1. 🥑 Tostadas de aguacate:\n"
          "   - Pan integral\n"
          "   - Aguacate machacado\n"
          "   - Huevo pochado\n"
          "   - Semillas de chía\n\n"
          "2. 🥣 Bowl de proteínas:\n"
          "   - Yogur griego\n"
          "   - Plátano y frutos rojos\n"
          "   - Granola casera\n"
          "   - Miel orgánica\n\n"
          "3. 🥞 Tortitas proteicas:\n"
          "   - Avena y claras\n"
          "   - Proteína en polvo\n"
          "   - Canela y vainilla\n"
          "   - Sirope sin azúcar";

    } else if (patronesDefinicion.hasMatch(texto)) {
      return "✨ *Plan Definición Premium*\n\n"
          "🍳 Desayuno (400 kcal):\n"
          "- Tortilla de claras (4 claras)\n"
          "- Avena (40g) con canela\n"
          "- Café negro o té verde\n\n"
          "🥗 Media mañana (200 kcal):\n"
          "- Yogur griego 0%\n"
          "- Frutos rojos\n"
          "- 10 almendras\n\n"
          "🥩 Almuerzo (500 kcal):\n"
          "- Pechuga de pollo (150g)\n"
          "- Ensalada completa\n"
          "- Quinoa (50g)\n\n"
          "🍎 Merienda (200 kcal):\n"
          "- Batido de proteína\n"
          "- Manzana verde\n\n"
          "🐟 Cena (400 kcal):\n"
          "- Merluza al horno\n"
          "- Verduras al vapor\n"
          "- Aceite de oliva (1 cdta)\n\n"
          "💪 *Tips:* Bebe 3L agua/día, entrena 4-5 días/semana";

    } else if (patronesVolumen.hasMatch(texto)) {
      return "🏋️ *Plan Volumen Premium*\n\n"
          "🥞 Desayuno (800 kcal):\n"
          "- Avena (100g)\n"
          "- 4 huevos enteros\n"
          "- Plátano y miel\n"
          "- Mantequilla de cacahuete\n\n"
          "🥪 Media mañana (400 kcal):\n"
          "- Pan integral\n"
          "- Atún y aguacate\n"
          "- Batido de proteínas\n\n"
          "🍖 Almuerzo (900 kcal):\n"
          "- Arroz integral (150g)\n"
          "- Ternera (200g)\n"
          "- Verduras salteadas\n"
          "- Aceite de oliva\n\n"
          "🥜 Post-entreno (400 kcal):\n"
          "- Batido mass gainer\n"
          "- Plátano\n"
          "- Mix frutos secos\n\n"
          "🍗 Cena (700 kcal):\n"
          "- Salmón a la plancha (200g)\n"
          "- Patata asada\n"
          "- Brócoli al vapor\n"
          "- Aceite de oliva (1 cdta)\n\n"
          "💡 *Consejos:* Come cada 3 horas, entrena con pesas 4 veces/semana";

    } else if (patronesMantenimiento.hasMatch(texto)) {
      return "⚖️ *Plan Mantenimiento Equilibrado*\n\n"
          "🥣 Desayuno (500 kcal):\n"
          "- Yogur natural (200g)\n"
          "- Granola (50g)\n"
          "- Frutas del bosque\n"
          "- Semillas de chía\n\n"
          "🥜 Snack (250 kcal):\n"
          "- Tostadas integrales (2) con aguacate\n"
          "- Pavo o pollo fiambre\n\n"
          "🥗 Almuerzo (600 kcal):\n"
          "- Quinoa (100g) con verduras asadas\n"
          "- Pechuga de pollo a la plancha (150g)\n"
          "- Aceite de oliva (1 cdta)\n\n"
          "🍎 Merienda (300 kcal):\n"
          "- Batido de proteínas\n"
          "- 1 plátano\n"
          "- 30g de nueces\n\n"
          "🐟 Cena (500 kcal):\n"
          "- Pescado blanco al horno (200g)\n"
          "- Puré de patata (100g)\n"
          "- Espárragos a la plancha\n"
          "- Aceite de oliva (1 cdta)\n\n"
          "🌙 Snack nocturno (200 kcal):\n"
          "- Requesón (150g) con canela\n"
          "- 1 cucharadita de miel";

    } else {
      return "🤖 *Opciones disponibles:*\n\n"
          "- Recetas para **definición/adelgazar** 🥗\n"
          "- Recetas para **volumen/masa muscular** 💪\n"
          "- Recetas para **mantenimiento** ⚖️\n"
          "- Ideas de **desayunos** 🍳\n\n"
          "👉 Escribe tu objetivo y te daré un plan completo.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Chef NutriVision AI",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            fontFamily: 'Pacifico', // Añade esta fuente a pubspec.yaml
            color: Colors.tealAccent,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
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
                      // Añadir manejo de la tecla Enter
                      onSubmitted: (text) => _enviarMensaje(text),
                      decoration: const InputDecoration(
                        hintText: "Escribe tu objetivo o presiona Enter...",
                        filled: true,
                        fillColor: Color(0xFF7FFFD4),
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