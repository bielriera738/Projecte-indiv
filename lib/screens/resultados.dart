import 'package:flutter/material.dart';

class ResultadosPlanScreen extends StatelessWidget {
  final Map<String, dynamic> data;
  const ResultadosPlanScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final resumen = data["resumen"] ?? {};
    final macros = data["macros"] ?? {};
    final consejos = List<String>.from(data["consejos"] ?? []);
    final recetas = List<String>.from(data["recetas"] ?? []);

    Card card(String title, Widget child) => Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(title: const Text("Tu Plan Nutricional")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          card(
            "Resumen",
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("TMB: ${resumen["tmb"]} kcal"),
                Text("TDEE: ${resumen["tdee"]} kcal"),
                Text("IMC: ${resumen["imc"]} (${resumen["categoria_imc"]})"),
                Text("Peso ideal: ${resumen["peso_ideal"]} kg"),
                Text("Objetivo: ${resumen["objetivo"]}"),
                if (resumen["ritmo_aprox_kg_sem"] != null)
                  Text(
                    "Ritmo recomendado: ${resumen["ritmo_aprox_kg_sem"]} kg/sem",
                  ),
              ],
            ),
          ),
          card(
            "Macros objetivos",
            Text(
              "Calorías: ${macros["calorias"]} kcal\n"
              "Proteínas: ${macros["proteinas"]} g\n"
              "Grasas: ${macros["grasas"]} g\n"
              "Carbohidratos: ${macros["carbohidratos"]} g",
            ),
          ),
          if (consejos.isNotEmpty)
            card(
              "Consejos",
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: consejos.map((c) => Text("• $c")).toList(),
              ),
            ),
          if (recetas.isNotEmpty)
            card(
              "Recetas sugeridas",
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: recetas.map((r) => Text("• $r")).toList(),
              ),
            ),
        ],
      ),
    );
  }
}
