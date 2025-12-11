// lib/screens/recetas_screen.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:nutrivision_ai/models/services/nutrition_service.dart';
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
    _cargarConversacion();
  }

  // -------------------------
  // PERSISTENCIA
  // -------------------------
  Future<void> _guardarConversacion() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      prefs.setString("chat_nutricion", jsonEncode(_mensajes));
    } catch (e) {
      // En caso de error de encoding, evitar crashear
      debugPrint("Error guardando conversación: $e");
    }
  }

  Future<void> _cargarConversacion() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString("chat_nutricion");

    if (data != null) {
      try {
        final List<dynamic> decoded = jsonDecode(data);
        final loaded = decoded
            .map((e) =>
                (e as Map).map((k, v) => MapEntry(k.toString(), v.toString())))
            .toList()
            .cast<Map<String, String>>();

        setState(() {
          _mensajes.addAll(loaded);
        });
      } catch (e) {
        debugPrint("Error cargando conversación: $e");
        _agregarMensajeBienvenida();
      }
    } else {
      _agregarMensajeBienvenida();
    }
  }

  void _agregarMensajeBienvenida() {
    _addBotMessage(
      "¡Hola! Soy NutriBot 🤖\n\n"
      "Puedo ayudarte con:\n"
      "• Calorías y macros de alimentos (escribe 'pollo')\n"
      "• Recetas para definición, volumen o mantenimiento (escribe 'definición', 'volumen', 'mantenimiento')\n"
      "• Dudas generales de nutrición\n\n"
      "¡Escribe lo que necesites!",
    );
  }

  Future<void> _limpiarChat() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF051D16),
          title: const Text(
            "Limpiar Chat",
            style: TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold),
          ),
          content: const Text(
            "¿Estás seguro de que deseas borrar todo el historial de conversación?",
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar", style: TextStyle(color: Colors.white70)),
            ),
            TextButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove("chat_nutricion");
                setState(() => _mensajes.clear());
                _agregarMensajeBienvenida();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("✅ Chat limpiado correctamente"),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: const Text("Eliminar", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  // -------------------------
  // UTILIDADES de mensajes
  // -------------------------
  void _addUserMessage(String text) {
    setState(() => _mensajes.add({"role": "user", "text": text}));
    _guardarConversacion();
  }

  void _addBotMessage(String text) {
    setState(() => _mensajes.add({"role": "bot", "text": text}));
    _guardarConversacion();
  }

  // -------------------------
  // Normalización y detección
  // -------------------------
  String normalizar(String text) {
    final result = text
        .toLowerCase()
        // acentos
        .replaceAll(RegExp(r'[áàäâ]'), 'a')
        .replaceAll(RegExp(r'[éèëê]'), 'e')
        .replaceAll(RegExp(r'[íìïî]'), 'i')
        .replaceAll(RegExp(r'[óòöô]'), 'o')
        .replaceAll(RegExp(r'[úùüû]'), 'u')
        // caracteres no alfanuméricos (conservamos espacios)
        .replaceAll(RegExp(r'[^a-z0-9 ]'), '')
        .trim();
    return result;
  }

  bool esObjetivo(String texto) {
    final t = normalizar(texto);

    final definicion = [
      "definicion",
      "defini",
      "defin",
      "adelgaz",
      "perderpeso",
      "cut",
      "cutting",
      "lean",
      "shred",
      "bajar",
      "bajarpeso"
    ];

    final volumen = [
      "volumen",
      "volum",
      "masa",
      "musculo",
      "muscular",
      "bulk",
      "bulking",
      "ganarpeso",
      "subirpeso"
    ];

    final mantenimiento = [
      "mantenimiento",
      "mantener",
      "manteni",
      "equilibrio",
      "balance",
      "estable"
    ];

    // Si contiene alguna de las palabras clave (substrings)
    final isDef = definicion.any((p) => t.contains(p));
    final isVol = volumen.any((p) => t.contains(p));
    final isMan = mantenimiento.any((p) => t.contains(p));

    return isDef || isVol || isMan;
  }

  // -------------------------
  // Envío / flujo principal
  // -------------------------
  void _enviarMensaje(String texto) {
    if (texto.trim().isEmpty) return;

    if (normalizar(texto).contains("clear") || normalizar(texto).contains("limpiar")) {
      _limpiarChat();
      _controller.clear();
      return;
    }

    _addUserMessage(texto);
    _controller.clear();

    final normalized = normalizar(texto);

    // 1) Objetivo nutricional (definición, volumen, mantenimiento)
    if (esObjetivo(normalized)) {
      _responderConReceta(normalized);
      return;
    }

    // 2) Detectar alimento (1 o 2 palabras típicamente)
    final wordCount = texto.trim().split(RegExp(r'\s+')).length;
    if (wordCount <= 2) {
      _buscarAlimentoYResponder(normalized);
      return;
    }

    // 3) Pregunta general
    _responderPreguntaGeneral(normalized);
  }

  // -------------------------
  // BUSCAR ALIMENTO EN API
  // -------------------------
  Future<void> _buscarAlimentoYResponder(String nombre) async {
    _addBotMessage("Buscando '$nombre' en la base de datos nutricional...");

    try {
      final resultado = await NutritionService.buscarAlimento(nombre);

      if (resultado != null) {
        final nombreRes = resultado['nombre'] ?? nombre;
        final calorias = resultado['calorias']?.toString() ?? 'N/A';
        final proteinas = resultado['proteinas_g']?.toString() ?? 'N/A';
        final carbs = resultado['carbohidratos_g']?.toString() ?? 'N/A';
        final grasas = resultado['grasas_g']?.toString() ?? 'N/A';

        final mensaje = """
📊 *$nombreRes*

🔥 Calorías: $calorias kcal  
🥚 Proteínas: $proteinas g  
🍞 Carbohidratos: $carbs g  
🥑 Grasas: $grasas g

💡 ¿Quieres una receta con este alimento?
""";
        _addBotMessage(mensaje);
      } else {
        _addBotMessage("❌ No encontré '$nombre'. ¿Quieres probar con otro nombre?");
      }
    } catch (e) {
      debugPrint("Error buscando alimento: $e");
      _addBotMessage("❌ Ocurrió un error buscando el alimento. Intenta de nuevo.");
    }
  }

  // -------------------------
  // RESPONDER RECETAS / OBJETIVOS
  // -------------------------
  void _responderConReceta(String texto) {
    final t = normalizar(texto);

    // --- DEFINICIÓN ---
    if (t.contains("defin") ||
        t.contains("adelgaz") ||
        t.contains("perder") ||
        t.contains("cut") ||
        t.contains("lean") ||
        t.contains("shred") ||
        t.contains("bajarpeso") ||
        t.contains("bajar")) {
      _addBotMessage(
        "🔥 *Plan de Definición*\n\n"
        "• Objetivo: déficit calórico ligero y alta proteína.\n\n"
        "Desayuno (≈400 kcal):\n"
        "- Tortilla de claras + avena (40 g)\n\n"
        "Almuerzo (≈500 kcal):\n"
        "- Pechuga de pollo (150 g) + ensalada + quinoa (50 g)\n\n"
        "Cena (≈400 kcal):\n"
        "- Pescado blanco + verduras al vapor\n\n"
        "💡 *Consejo:* Mantén un déficit aproximado de -250 a -500 kcal según tu TDEE y prioriza proteínas (2.0 g/kg si entrenas).",
      );
      return;
    }

    // --- VOLUMEN ---
    if (t.contains("volum") ||
        t.contains("masa") ||
        t.contains("muscul") ||
        t.contains("bulk") ||
        t.contains("ganarpeso") ||
        t.contains("subirpeso")) {
      _addBotMessage(
        "💪 *Plan de Volumen*\n\n"
        "• Objetivo: superávit calórico controlado + carga de entrenamiento.\n\n"
        "Desayuno (≈700-900 kcal):\n"
        "- Avena (100 g) + 4 huevos + plátano\n\n"
        "Almuerzo (≈800-1000 kcal):\n"
        "- Arroz integral (150 g) + ternera (200 g) + verduras\n\n"
        "Cena (≈700 kcal):\n"
        "- Pasta integral + pollo + aceite de oliva\n\n"
        "💡 *Consejo:* Superávit de +250 a +500 kcal y proteína suficiente (~1.6-2.2 g/kg).",
      );
      return;
    }

    // --- MANTENIMIENTO ---
    if (t.contains("manten") ||
        t.contains("mantener") ||
        t.contains("equilibrio") ||
        t.contains("balance") ||
        t.contains("estable")) {
      _addBotMessage(
        "⚖️ *Plan de Mantenimiento*\n\n"
        "• Objetivo: mantener peso y composición corporal.\n\n"
        "Desayuno (≈500 kcal):\n"
        "- Yogur natural (200 g) + granola (50 g) + fruta\n\n"
        "Almuerzo (≈600 kcal):\n"
        "- Quinoa (100 g) + pechuga de pollo (150 g) + ensalada\n\n"
        "Cena (≈500 kcal):\n"
        "- Pescado + verduras + patata asada\n\n"
        "💡 *Consejo:* Mantén tu TDEE como referencia y ajusta pequeñas porciones si subes o bajas peso.",
      );
      return;
    }

    // fallback
    _addBotMessage("🤖 No quedé totalmente seguro del objetivo — ¿te refieres a definición, volumen o mantenimiento?");
  }

  // -------------------------
  // RESPUESTAS GENERALES
  // -------------------------
  void _responderPreguntaGeneral(String text) {
    final t = normalizar(text);

    if (t.contains("proteina") || t.contains("proteinas")) {
      _addBotMessage(
        "🥚 *Proteínas*: construyen y reparan tejido muscular, ayudan a la saciedad. Fuentes: pollo, pescado, huevos, legumbres. Recomendación: 1.2–2.2 g/kg según actividad.",
      );
      return;
    }

    if (t.contains("caloria") || t.contains("calorias") || t.contains("kcal")) {
      _addBotMessage(
        "🔥 *Calorías*: unidad de energía. Si gastas más de lo que comes pierdes peso; si comes más de lo que gastas subes. Tu TDEE es la base para ajustar déficit/superávit.",
      );
      return;
    }

    if (t.contains("carbohidrato") || t.contains("carbohidratos")) {
      _addBotMessage(
        "🍞 *Carbohidratos*: principal fuente de energía. Importante en entrenamiento. Prioriza fuentes completas como arroz integral, avena y patata.",
      );
      return;
    }

    if (t.contains("gras") || t.contains("grasas") || t.contains("lipidos")) {
      _addBotMessage(
        "🥑 *Grasas*: necesarias para hormonas y absorción de vitaminas. Incluye grasas saludables: aceite de oliva, frutos secos, aguacate. Mantén en torno 20-35% de calorías totales.",
      );
      return;
    }

    // Respuesta por defecto cuando no se reconoce
    _addBotMessage(
      "🤖 No estoy seguro de la pregunta. Puedo ayudarte si escribes:\n"
      "• Un alimento (ej. 'pollo') → datos nutricionales\n"
      "• Un objetivo (ej. 'definición', 'volumen', 'mantenimiento') → plan\n"
      "• Dudas (ej. 'qué son las proteínas')",
    );
  }

  // -------------------------
  // UI
  // -------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Chef NutriVision AI",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.tealAccent.withOpacity(0.9),
        elevation: 4,
        shadowColor: Colors.tealAccent.withOpacity(0.5),
        actions: [
          Tooltip(
            message: "Limpiar chat",
            child: IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.white, size: 24),
              onPressed: _limpiarChat,
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/fotofondochat.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: _mensajes.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/image4.png',
                            height: 120,
                            width: 120,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            "NutriVision AI",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.tealAccent,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Tu asistente de nutrición personalizada",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: _mensajes.length,
                      itemBuilder: (context, index) {
                        final msg = _mensajes[index];
                        final isUser = msg["role"] == "user";
                        return Align(
                          alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            padding: const EdgeInsets.all(14),
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.85,
                            ),
                            decoration: BoxDecoration(
                              color: isUser 
                                ? Colors.tealAccent 
                                : Colors.black.withOpacity(0.75),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isUser ? Colors.tealAccent : Colors.tealAccent.withOpacity(0.8),
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: isUser 
                                    ? Colors.tealAccent.withOpacity(0.3)
                                    : Colors.black.withOpacity(0.4),
                                  blurRadius: 8,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: Text(
                              msg["text"] ?? "",
                              style: TextStyle(
                                color: isUser ? Colors.black : Colors.white,
                                fontSize: 15,
                                fontWeight: isUser ? FontWeight.w600 : FontWeight.w500,
                                height: 1.4,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.tealAccent.withOpacity(0.05),
                border: Border(top: BorderSide(color: Colors.tealAccent, width: 1)),
              ),
              padding: const EdgeInsets.all(10.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(25),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        onSubmitted: _enviarMensaje,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: InputDecoration(
                          hintText: "Ej: 'pollo' o 'receta para volumen' (escribe 'clear' para limpiar)",
                          hintStyle: const TextStyle(color: Colors.white60, fontSize: 14),
                          filled: true,
                          fillColor: Colors.transparent,
                          prefixIcon: const Icon(Icons.search, color: Colors.tealAccent, size: 24),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.tealAccent,
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.tealAccent.withOpacity(0.5),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.send, color: Colors.black, size: 22),
                        onPressed: () => _enviarMensaje(_controller.text),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
