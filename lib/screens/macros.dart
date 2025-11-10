import 'package:flutter/material.dart';
import 'package:nutrivision_ai/models/services/apiservice.dart';
import 'package:nutrivision_ai/services/exportarservicios.dart';

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
      final edad = int.parse(edadText.replaceAll(",", "."));

      final data = await ApiService.calcularMacros(
        peso: peso,
        altura: altura,
        edad: edad,
        objetivo: objetivo,
      );

      setState(() {
        resultado = data["macros"]?.toString() ?? "No hay resultados";
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

  // 📤 Exportar resultados a CSV
  Future<void> exportarCSV() async {
    try {
      final path = await ExportService.exportToCSV(
        [
          ["Peso", "Altura", "Edad", "Objetivo", "Macros"],
          [
            pesoController.text,
            alturaController.text,
            edadController.text,
            objetivo,
            resultado
          ]
        ],
        "mis_macros",
      );

      setState(() {
        resultado = "✅ Datos exportados en:\n$path";
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("📁 Datos exportados correctamente"),
          backgroundColor: Colors.orangeAccent,
        ),
      );
    } catch (e) {
      setState(() {
        resultado = "❌ Error al exportar: $e";
      });
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
                      value: objetivo,
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
                          onPressed: exportarCSV,
                          icon: const Icon(Icons.file_upload,
                              color: Colors.black),
                          label: const Text(
                            "Exportar",
                            style:
                                TextStyle(color: Colors.black, fontSize: 14),
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
