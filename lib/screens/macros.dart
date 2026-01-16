import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class MacrosScreen extends StatefulWidget {
  const MacrosScreen({super.key});

  @override
  State<MacrosScreen> createState() => _MacrosScreenState();
}

class _MacrosScreenState extends State<MacrosScreen> {
  final pesoController = TextEditingController();
  final alturaController = TextEditingController();
  final edadController = TextEditingController();
  String objetivo = "Volumen";
  String resultado = "";
  bool _calculando = false;
  bool _exportando = false;

  // 📊 Cálculo de macros

Future<void> calcular() async {
  if (_calculando) return;
  
  try {
    final pesoText = pesoController.text.trim();
    final alturaText = alturaController.text.trim();
    final edadText = edadController.text.trim();

    if (pesoText.isEmpty || alturaText.isEmpty || edadText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Por favor completa todos los campos"),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() => _calculando = true);

    final peso = double.parse(pesoText.replaceAll(",", "."));
    final altura = double.parse(alturaText.replaceAll(",", "."));
    final edad = int.parse(edadText);

    // 🔄 CÁLCULO LOCAL (sin backend, sin ApiService)
    // Fórmula Mifflin-St Jeor (género masculino, actividad ligera)
    double tdee = (10 * peso + 6.25 * altura - 5 * edad + 5) * 1.375;

    int calorias;
    if (objetivo == "Definición") {
      calorias = (tdee - 500).toInt();
    } else if (objetivo == "Volumen") {
      calorias = (tdee + 300).toInt();
    } else { // Mantenimiento
      calorias = tdee.toInt();
    }

    // Proteínas más humanizadas: ajuste por objetivo
    double proteinaPorKg = 1.6; // mantenimiento por defecto
    if (objetivo == "Definición") proteinaPorKg = 2.0; // más alto en déficit
    if (objetivo == "Volumen") proteinaPorKg = 1.8; // volumen moderado
    int proteinasG = (peso * proteinaPorKg).toInt();
    int grasasG = (calorias * 0.25 / 9).toInt();
    int carbohidratosG = ((calorias - (proteinasG * 4 + grasasG * 9)) / 4).toInt();
    carbohidratosG = carbohidratosG < 0 ? 0 : carbohidratosG; // Evitar negativos

    setState(() {
      resultado = """
Calorías: $calorias kcal
Proteínas: $proteinasG g
Grasas: $grasasG g
Carbohidratos: $carbohidratosG g
""";
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("✅ Macros calculados correctamente"),
        backgroundColor: Colors.green,
      ),
    );
  } catch (e) {
    setState(() {
      resultado = "❌ Error: $e";
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Error: $e"),
        backgroundColor: Colors.redAccent,
      ),
    );
  } finally {
    setState(() => _calculando = false);
  }
}

  // 📤 Exportar resultados a CSV en ubicación local
  Future<void> exportarCSV() async {
    if (_exportando) return;
    try {
      setState(() => _exportando = true);

      final appDir = await getApplicationDocumentsDirectory();
      String fileName = "macros_${DateTime.now().millisecondsSinceEpoch}.csv";
      String filePath = "${appDir.path}/$fileName";

      final csvString = """Peso,Altura,Edad,Objetivo,Macros
${pesoController.text},${alturaController.text},${edadController.text},$objetivo,"$resultado"
""";

      final file = File(filePath);
      await file.writeAsString(csvString);

      setState(() {
        resultado = "✅ Datos exportados en:\n$filePath";
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("📁 Datos exportados correctamente en:\n$filePath"),
          backgroundColor: Colors.orangeAccent,
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      setState(() {
        resultado = "❌ Error al exportar: $e";
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error al exportar: $e"),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      setState(() => _exportando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          "Calcular Macros",
          style: TextStyle(
            color: Colors.tealAccent,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
        child: Column(
          children: [
            const SizedBox(height: 60),
            // Card personalizado para los campos
            Card(
              color: const Color(0xFF072119),
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
                child: Column(
                  children: [
                    // Título personalizado
                    Row(
                      children: const [
                        Icon(Icons.calculate, color: Colors.tealAccent),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "Introduce tus datos",
                            style: TextStyle(
                              color: Colors.tealAccent,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Peso
                    _campoTextoNumeric(
                      label: "Peso (kg)",
                      controller: pesoController,
                      hint: "ej. 72.5",
                      icon: Icons.monitor_weight,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 12),

                    // Altura
                    _campoTextoNumeric(
                      label: "Altura (cm)",
                      controller: alturaController,
                      hint: "ej. 175",
                      icon: Icons.height,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 12),

                    // Edad
                    _campoTextoNumeric(
                      label: "Edad",
                      controller: edadController,
                      hint: "ej. 30",
                      icon: Icons.cake,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => calcular(),
                    ),
                    const SizedBox(height: 12),

                    // Objetivo
                    DropdownButtonFormField<String>(
                      initialValue: objetivo,
                      dropdownColor: Colors.black87,
                      decoration: _decoracionCampo("Objetivo"),
                      items: ["Definición", "Volumen", "Mantenimiento"]
                          .map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(
                                  e,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          objetivo = value!;
                        });
                      },
                    ),

                    const SizedBox(height: 18),

                    // Botones grandes y personalizados
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _calculando ? null : calcular,
                            icon: _calculando
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.black,
                                    ),
                                  )
                                : const Icon(Icons.calculate_outlined,
                                    color: Colors.black),
                            label: Text(
                              _calculando ? "Calculando..." : "Calcular",
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 16),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.tealAccent,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 20),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton.icon(
                          onPressed: _exportando ? null : exportarCSV,
                          icon: _exportando
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.black,
                                  ),
                                )
                              : const Icon(Icons.file_upload,
                                  color: Colors.black),
                          label: Text(
                            _exportando ? "..." : "Exportar",
                            style: const TextStyle(color: Colors.black, fontSize: 14),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orangeAccent,
                            padding: const EdgeInsets.symmetric(
                                vertical: 14, horizontal: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Resultado en tarjeta destacada
            Card(
              color: const Color(0xFF071B18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: const BorderSide(color: Colors.tealAccent, width: 1),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Resultado",
                        style: TextStyle(
                            color: Colors.tealAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SelectableText(
                      resultado.isEmpty
                          ? "Aquí aparecerán tus macronutrientes calculados."
                          : resultado,
                      style: const TextStyle(
                          fontSize: 16, color: Colors.white, height: 1.4),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton.icon(
                          onPressed: () {
                            // copiar resultado al portapapeles
                            if (resultado.isNotEmpty) {
                              // implementación simple sin paquete: mostrar SnackBar
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Resultado copiado (no implementado clipboard)"),
                                ),
                              );
                            }
                          },
                          icon: const Icon(Icons.copy, color: Colors.tealAccent),
                          label: const Text(
                            "Copiar",
                            style: TextStyle(color: Colors.tealAccent),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // 📋 Campo de texto reutilizable para números, más grande y personalizado
  Widget _campoTextoNumeric({
    required String label,
    required TextEditingController controller,
    String? hint,
    IconData? icon,
    TextInputAction textInputAction = TextInputAction.next,
    void Function(String)? onSubmitted,
  }) {
    return TextField(
      controller: controller,
      keyboardType:
          const TextInputType.numberWithOptions(decimal: true, signed: false),
      textInputAction: textInputAction,
      onSubmitted: onSubmitted,
      style: const TextStyle(color: Colors.white, fontSize: 18),
      decoration: _decoracionCampo(label).copyWith(
        hintText: hint,
        prefixIcon: icon != null
            ? Icon(icon, color: Colors.tealAccent)
            : null,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
      ),
    );
  }

  // 🎨 Estilo visual de los campos
  InputDecoration _decoracionCampo(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.tealAccent),
      filled: true,
      fillColor: const Color(0xFF04221E),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.tealAccent),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}