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

  // 📊 Cálculo de macros
  Future<void> calcular() async {
    try {
      final peso = double.parse(pesoController.text.replaceAll(",", "."));
      final altura = double.parse(alturaController.text.replaceAll(",", "."));
      final edad = int.parse(edadController.text.replaceAll(",", "."));

      final data = await ApiService.calcularMacros(
        peso: peso,
        altura: altura,
        edad: edad,
        objetivo: objetivo,
      );

      setState(() {
        resultado = data["macros"].toString();
      });

      // 🧠 En lugar de navegar a PlanPage, mostramos un mensaje
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
      color: Colors.tealAccent, // 👈 solo el texto con este color
    ),
  ),
  backgroundColor: Colors.transparent, // 👈 sin fondo detrás del texto
  elevation: 0,
),
      body: SingleChildScrollView(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 80),

              _campoTexto("Peso (kg)", pesoController),
              const SizedBox(height: 10),
              _campoTexto("Altura (cm)", alturaController), 
              const SizedBox(height: 10),
              _campoTexto("Edad", edadController),
              const SizedBox(height: 10),

              // 🎯 Selección del objetivo
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

              const SizedBox(height: 20),

              // 🔘 Botón Calcular
              ElevatedButton(
                onPressed: calcular,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.tealAccent,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30, vertical: 12),
                ),
                child: const Text("Calcular"),
              ),

              const SizedBox(height: 10),

              // 💾 Botón Exportar CSV
              ElevatedButton(
                onPressed: exportarCSV,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30, vertical: 12),
                ),
                child: const Text("Exportar CSV"),
              ),

              const SizedBox(height: 30),

              // 🧾 Resultado
              Text(
                resultado,
                style: const TextStyle(
                    fontSize: 16, color: Colors.white, height: 1.4),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 📋 Campo de texto reutilizable
  TextField _campoTexto(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: _decoracionCampo(label),
      keyboardType: TextInputType.number,
      style: const TextStyle(color: Colors.white),
    );
  }

  // 🎨 Estilo visual de los campos
  InputDecoration _decoracionCampo(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.tealAccent),
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
