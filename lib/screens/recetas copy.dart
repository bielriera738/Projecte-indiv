import 'package:flutter/material.dart';

class Receta {
  final String id;
  final String titulo;
  final String imagen;
  final int calorias;
  final int tiempoPreparacion;
  final String categoria;
  final List<String> ingredientes;
  final List<String> pasos;
  final int proteinas;
  final int carbohidratos;
  final int grasas;
  final List<String> tags;
  final int porcionGramos;

  Receta({
    required this.id,
    required this.titulo,
    required this.imagen,
    required this.calorias,
    required this.tiempoPreparacion,
    required this.categoria,
    required this.ingredientes,
    required this.pasos,
    required this.proteinas,
    required this.carbohidratos,
    required this.grasas,
    required this.tags,
    this.porcionGramos = 100,
  });
}

final List<Receta> recetasDatabase = [
  Receta(
    id: '1',
    titulo: 'Tortilla de Claras con Avena',
    imagen: '🥚',
    calorias: 350,
    tiempoPreparacion: 15,
    categoria: 'Desayuno',
    proteinas: 25,
    carbohidratos: 35,
    grasas: 8,
    tags: ['Definición', 'Alto en proteína'],
    ingredientes: [
      '4 claras de huevo',
      '50g de avena',
      '1 plátano',
      '10ml de aceite de oliva',
      'Sal y pimienta',
    ],
    pasos: [
      'Bate las claras de huevo con un tenedor',
      'Cocina la avena en agua 5 minutos',
      'Vierte las claras en la sartén con aceite',
      'Cuando cuaje, añade la avena cocinada',
      'Corta el plátano encima y sirve caliente',
    ],
  ),
  Receta(
    id: '2',
    titulo: 'Pechuga de Pollo con Quinoa',
    imagen: '🍗',
    calorias: 520,
    tiempoPreparacion: 25,
    categoria: 'Comida',
    proteinas: 45,
    carbohidratos: 50,
    grasas: 10,
    tags: ['Definición', 'Equilibrado'],
    ingredientes: [
      '200g pechuga de pollo',
      '100g quinoa cocida',
      '200g verduras variadas',
      '15ml aceite de oliva',
      'Limón y especias',
    ],
    pasos: [
      'Cocina la quinoa según instrucciones',
      'Sazona el pollo con especias y limón',
      'Cocina a fuego medio 15-20 minutos',
      'Saltea las verduras en otra sartén',
      'Monta el plato y sirve caliente',
    ],
  ),
  Receta(
    id: '3',
    titulo: 'Batido de Proteína + Frutas',
    imagen: '🥤',
    calorias: 280,
    tiempoPreparacion: 5,
    categoria: 'Desayuno',
    proteinas: 30,
    carbohidratos: 32,
    grasas: 5,
    tags: ['Rápido', 'Alto en proteína'],
    ingredientes: [
      '1 scoop proteína en polvo',
      '200ml leche desnatada',
      '100g plátano',
      '50g frutos rojos',
      '10ml miel',
    ],
    pasos: [
      'Vierte la leche en la licuadora',
      'Añade el polvo de proteína',
      'Corta el plátano y añade',
      'Agrega los frutos rojos',
      'Licúa hasta suave y sirve inmediatamente',
    ],
  ),
  Receta(
    id: '4',
    titulo: 'Salmón con Verduras al Horno',
    imagen: '🐟',
    calorias: 480,
    tiempoPreparacion: 30,
    categoria: 'Cena',
    proteinas: 40,
    carbohidratos: 25,
    grasas: 22,
    tags: ['Omega-3', 'Equilibrado'],
    ingredientes: [
      '180g salmón fresco',
      '300g verduras mixtas',
      '20ml aceite de oliva',
      'Limón, ajo y hierbas',
      'Sal y pimienta',
    ],
    pasos: [
      'Precalienta horno a 200°C',
      'Coloca el salmón en bandeja',
      'Rodea con verduras cortadas',
      'Rocía con aceite y especias',
      'Hornea 20-25 minutos hasta cocer',
    ],
  ),
  Receta(
    id: '5',
    titulo: 'Arroz Integral con Ternera',
    imagen: '🍚',
    calorias: 650,
    tiempoPreparacion: 35,
    categoria: 'Comida',
    proteinas: 50,
    carbohidratos: 65,
    grasas: 15,
    tags: ['Volumen', 'Alto en calorías'],
    ingredientes: [
      '150g arroz integral',
      '200g carne de ternera',
      '100g brócoli',
      '20ml aceite de oliva',
      'Especias variadas',
    ],
    pasos: [
      'Cocina el arroz en agua durante 25 minutos',
      'Sofríe la ternera con especias',
      'Cuando esté lista, añade el brócoli',
      'Mezcla todo junto',
      'Sirve caliente y disfruta',
    ],
  ),
  Receta(
    id: '6',
    titulo: 'Ensalada de Pollo Mediterránea',
    imagen: '🥗',
    calorias: 380,
    tiempoPreparacion: 20,
    categoria: 'Comida',
    proteinas: 35,
    carbohidratos: 30,
    grasas: 14,
    tags: ['Bajas en grasa', 'Ligero'],
    ingredientes: [
      '150g pechuga pollo cocida',
      '200g lechuga variada',
      '50g tomates cherry',
      '30g queso feta',
      '20ml aceite de oliva',
      'Limón y orégano',
    ],
    pasos: [
      'Lava y corta la lechuga',
      'Corta los tomates por la mitad',
      'Desmenúza el pollo cocido',
      'Mezcla todos los ingredientes',
      'Adereza con aceite, limón y orégano',
    ],
  ),
  Receta(
    id: '7',
    titulo: 'Yogur Griego con Granola',
    imagen: '🥛',
    calorias: 320,
    tiempoPreparacion: 3,
    categoria: 'Desayuno',
    proteinas: 20,
    carbohidratos: 38,
    grasas: 8,
    tags: ['Rápido', 'Probióticos'],
    ingredientes: [
      '200g yogur griego',
      '50g granola casera',
      '100g bayas mixtas',
      '10ml miel',
      'Canela',
    ],
    pasos: [
      'Vierte el yogur en un tazón',
      'Añade las bayas frescas',
      'Espolvorea la granola',
      'Drizzle de miel por encima',
      'Espolvorea canela al gusto',
    ],
  ),
  Receta(
    id: '8',
    titulo: 'Filete de Pescado Blanco',
    imagen: '🐠',
    calorias: 250,
    tiempoPreparacion: 20,
    categoria: 'Cena',
    proteinas: 38,
    carbohidratos: 8,
    grasas: 8,
    tags: ['Bajas en grasa', 'Alto en proteína'],
    ingredientes: [
      '200g merluza o bacalao',
      '200g verduras al vapor',
      '10ml aceite de oliva',
      'Limón y perejil',
      'Sal y pimienta',
    ],
    pasos: [
      'Cocina el pescado al vapor 12 minutos',
      'Vaporiza las verduras en paralelo',
      'Emplata el pescado y verduras',
      'Rocía con aceite y limón',
      'Decora con perejil fresco',
    ],
  ),
  Receta(
    id: '9',
    titulo: 'Pollo con Avena y Verduras Salteadas',
    imagen: '🍗🥣',
    calorias: 460,
    tiempoPreparacion: 25,
    categoria: 'Comida',
    proteinas: 42,
    carbohidratos: 40,
    grasas: 12,
    tags: ['Pollo', 'Avena', 'Equilibrado'],
    ingredientes: [
      '180g pechuga de pollo en tiras',
      '60g copos de avena',
      '150g pimiento y calabacín',
      '10ml aceite de oliva',
      'Ajo, sal y pimienta',
      'Perejil fresco',
    ],
    pasos: [
      'Sazona el pollo con ajo, sal y pimienta',
      'Saltea las verduras en aceite hasta tiernas',
      'Añade el pollo y cocina hasta dorar',
      'Agrega la avena y 50ml de agua, cocina 3-4 min',
      'Espolvorea perejil y sirve caliente',
    ],
  ),
  Receta(
    id: '10',
    titulo: 'Tostada de Avena Crocante con Pollo Desmenuzado',
    imagen: '🍞🥣',
    calorias: 330,
    tiempoPreparacion: 15,
    categoria: 'Desayuno',
    proteinas: 28,
    carbohidratos: 34,
    grasas: 9,
    tags: ['Pollo', 'Rápido', 'Avena'],
    ingredientes: [
      '2 rebanadas pan de avena o pan integral',
      '120g pollo cocido desmenuzado',
      '30g copos de avena tostada',
      '20g aguacate en lonchas',
      'Tomate y hojas verdes',
    ],
    pasos: [
      'Tuesta el pan y unta con aguacate',
      'Mezcla el pollo con tomate y hojas verdes',
      'Espolvorea la avena tostada sobre el pollo',
      'Coloca la mezcla sobre el pan y sirve',
      'Opcional: añade un chorrito de limón',
    ],
  ),
  Receta(
    id: '11',
    titulo: 'Guiso de Pollo con Avena y Calabaza',
    imagen: '🍲',
    calorias: 520,
    tiempoPreparacion: 40,
    categoria: 'Comida',
    proteinas: 48,
    carbohidratos: 50,
    grasas: 14,
    tags: ['Pollo', 'Avena', 'Volumen'],
    ingredientes: [
      '200g pollo troceado',
      '100g avena integral',
      '200g calabaza en cubos',
      '1 cebolla, 1 diente de ajo',
      '500ml caldo de pollo',
      'Aceite, sal y pimienta',
    ],
    pasos: [
      'Sofríe la cebolla y ajo en aceite hasta transparente',
      'Añade el pollo y dora por todos lados',
      'Incorpora la calabaza y cocina 5 minutos',
      'Añade el caldo y la avena, hierve a fuego lento 15-20 min',
      'Ajusta sal y sirve caliente',
    ],
  ),
  Receta(
    id: '12',
    titulo: 'Bowl Vegano Mediterráneo',
    imagen: '🥙',
    calorias: 420,
    tiempoPreparacion: 20,
    categoria: 'Comida',
    proteinas: 18,
    carbohidratos: 45,
    grasas: 18,
    tags: ['Vegano', 'Sin lactosa'],
    ingredientes: [
      '100g garbanzos cocidos',
      '80g quinoa cocida',
      '100g tomate y pepino',
      '30g hummus',
      '20ml aceite de oliva',
      'Limón y hierbas',
    ],
    pasos: [
      'Cocina la quinoa y deja enfriar',
      'Mezcla con garbanzos y verduras picadas',
      'Añade hummus, aceite y limón',
      'Sirve templado o frío',
    ],
  ),
  Receta(
    id: '13',
    titulo: 'Puré de Verduras y Pollo para Niños',
    imagen: '👶',
    calorias: 300,
    tiempoPreparacion: 25,
    categoria: 'Comida',
    proteinas: 22,
    carbohidratos: 30,
    grasas: 10,
    tags: ['Infantil', 'Suave'],
    ingredientes: [
      '150g pechuga de pollo',
      '150g calabaza',
      '100g patata',
      '50ml caldo bajo sal',
      '10ml aceite de oliva',
    ],
    pasos: [
      'Cocina pollo y verduras hasta ternura',
      'Tritura con caldo hasta obtener puré',
      'Añade un chorrito de aceite y sirve tibio',
    ],
  ),
  Receta(
    id: '14',
    titulo: 'Tazón Post-Entreno (Arroz + Huevos)',
    imagen: '🏋️',
    calorias: 560,
    tiempoPreparacion: 15,
    categoria: 'Comida',
    proteinas: 42,
    carbohidratos: 64,
    grasas: 12,
    tags: ['Post-entreno', 'Recuperación'],
    ingredientes: [
      '200g arroz integral cocido',
      '2 huevos enteros',
      '100g espinacas',
      '10ml aceite de oliva',
      'Salsa ligera al gusto',
    ],
    pasos: [
      'Cocina arroz y prepara huevos pochados o revueltos',
      'Saltea espinacas ligeramente',
      'Monta el bowl con arroz, huevos y espinacas',
    ],
  ),
  Receta(
    id: '15',
    titulo: 'Ensalada Keto de Aguacate y Atún',
    imagen: '🥑',
    calorias: 430,
    tiempoPreparacion: 10,
    categoria: 'Cena',
    proteinas: 32,
    carbohidratos: 6,
    grasas: 30,
    tags: ['Keto', 'Bajo en carbohidratos'],
    ingredientes: [
      '150g atún natural',
      '1 aguacate mediano',
      '50g hojas verdes',
      '15ml aceite de oliva',
      'Limón y sal',
    ],
    pasos: [
      'Mezcla atún con aguacate en cubos',
      'Añade hojas verdes y aliña con aceite y limón',
      'Sirve frío',
    ],
  ),
  Receta(
    id: '16',
    titulo: 'Snack Saludable: Barritas de Avena y Frutos Secos',
    imagen: '🍪',
    calorias: 210,
    tiempoPreparacion: 10,
    categoria: 'Snack',
    proteinas: 6,
    carbohidratos: 22,
    grasas: 10,
    tags: ['Snack', 'Energético'],
    ingredientes: [
      '60g copos de avena',
      '30g frutos secos picados',
      '15g miel',
      '10g mantequilla de cacahuete',
    ],
    pasos: [
      'Mezcla todos los ingredientes y compacta en molde',
      'Refrigera 30 minutos y corta en barritas',
    ],
  ),
  Receta(
    id: '17',
    titulo: 'Pasta Sin Gluten con Salsa de Tomate y Albahaca',
    imagen: '🍝',
    calorias: 500,
    tiempoPreparacion: 20,
    categoria: 'Comida',
    proteinas: 16,
    carbohidratos: 72,
    grasas: 12,
    tags: ['Sin gluten', 'Tradicional'],
    ingredientes: [
      '100g pasta sin gluten',
      '150g tomate triturado',
      '10g albahaca fresca',
      '10ml aceite de oliva',
      'Queso rallado opcional',
    ],
    pasos: [
      'Cocina la pasta según instrucciones',
      'Calienta la salsa de tomate con albahaca',
      'Mezcla y sirve con queso si se desea',
    ],
  ),
];

class RecetasScreen extends StatefulWidget {
  const RecetasScreen({super.key});

  @override
  State<RecetasScreen> createState() => _RecetasScreenState();
}

class _RecetasScreenState extends State<RecetasScreen> {
  String filtroActual = 'Todos';
  final List<String> categorias = ['Todos', 'Desayuno', 'Comida', 'Cena', 'Bajas en grasa'];

  List<Receta> obtenerRecetasFiltradas() {
    if (filtroActual == 'Todos') {
      return recetasDatabase;
    } else if (filtroActual == 'Bajas en grasa') {
      return recetasDatabase.where((r) => r.tags.contains('Bajas en grasa')).toList();
    } else {
      return recetasDatabase.where((r) => r.categoria == filtroActual).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final recetasFiltradas = obtenerRecetasFiltradas();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Recetas de NutriVision',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.tealAccent.withOpacity(0.9),
        elevation: 4,
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.tealAccent.withOpacity(0.1),
              border: Border(bottom: BorderSide(color: Colors.tealAccent, width: 1)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: categorias.map((categoria) {
                  final isSelected = filtroActual == categoria;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: FilterChip(
                      label: Text(
                        categoria,
                        style: TextStyle(
                          color: isSelected ? Colors.black : Colors.tealAccent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      backgroundColor: isSelected ? Colors.tealAccent : Colors.transparent,
                      side: BorderSide(
                        color: Colors.tealAccent,
                        width: isSelected ? 0 : 1.5,
                      ),
                      onSelected: (selected) {
                        setState(() => filtroActual = categoria);
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Expanded(
            child: recetasFiltradas.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.restaurant, size: 80, color: Colors.tealAccent),
                        const SizedBox(height: 16),
                        const Text(
                          'No hay recetas en esta categoría',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: recetasFiltradas.length,
                    itemBuilder: (context, index) {
                      final receta = recetasFiltradas[index];
                      return _tarjetaReceta(context, receta);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _tarjetaReceta(BuildContext context, Receta receta) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecetaDetailScreen(receta: receta),
          ),
        );
      },
      child: Card(
        color: const Color(0xFF051B18),
        margin: const EdgeInsets.symmetric(vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: Colors.tealAccent, width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.tealAccent.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.tealAccent, width: 1),
                ),
                child: Center(
                  child: Text(
                    receta.imagen,
                    style: const TextStyle(fontSize: 50),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      receta.titulo,
                      style: const TextStyle(
                        color: Colors.tealAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.local_fire_department,
                            color: Colors.orangeAccent, size: 18),
                        const SizedBox(width: 4),
                        Text(
                          '${receta.calorias} kcal',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Icon(Icons.schedule,
                            color: Colors.lightBlueAccent, size: 18),
                        const SizedBox(width: 4),
                        Text(
                          '${receta.tiempoPreparacion} min',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      children: receta.tags.take(2).map((tag) {
                        return Chip(
                          label: Text(
                            tag,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          backgroundColor: Colors.tealAccent,
                          padding: EdgeInsets.zero,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.tealAccent, size: 28),
            ],
          ),
        ),
      ),
    );
  }
}

class RecetaDetailScreen extends StatefulWidget {
  final Receta receta;

  const RecetaDetailScreen({required this.receta, super.key});

  @override
  State<RecetaDetailScreen> createState() => _RecetaDetailScreenState();
}

class _RecetaDetailScreenState extends State<RecetaDetailScreen> {
  late double gramosSeleccionados;
  late double baseGramos;

  @override
  void initState() {
    super.initState();
    baseGramos = _calcularGramosBase();
    gramosSeleccionados = baseGramos;
  }

  double _calcularGramosBase() {
    final gramRegex = RegExp(r'(\d+(?:[.,]\d+)?)\s*(g|gr|grs|ml)\b', caseSensitive: false);
    double sum = 0.0;
    for (final ing in widget.receta.ingredientes) {
      for (final m in gramRegex.allMatches(ing)) {
        final raw = m.group(1)!.replaceAll(',', '.');
        final value = double.tryParse(raw) ?? 0.0;
        sum += value;
      }
    }
    if (sum <= 0) return widget.receta.porcionGramos.toDouble();
    return sum;
  }

  @override
  Widget build(BuildContext context) {
    final double minSlider = 10.0;
    final double computedMax = baseGramos * 3.0;
    final double sliderMax = computedMax > 800.0 ? computedMax : 800.0;

    // valor seguro (clamped) usado para el Slider y el cálculo de nutrientes
    final double selected = gramosSeleccionados.clamp(minSlider, sliderMax).toDouble();
    final double factor = selected / (baseGramos > 0 ? baseGramos : widget.receta.porcionGramos);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.receta.titulo,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.tealAccent.withOpacity(0.9),
        elevation: 4,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.tealAccent.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.tealAccent, width: 2),
              ),
              child: Center(
                child: Text(
                  widget.receta.imagen,
                  style: const TextStyle(fontSize: 100),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF051B18),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.tealAccent, width: 1),
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Cantidad total del plato (g)',
                        style: TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${selected.round()} g',
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                  Slider(
                    value: selected,
                    min: minSlider,
                    max: sliderMax,
                    // divisions opcional: null para desactivar
                    label: '${selected.round()} g',
                    onChanged: (v) => setState(() => gramosSeleccionados = v),
                  ),
                  Text(
                    'Base calculada (suma de ingredientes): ${baseGramos.round()} g — los valores nutricionales e ingredientes se escalan para representar la cantidad TOTAL seleccionada.',
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF051B18),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.tealAccent, width: 1),
              ),
              padding: const EdgeInsets.all(14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _infoBox('🔥', '${(widget.receta.calorias * factor).round()}', 'kcal'),
                  _infoBox('🥚', '${(widget.receta.proteinas * factor).round()}g', 'Proteína'),
                  _infoBox('🍞', '${(widget.receta.carbohidratos * factor).round()}g', 'Carbs'),
                  _infoBox('🥑', '${(widget.receta.grasas * factor).round()}g', 'Grasas'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF051B18),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.tealAccent, width: 1),
              ),
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  const Icon(Icons.schedule, color: Colors.lightBlueAccent, size: 24),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Tiempo de Preparación',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                      Text(
                        '${widget.receta.tiempoPreparacion} minutos',
                        style: const TextStyle(
                          color: Colors.tealAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _seccion('📝 Ingredientes', widget.receta.ingredientes,
                factor: factor, scaleIngredientes: true),
            const SizedBox(height: 24),
            _seccion('👨‍🍳 Pasos de Preparación', widget.receta.pasos),
            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                color: Colors.tealAccent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.tealAccent, width: 1),
              ),
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '🏷️ Tags',
                    style: TextStyle(
                      color: Colors.tealAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: widget.receta.tags.map((tag) {
                      return Chip(
                        label: Text(
                          tag,
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        backgroundColor: Colors.tealAccent,
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _infoBox(String emoji, String valor, String label) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 28)),
        const SizedBox(height: 6),
        Text(
          valor,
          style: const TextStyle(
            color: Colors.tealAccent,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _seccion(String titulo, List<String> items, {double factor = 1.0, bool scaleIngredientes = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titulo,
          style: const TextStyle(
            color: Colors.tealAccent,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF051B18),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.tealAccent, width: 1),
          ),
          child: Column(
            children: items.asMap().entries.map((entry) {
              final index = entry.key + 1;
              String item = entry.value;
              if (scaleIngredientes) {
                final gramRegex =
                    RegExp(r'(\d+(?:[.,]\d+)?)\s*(g|gr|grs|ml)\b', caseSensitive: false);
                item = item.replaceAllMapped(gramRegex, (m) {
                  final raw = m.group(1)!.replaceAll(',', '.');
                  final value = double.tryParse(raw) ?? 0.0;
                  final scaled = (value * factor);
                  final unidad = m.group(2) ?? 'g';
                  final scaledStr =
                      (scaled % 1 == 0) ? scaled.toInt().toString() : scaled.toStringAsFixed(1);
                  return '$scaledStr $unidad';
                });
              }
              return Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.tealAccent,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Center(
                        child: Text(
                          '$index',
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        item,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
