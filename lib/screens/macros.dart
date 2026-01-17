import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../services/exportarservicios.dart';

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

      // Cálculo local usando fórmula Mifflin-St Jeor (género masculino, actividad ligera)
      double tdee = (10 * peso + 6.25 * altura - 5 * edad + 5) * 1.375;

      int calorias;
      if (objetivo == "Definición") {
        calorias = (tdee - 500).toInt();
      } else if (objetivo == "Volumen") {
        calorias = (tdee + 300).toInt();
      } else {
        // Mantenimiento
        calorias = tdee.toInt();
      }

      // Proteínas más humanizadas: ajuste por objetivo
      double proteinaPorKg = 1.6; // mantenimiento por defecto
      if (objetivo == "Definición") proteinaPorKg = 2.0; // más alto en déficit
      if (objetivo == "Volumen") proteinaPorKg = 1.8; // volumen moderado
      int proteinasG = (peso * proteinaPorKg).toInt();
      int grasasG = (calorias * 0.25 / 9).toInt();
      int carbohidratosG = ((calorias - (proteinasG * 4 + grasasG * 9)) / 4)
          .toInt();
      carbohidratosG = carbohidratosG < 0
          ? 0
          : carbohidratosG; // Evitar negativos

      setState(() {
        resultado =
            """
Calorías: $calorias kcal
Proteínas: $proteinasG g
Grasas: $grasasG g
Carbohidratos: $carbohidratosG g
""";
      });

      // Guardar automáticamente en historial
      final prefs = await SharedPreferences.getInstance();
      List<String> historial = prefs.getStringList('historial_exportaciones') ?? [];
      
      final exportacion = {
        'fecha': DateTime.now().toIso8601String(),
        'peso': pesoText,
        'altura': alturaText,
        'edad': edadText,
        'objetivo': objetivo,
        'resultado': resultado,
        'calorias': calorias,
        'proteinas': proteinasG,
        'grasas': grasasG,
        'carbohidratos': carbohidratosG,
        'csv': 'Peso,Altura,Edad,Objetivo,Calorias,Proteinas,Grasas,Carbohidratos\n$pesoText,$alturaText,$edadText,$objetivo,$calorias,$proteinasG,$grasasG,$carbohidratosG',
      };
      
      historial.insert(0, jsonEncode(exportacion));
      if (historial.length > 20) historial = historial.sublist(0, 20);
      await prefs.setStringList('historial_exportaciones', historial);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Macros calculados correctamente"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() {
        resultado = "Error: $e";
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), backgroundColor: Colors.redAccent),
      );
    } finally {
      setState(() => _calculando = false);
    }
  }

  Future<void> exportarCSV() async {
    if (_exportando) return;

    if (resultado.isEmpty || pesoController.text.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Primero calcula tus macros antes de exportar"),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }

    try {
      setState(() => _exportando = true);

      // Contenido del CSV
      final csvContent = """Peso,Altura,Edad,Objetivo,Macros
${pesoController.text},${alturaController.text},${edadController.text},$objetivo,"$resultado"
""";

      // Guardar en historial local con SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      List<String> historial = prefs.getStringList('historial_exportaciones') ?? [];
      
      final exportacion = {
        'fecha': DateTime.now().toIso8601String(),
        'peso': pesoController.text,
        'altura': alturaController.text,
        'edad': edadController.text,
        'objetivo': objetivo,
        'resultado': resultado,
        'csv': csvContent,
      };
      
      historial.insert(0, jsonEncode(exportacion));
      if (historial.length > 20) historial = historial.sublist(0, 20);
      await prefs.setStringList('historial_exportaciones', historial);

      // Guardar archivo CSV en Descargas (Windows) o almacenamiento externo (Android)
      final fileName = "macros_nutrivision_${DateTime.now().millisecondsSinceEpoch}";
      final savedPath = await ExportService.exportCSVString(csvContent, fileName);

      setState(() {
        resultado = "$resultado\n\nArchivo guardado en: $savedPath";
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("CSV guardado: $savedPath"),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 4),
            action: SnackBarAction(
              label: 'COPIAR RUTA',
              textColor: Colors.white,
              onPressed: () {
                Clipboard.setData(ClipboardData(text: savedPath));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Ruta copiada')),
                );
              },
            ),
          ),
        );
      }
    } catch (e) {
      setState(() {
        resultado = "Error al exportar: $e";
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: $e"),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      setState(() => _exportando = false);
    }
  }

  void _mostrarHistorial() async {
    final prefs = await SharedPreferences.getInstance();
    final historial = prefs.getStringList('historial_exportaciones') ?? [];
    
    if (!mounted) return;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Historial de Exportaciones'),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: historial.isEmpty
              ? const Center(child: Text('No hay exportaciones guardadas'))
              : ListView.builder(
                  itemCount: historial.length,
                  itemBuilder: (context, index) {
                    final data = jsonDecode(historial[index]);
                    final fecha = DateTime.parse(data['fecha']);
                    return ListTile(
                      title: Text('${data['peso']} kg - ${data['objetivo']}'),
                      subtitle: Text('${fecha.day}/${fecha.month}/${fecha.year}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.copy),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: data['csv']));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('CSV copiado')),
                          );
                        },
                      ),
                    );
                  },
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CERRAR'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          "Calcular Macros",
          style: TextStyle(color: Colors.teal),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 60),
                // Card personalizado para los campos
                Card(
                  color: Colors.white,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 20,
                    ),
                    child: Column(
                      children: [
                        // Título personalizado
                        Row(
                          children: const [
                            Icon(Icons.calculate, color: Colors.teal),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                "Introduce tus datos",
                                style: TextStyle(
                                  color: Colors.teal,
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
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(
                                    e,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              )
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
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Icon(
                                        Icons.calculate_outlined,
                                        color: Colors.white,
                                      ),
                                label: Text(
                                  _calculando ? "Calculando..." : "Calcular",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.teal,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                    horizontal: 20,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
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
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Icon(
                                      Icons.file_upload,
                                      color: Colors.white,
                                    ),
                              label: Text(
                                _exportando ? "..." : "Exportar",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                  horizontal: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Resultado en tarjeta destacada
                Card(
                  color: Colors.grey.shade50,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: const BorderSide(color: Colors.teal, width: 1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 18,
                    ),
                    child: Column(
                      children: [
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Resultado",
                            style: TextStyle(
                              color: Colors.teal,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        SelectableText(
                          resultado.isEmpty
                              ? "Aquí aparecerán tus macronutrientes calculados."
                              : resultado,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                            height: 1.4,
                          ),
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
                                      content: Text(
                                        "Resultado copiado (no implementado clipboard)",
                                      ),
                                    ),
                                  );
                                }
                              },
                              icon: const Icon(Icons.copy, color: Colors.teal),
                              label: const Text(
                                "Copiar",
                                style: TextStyle(color: Colors.teal),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

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
      keyboardType: const TextInputType.numberWithOptions(
        decimal: true,
        signed: false,
      ),
      textInputAction: textInputAction,
      onSubmitted: onSubmitted,
      style: const TextStyle(color: Colors.white, fontSize: 18),
      decoration: _decoracionCampo(label).copyWith(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white54),
        prefixIcon: icon != null ? Icon(icon, color: Colors.teal) : null,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 12,
        ),
      ),
    );
  }

  InputDecoration _decoracionCampo(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      filled: true,
      fillColor: Colors.black87,
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.teal, width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.teal, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
