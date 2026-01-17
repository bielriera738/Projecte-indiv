import 'package:flutter/material.dart';

// ============================================================================
// CONSTANTES GLOBALES DE COLORES Y ESTILOS
// ============================================================================
const Color colorPrimarioTitulo =
    Colors.teal; // Mantener verde para el título "NutriVision AI"
const Color colorFondo = Colors.white; // Fondo blanco
const Color colorTexto = Colors.black87; // Texto negro/oscuro
const Color colorTextoSecundario = Colors.black54; // Texto secundario
const Color colorBorde = Colors.black26; // Bordes sutiles
const Color colorCardFondo = Colors.white; // Fondo blanco para tarjetas
const Color colorChipSeleccionado = Colors.black87; // Chip seleccionado
const Color colorChipNoSeleccionado = Colors.white; // Chip no seleccionado

// Estilos reutilizables
const TextStyle tituloAppBar = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,
  color: colorPrimarioTitulo,
);

const TextStyle tituloSeccion = TextStyle(
  color: colorTexto,
  fontWeight: FontWeight.bold,
  fontSize: 16,
);

const TextStyle textoNormal = TextStyle(color: colorTexto, fontSize: 14);

const TextStyle textoSecundario = TextStyle(
  color: colorTextoSecundario,
  fontSize: 13,
);

// ============================================================================

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

  factory Receta.fromJson(Map<String, dynamic> json) {
    return Receta(
      id: (json['id'] ?? '').toString(),
      titulo: (json['titulo'] ?? '').toString(),
      imagen: (json['imagen'] ?? '').toString(),
      calorias: json['calorias'] is int
          ? json['calorias'] as int
          : int.tryParse(json['calorias']?.toString() ?? '') ?? 0,
      tiempoPreparacion: json['tiempoPreparacion'] is int
          ? json['tiempoPreparacion'] as int
          : int.tryParse(json['tiempoPreparacion']?.toString() ?? '') ?? 0,
      categoria: (json['categoria'] ?? '').toString(),
      ingredientes:
          (json['ingredientes'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      pasos:
          (json['pasos'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      proteinas: json['proteinas'] is int
          ? json['proteinas'] as int
          : int.tryParse(json['proteinas']?.toString() ?? '') ?? 0,
      carbohidratos: json['carbohidratos'] is int
          ? json['carbohidratos'] as int
          : int.tryParse(json['carbohidratos']?.toString() ?? '') ?? 0,
      grasas: json['grasas'] is int
          ? json['grasas'] as int
          : int.tryParse(json['grasas']?.toString() ?? '') ?? 0,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ??
          [],
      porcionGramos: json['porcionGramos'] is int
          ? json['porcionGramos'] as int
          : int.tryParse(json['porcionGramos']?.toString() ?? '') ?? 100,
    );
  }
}

final List<Receta> recetasDatabase = [
  // Base de datos de recetas
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
    tags: ['Bajo en grasa', 'Ligero'],
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
    tags: ['Bajo en grasa', 'Alto en proteína'],
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

  // ======================= DESAYUNO (más combinaciones) =======================
  Receta(
    id: '18',
    titulo: 'Huevos Revueltos con Aguacate (Keto)',
    imagen: '🍳🥑',
    calorias: 520,
    tiempoPreparacion: 10,
    categoria: 'Desayuno',
    proteinas: 27,
    carbohidratos: 7,
    grasas: 41,
    tags: ['Keto', 'Bajo en carbohidratos', 'Alto en grasa saludable'],
    ingredientes: [
      '3 huevos',
      '100g aguacate',
      '10ml aceite de oliva',
      'Sal y pimienta',
      'Opcional: 30g queso rallado',
    ],
    pasos: [
      'Bate los huevos con sal y pimienta',
      'Cocina los huevos a fuego medio con aceite',
      'Añade el aguacate en cubos al final',
      'Opcional: agrega queso y deja fundir',
    ],
  ),
  Receta(
    id: '19',
    titulo: 'Overnight Oats Proteicas (Definición)',
    imagen: '🥣',
    calorias: 390,
    tiempoPreparacion: 5,
    categoria: 'Desayuno',
    proteinas: 32,
    carbohidratos: 46,
    grasas: 8,
    tags: ['Definición', 'Alto en proteína', 'Rápido', 'Alto en fibra'],
    ingredientes: [
      '60g avena',
      '200g yogur griego 0%',
      '100ml leche desnatada',
      '80g fresas',
      '5g semillas de chía',
    ],
    pasos: [
      'Mezcla avena, yogur, leche y chía',
      'Añade las fresas troceadas',
      'Refrigera 6-8 horas',
      'Sirve frío',
    ],
  ),
  Receta(
    id: '20',
    titulo: 'Tostada Integral con Pavo y Tomate (Ligero)',
    imagen: '🍞🍅',
    calorias: 320,
    tiempoPreparacion: 8,
    categoria: 'Desayuno',
    proteinas: 26,
    carbohidratos: 36,
    grasas: 7,
    tags: ['Definición', 'Bajo en grasa', 'Rápido'],
    ingredientes: [
      '2 rebanadas pan integral (70g)',
      '90g pechuga de pavo',
      '100g tomate',
      '5ml aceite de oliva',
      'Orégano y sal',
    ],
    pasos: [
      'Tuesta el pan',
      'Ralla el tomate y aliña con aceite y sal',
      'Añade el pavo encima y espolvorea orégano',
    ],
  ),
  Receta(
    id: '21',
    titulo: 'Smoothie Alto en Calorías (Volumen)',
    imagen: '🥤🥜',
    calorias: 720,
    tiempoPreparacion: 5,
    categoria: 'Desayuno',
    proteinas: 38,
    carbohidratos: 78,
    grasas: 28,
    tags: ['Volumen', 'Alto en calorías', 'Rápido', 'Post-entreno'],
    ingredientes: [
      '300ml leche',
      '1 plátano (120g)',
      '60g avena',
      '30g mantequilla de cacahuete',
      '1 scoop proteína',
    ],
    pasos: [
      'Añade todo a la batidora',
      'Tritura 30-45 segundos',
      'Sirve inmediatamente',
    ],
  ),

  // ======================= COMIDA (más combinaciones) =======================
  Receta(
    id: '22',
    titulo: 'Bowl de Arroz + Atún (Post-entreno)',
    imagen: '🍚🐟',
    calorias: 610,
    tiempoPreparacion: 15,
    categoria: 'Comida',
    proteinas: 44,
    carbohidratos: 78,
    grasas: 12,
    tags: ['Post-entreno', 'Recuperación', 'Equilibrado'],
    ingredientes: [
      '250g arroz cocido',
      '150g atún al natural escurrido',
      '100g maíz',
      '80g tomate',
      '10ml aceite de oliva',
    ],
    pasos: [
      'Mezcla arroz, atún y verduras',
      'Aliña con aceite y sal',
      'Sirve templado o frío',
    ],
  ),
  Receta(
    id: '23',
    titulo: 'Poke de Salmón (Equilibrado)',
    imagen: '🍣',
    calorias: 560,
    tiempoPreparacion: 20,
    categoria: 'Comida',
    proteinas: 36,
    carbohidratos: 62,
    grasas: 18,
    tags: ['Equilibrado', 'Omega-3'],
    ingredientes: [
      '220g arroz cocido',
      '140g salmón',
      '100g pepino',
      '80g zanahoria',
      '10ml salsa de soja',
      '10ml aceite de oliva',
    ],
    pasos: [
      'Corta el salmón en cubos',
      'Monta el bowl con arroz y verduras',
      'Añade soja y un toque de aceite',
    ],
  ),
  Receta(
    id: '24',
    titulo: 'Lentejas con Verduras y Huevo (Alto en fibra)',
    imagen: '🍲🥚',
    calorias: 540,
    tiempoPreparacion: 35,
    categoria: 'Comida',
    proteinas: 30,
    carbohidratos: 64,
    grasas: 16,
    tags: ['Mantenimiento', 'Alto en fibra', 'Tradicional'],
    ingredientes: [
      '220g lentejas cocidas',
      '150g zanahoria y cebolla',
      '150g tomate triturado',
      '1 huevo',
      '10ml aceite de oliva',
    ],
    pasos: [
      'Sofríe verduras con aceite',
      'Añade tomate y lentejas y cocina 10-15 min',
      'Cocina el huevo aparte y sirve encima',
    ],
  ),
  Receta(
    id: '25',
    titulo: 'Burrito Bowl de Ternera (Volumen)',
    imagen: '🌯',
    calorias: 760,
    tiempoPreparacion: 25,
    categoria: 'Comida',
    proteinas: 46,
    carbohidratos: 85,
    grasas: 26,
    tags: ['Volumen', 'Alto en calorías', 'Equilibrado'],
    ingredientes: [
      '250g arroz cocido',
      '180g ternera picada',
      '120g frijoles cocidos',
      '80g aguacate',
      '60g tomate',
    ],
    pasos: [
      'Cocina la ternera con especias',
      'Monta el bowl con arroz y frijoles',
      'Añade aguacate y tomate al final',
    ],
  ),
  Receta(
    id: '26',
    titulo: 'Pasta Integral con Pollo (Volumen limpio)',
    imagen: '🍝🍗',
    calorias: 690,
    tiempoPreparacion: 25,
    categoria: 'Comida',
    proteinas: 48,
    carbohidratos: 86,
    grasas: 14,
    tags: ['Volumen', 'Alto en proteína'],
    ingredientes: [
      '90g pasta integral (en seco)',
      '180g pechuga de pollo',
      '150g tomate triturado',
      '10ml aceite de oliva',
      'Ajo y albahaca',
    ],
    pasos: [
      'Cuece la pasta',
      'Cocina el pollo en tiras',
      'Mezcla con la salsa y sirve',
    ],
  ),
  Receta(
    id: '27',
    titulo: 'Ensalada de Garbanzos (Vegano)',
    imagen: '🥗🫘',
    calorias: 520,
    tiempoPreparacion: 12,
    categoria: 'Comida',
    proteinas: 20,
    carbohidratos: 62,
    grasas: 18,
    tags: ['Vegano', 'Sin lactosa', 'Alto en fibra'],
    ingredientes: [
      '240g garbanzos cocidos',
      '120g pepino y tomate',
      '30g aceitunas',
      '15ml aceite de oliva',
      'Limón y comino',
    ],
    pasos: [
      'Mezcla los garbanzos con verduras',
      'Añade aceitunas y aliña',
      'Deja reposar 5 min y sirve',
    ],
  ),

  // ======================= CENA (más combinaciones) =======================
  Receta(
    id: '28',
    titulo: 'Salteado de Pavo con Verduras (Definición)',
    imagen: '🥘',
    calorias: 430,
    tiempoPreparacion: 18,
    categoria: 'Cena',
    proteinas: 45,
    carbohidratos: 22,
    grasas: 16,
    tags: ['Definición', 'Alto en proteína', 'Bajo en carbohidratos'],
    ingredientes: [
      '200g pechuga de pavo',
      '250g verduras salteadas (brócoli, pimiento)',
      '10ml aceite de oliva',
      'Salsa de soja ligera',
    ],
    pasos: [
      'Corta el pavo en tiras',
      'Saltea verduras con aceite',
      'Añade pavo y cocina 6-8 min',
      'Agrega un toque de soja y sirve',
    ],
  ),
  Receta(
    id: '29',
    titulo: 'Tortilla de Verduras + Queso (Mantenimiento)',
    imagen: '🥚🥬',
    calorias: 520,
    tiempoPreparacion: 15,
    categoria: 'Cena',
    proteinas: 34,
    carbohidratos: 18,
    grasas: 34,
    tags: ['Mantenimiento', 'Equilibrado', 'Sin gluten'],
    ingredientes: [
      '3 huevos',
      '200g espinacas y champiñones',
      '40g queso',
      '10ml aceite de oliva',
    ],
    pasos: [
      'Saltea verduras 3-4 min',
      'Añade huevos batidos',
      'Agrega el queso y cuaja por ambos lados',
    ],
  ),
  Receta(
    id: '30',
    titulo: 'Bacalao con Puré de Coliflor (Keto)',
    imagen: '🐟🥦',
    calorias: 470,
    tiempoPreparacion: 25,
    categoria: 'Cena',
    proteinas: 42,
    carbohidratos: 14,
    grasas: 26,
    tags: ['Keto', 'Bajo en carbohidratos', 'Alto en proteína'],
    ingredientes: [
      '220g bacalao',
      '300g coliflor',
      '15ml aceite de oliva',
      'Ajo y perejil',
      'Sal',
    ],
    pasos: [
      'Cuece la coliflor y tritura con sal y aceite',
      'Cocina el bacalao a la plancha',
      'Sirve el pescado sobre el puré',
    ],
  ),
  Receta(
    id: '31',
    titulo: 'Ensalada César Fit (Definición)',
    imagen: '🥗🍗',
    calorias: 410,
    tiempoPreparacion: 15,
    categoria: 'Cena',
    proteinas: 42,
    carbohidratos: 18,
    grasas: 18,
    tags: ['Definición', 'Alto en proteína', 'Bajo en carbohidratos'],
    ingredientes: [
      '180g pollo a la plancha',
      '200g lechuga romana',
      '20g parmesano',
      '15g yogur + limón (salsa)',
      '10g picatostes opcional',
    ],
    pasos: [
      'Corta lechuga y pollo',
      'Mezcla la salsa de yogur con limón',
      'Añade parmesano y mezcla',
    ],
  ),

  // ======================= SNACK (más combinaciones) =======================
  Receta(
    id: '32',
    titulo: 'Skyr/Yogur Proteico con Fruta (Definición)',
    imagen: '🥛🍓',
    calorias: 230,
    tiempoPreparacion: 3,
    categoria: 'Snack',
    proteinas: 25,
    carbohidratos: 22,
    grasas: 2,
    tags: ['Definición', 'Alto en proteína', 'Rápido'],
    ingredientes: [
      '200g skyr o yogur alto en proteína',
      '120g fruta (fresas o manzana)',
      'Canela',
    ],
    pasos: [
      'Sirve el yogur en un bol',
      'Añade la fruta troceada',
      'Espolvorea canela',
    ],
  ),
  Receta(
    id: '33',
    titulo: 'Rollitos de Pavo y Queso (Keto)',
    imagen: '🧀🥓',
    calorias: 310,
    tiempoPreparacion: 5,
    categoria: 'Snack',
    proteinas: 28,
    carbohidratos: 3,
    grasas: 20,
    tags: ['Keto', 'Bajo en carbohidratos', 'Rápido', 'Alto en proteína'],
    ingredientes: [
      '120g pechuga de pavo loncheada',
      '50g queso',
      'Mostaza opcional',
    ],
    pasos: ['Coloca el queso sobre el pavo', 'Enrolla y sirve'],
  ),
  Receta(
    id: '34',
    titulo: 'Tostada de Arroz con Crema de Cacahuete (Volumen)',
    imagen: '🥜🍘',
    calorias: 420,
    tiempoPreparacion: 3,
    categoria: 'Snack',
    proteinas: 14,
    carbohidratos: 34,
    grasas: 26,
    tags: ['Volumen', 'Alto en calorías', 'Rápido'],
    ingredientes: [
      '3 tortitas de arroz',
      '30g crema de cacahuete',
      '15g miel opcional',
    ],
    pasos: [
      'Unta la crema de cacahuete en las tortitas',
      'Opcional: añade miel',
      'Listo para comer',
    ],
  ),
  Receta(
    id: '35',
    titulo: 'Hummus con Palitos de Verduras (Vegano)',
    imagen: '🥕🧆',
    calorias: 260,
    tiempoPreparacion: 8,
    categoria: 'Snack',
    proteinas: 9,
    carbohidratos: 22,
    grasas: 14,
    tags: ['Vegano', 'Sin lactosa', 'Alto en fibra'],
    ingredientes: ['80g hummus', '200g zanahoria y pepino', 'Pimentón'],
    pasos: ['Corta las verduras en bastones', 'Sirve con hummus y pimentón'],
  ),
  Receta(
    id: '36',
    titulo: 'Tortitas de Avena y Plátano (Mantenimiento)',
    imagen: '🥞',
    calorias: 470,
    tiempoPreparacion: 15,
    categoria: 'Desayuno',
    proteinas: 22,
    carbohidratos: 62,
    grasas: 14,
    tags: ['Mantenimiento', 'Alto en fibra'],
    ingredientes: [
      '2 huevos',
      '70g avena',
      '1 plátano (120g)',
      '5ml aceite para la sartén',
    ],
    pasos: [
      'Tritura huevo, avena y plátano',
      'Cocina pequeñas tortitas 2-3 min por lado',
      'Sirve caliente',
    ],
  ),
  Receta(
    id: '37',
    titulo: 'Wrap de Pollo y Verduras (Rápido)',
    imagen: '🌯🍗',
    calorias: 540,
    tiempoPreparacion: 12,
    categoria: 'Comida',
    proteinas: 42,
    carbohidratos: 56,
    grasas: 16,
    tags: ['Rápido', 'Equilibrado', 'Alto en proteína'],
    ingredientes: [
      '1 tortilla grande (70g)',
      '160g pollo cocido',
      '120g lechuga y tomate',
      '30g yogur o salsa ligera',
    ],
    pasos: [
      'Rellena la tortilla con pollo y verduras',
      'Añade la salsa',
      'Enrolla y sirve',
    ],
  ),
  Receta(
    id: '38',
    titulo: 'Crema de Calabacín + Tortilla Francesa (Definición)',
    imagen: '🥣🍳',
    calorias: 390,
    tiempoPreparacion: 25,
    categoria: 'Cena',
    proteinas: 28,
    carbohidratos: 20,
    grasas: 18,
    tags: ['Definición', 'Bajo en calorías', 'Sin gluten'],
    ingredientes: [
      '400g calabacín',
      '100g cebolla',
      '10ml aceite de oliva',
      '2 huevos',
      'Sal',
    ],
    pasos: [
      'Cuece calabacín y cebolla y tritura con sal',
      'Prepara una tortilla francesa con 2 huevos',
      'Sirve la crema con la tortilla',
    ],
  ),
  Receta(
    id: '39',
    titulo: 'Pudding de Chía (Keto light)',
    imagen: '🍮',
    calorias: 310,
    tiempoPreparacion: 5,
    categoria: 'Snack',
    proteinas: 12,
    carbohidratos: 10,
    grasas: 22,
    tags: ['Bajo en carbohidratos', 'Rápido', 'Alto en fibra'],
    ingredientes: [
      '250ml leche (o bebida vegetal)',
      '25g semillas de chía',
      '10g cacao puro',
      'Edulcorante opcional',
    ],
    pasos: ['Mezcla todo en un vaso', 'Refrigera 2-3 horas', 'Remueve y sirve'],
  ),
  Receta(
    id: '40',
    titulo: 'Sopa Miso con Tofu (Vegano)',
    imagen: '🍜',
    calorias: 260,
    tiempoPreparacion: 15,
    categoria: 'Cena',
    proteinas: 18,
    carbohidratos: 18,
    grasas: 10,
    tags: ['Vegano', 'Sin lactosa', 'Ligero'],
    ingredientes: [
      '400ml agua',
      '20g pasta miso',
      '150g tofu',
      '100g setas',
      'Cebolleta',
    ],
    pasos: [
      'Calienta el agua y disuelve el miso (sin hervir fuerte)',
      'Añade tofu y setas 5-7 min',
      'Sirve con cebolleta',
    ],
  ),
  Receta(
    id: '41',
    titulo: 'Patata Asada + Atún (Mantenimiento)',
    imagen: '🥔🐟',
    calorias: 520,
    tiempoPreparacion: 35,
    categoria: 'Cena',
    proteinas: 38,
    carbohidratos: 52,
    grasas: 14,
    tags: ['Mantenimiento', 'Equilibrado', 'Sin gluten'],
    ingredientes: [
      '300g patata',
      '150g atún al natural',
      '80g yogur',
      '10ml aceite de oliva',
      'Sal',
    ],
    pasos: [
      'Asa la patata (microondas u horno)',
      'Mezcla el atún con yogur y sal',
      'Rellena la patata y añade aceite',
    ],
  ),
  Receta(
    id: '42',
    titulo: 'Bol de Fruta + Nueces (Snack saludable)',
    imagen: '🍎🌰',
    calorias: 330,
    tiempoPreparacion: 3,
    categoria: 'Snack',
    proteinas: 6,
    carbohidratos: 32,
    grasas: 20,
    tags: ['Mantenimiento', 'Rápido', 'Grasas saludables'],
    ingredientes: ['200g fruta variada', '25g nueces', 'Canela opcional'],
    pasos: ['Corta la fruta', 'Añade las nueces por encima', 'Listo'],
  ),
];

class RecetasScreen extends StatefulWidget {
  const RecetasScreen({super.key});

  @override
  State<RecetasScreen> createState() => _RecetasScreenState();
}

class _RecetasScreenState extends State<RecetasScreen> {
  // filtros y paginación
  Set<String> selectedCategories = {};
  Set<String> selectedTags = {};
  bool _showRecommended = false; // Nuevo estado para recomendaciones
  int currentPage = 1;
  int pageSize = 6;

  List<String> getAllCategories() {
    final set = <String>{};
    for (var r in recetasDatabase) {
      set.add(r.categoria);
    }
    return ['Todos', ...set];
  }

  List<String> getAllTags() {
    final set = <String>{};
    for (var r in recetasDatabase) {
      set.addAll(r.tags);
    }
    return set.toList();
  }

  List<Receta> applyFilters() {
    // Si no hay filtros seleccionados ni recomendación activada, no mostrar nada
    if (selectedCategories.isEmpty && selectedTags.isEmpty && !_showRecommended) {
      return [];
    }

    var list = recetasDatabase.toList();

    // Si se activan recomendaciones, filtramos primero por criterios "seguros"
    if (_showRecommended) {
      list = list.where((r) =>
        r.tags.contains('Equilibrado') || 
        r.tags.contains('Mantenimiento') ||
        r.tags.contains('Saludable')
      ).toList();
    }

    if (selectedCategories.isNotEmpty) {
      list = list
          .where((r) => selectedCategories.contains(r.categoria))
          .toList();
    }

    if (selectedTags.isNotEmpty) {
      list = list
          .where((r) => r.tags.any((t) => selectedTags.contains(t)))
          .toList();
    }

    return list;
  }

  List<Receta> paginated(List<Receta> items) {
    final start = (currentPage - 1) * pageSize;
    if (start >= items.length) return [];
    final end = (start + pageSize) < items.length
        ? (start + pageSize)
        : items.length;
    return items.sublist(start, end);
  }

  @override
  Widget build(BuildContext context) {
    final filtered = applyFilters();
    final totalPages = (filtered.length / pageSize).ceil().clamp(1, 9999);
    final pageItems = paginated(filtered);

    final categories = getAllCategories();
    final tags = getAllTags();
    final tagOptions = ['Todos', ...tags];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recetas de NutriVision', style: tituloAppBar),
        centerTitle: true,
        backgroundColor: colorFondo,
        elevation: 2,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                // Cajita blanca de filtros combinables
                Card(
                  color: colorCardFondo,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: colorBorde, width: 1),
                  ),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Filtrar recetas', style: tituloSeccion),
                        const SizedBox(height: 10),
                        DropdownButtonFormField<String>(
                          initialValue: selectedCategories.isEmpty
                              ? 'Todos'
                              : selectedCategories.first,
                          decoration: const InputDecoration(
                            labelText: 'Categoría (ej. Desayuno, Cena...)',
                            border: OutlineInputBorder(),
                          ),
                          items: categories
                              .map(
                                (c) =>
                                    DropdownMenuItem(value: c, child: Text(c)),
                              )
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedCategories.clear();
                              if (value != null && value != 'Todos') {
                                selectedCategories.add(value);
                              }
                              currentPage = 1;
                            });
                          },
                        ),
                        const SizedBox(height: 10),
                        DropdownButtonFormField<String>(
                          initialValue: selectedTags.isEmpty
                              ? 'Todos'
                              : selectedTags.first,
                          decoration: const InputDecoration(
                            labelText:
                                'Objetivo / Tag (ej. Definición, Volumen...)',
                            border: OutlineInputBorder(),
                          ),
                          items: tagOptions
                              .map(
                                (t) =>
                                    DropdownMenuItem(value: t, child: Text(t)),
                              )
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedTags.clear();
                              if (value != null && value != 'Todos') {
                                selectedTags.add(value);
                              }
                              currentPage = 1;
                            });
                          },
                        ),
                        const SizedBox(height: 10),
                        SwitchListTile(
                          title: const Text('Ver platos recomendados', style: textoNormal),
                          subtitle: const Text('Muestra opciones equilibradas y seguras', style: textoSecundario),
                          value: _showRecommended,
                          activeColor: colorPrimarioTitulo,
                          contentPadding: EdgeInsets.zero,
                          onChanged: (bool value) {
                            setState(() {
                              _showRecommended = value;
                              currentPage = 1;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // listado (paginado)
                Expanded(
                  child: pageItems.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.search, // Icono cambiado a lupa para sugerir búsqueda
                                size: 72,
                                color: colorTexto,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                (selectedCategories.isEmpty && selectedTags.isEmpty && !_showRecommended)
                                  ? 'Utiliza los filtros o activa recomendados para ver recetas'
                                  : 'No hay recetas con esos filtros',
                                style: textoNormal,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.only(top: 12, bottom: 12),
                          itemCount: pageItems.length,
                          itemBuilder: (context, index) {
                            final receta = pageItems[index];
                            return _tarjetaReceta(context, receta);
                          },
                        ),
                ),

                // paginación
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chevron_left, color: colorTexto),
                        onPressed: currentPage > 1
                            ? () => setState(() => currentPage--)
                            : null,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Página $currentPage de $totalPages',
                        style: textoSecundario,
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(
                          Icons.chevron_right,
                          color: colorTexto,
                        ),
                        onPressed: currentPage < totalPages
                            ? () => setState(() => currentPage++)
                            : null,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _tarjetaReceta(BuildContext context, Receta receta) {
    final width = MediaQuery.of(context).size.width;
    final imgSize = (width * 0.18).clamp(64.0, 140.0);
    final imgFont = (imgSize * 0.6).clamp(28.0, 80.0);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => RecetaDetailScreen(receta: receta)),
        );
      },
      child: Card(
        color: colorCardFondo,
        margin: const EdgeInsets.symmetric(vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: colorBorde, width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: imgSize,
                height: imgSize,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: colorBorde, width: 1),
                ),
                child: Center(
                  child: Text(
                    receta.imagen,
                    style: TextStyle(fontSize: imgFont),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(receta.titulo, style: tituloSeccion),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.local_fire_department,
                          color: Colors.orangeAccent,
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        Text('${receta.calorias} kcal', style: textoNormal),
                        const SizedBox(width: 12),
                        const Icon(
                          Icons.schedule,
                          color: Colors.blueGrey,
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${receta.tiempoPreparacion} min',
                          style: textoNormal,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      children: receta.tags
                          .take(3)
                          .map(
                            (tag) => Chip(
                              label: Text(
                                tag,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              backgroundColor: colorTexto,
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: colorTexto, size: 28),
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
    final gramRegex = RegExp(
      r'(\d+(?:[.,]\d+)?)\s*(g|gr|grs|ml)\b',
      caseSensitive: false,
    );
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
    final double selected = gramosSeleccionados
        .clamp(minSlider, sliderMax)
        .toDouble();
    final double factor =
        selected / (baseGramos > 0 ? baseGramos : widget.receta.porcionGramos);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.receta.titulo,
          style: const TextStyle(
            color: colorPrimarioTitulo,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: colorFondo,
        elevation: 2,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: colorTexto),
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
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colorBorde, width: 2),
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
                color: colorCardFondo,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colorBorde, width: 1),
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
                        style: tituloSeccion,
                      ),
                      Text('${selected.round()} g', style: textoSecundario),
                    ],
                  ),
                  Slider(
                    value: selected,
                    min: minSlider,
                    max: sliderMax,
                    label: '${selected.round()} g',
                    onChanged: (v) => setState(() => gramosSeleccionados = v),
                  ),
                  Text(
                    'Base calculada (suma de ingredientes): ${baseGramos.round()} g — los valores nutricionales e ingredientes se escalan para representar la cantidad TOTAL seleccionada.',
                    style: const TextStyle(color: Colors.black38, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: colorCardFondo,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colorBorde, width: 1),
              ),
              padding: const EdgeInsets.all(14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _infoBox(
                    '🔥',
                    '${(widget.receta.calorias * factor).round()}',
                    'kcal',
                  ),
                  _infoBox(
                    '🥚',
                    '${(widget.receta.proteinas * factor).round()}g',
                    'Proteína',
                  ),
                  _infoBox(
                    '🍞',
                    '${(widget.receta.carbohidratos * factor).round()}g',
                    'Carbs',
                  ),
                  _infoBox(
                    '🥑',
                    '${(widget.receta.grasas * factor).round()}g',
                    'Grasas',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: colorCardFondo,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colorBorde, width: 1),
              ),
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  const Icon(Icons.schedule, color: Colors.blueGrey, size: 24),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Tiempo de Preparación',
                        style: textoSecundario,
                      ),
                      Text(
                        '${widget.receta.tiempoPreparacion} minutos',
                        style: tituloSeccion,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _seccion(
              '📝 Ingredientes',
              widget.receta.ingredientes,
              factor: factor,
              scaleIngredientes: true,
            ),
            const SizedBox(height: 24),
            _seccion('👨‍🍳 Pasos de Preparación', widget.receta.pasos),
            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colorBorde, width: 1),
              ),
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('🏷️ Tags', style: tituloSeccion),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: widget.receta.tags.map((tag) {
                      return Chip(
                        label: Text(
                          tag,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        backgroundColor: colorTexto,
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
            color: colorTexto,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: textoSecundario),
      ],
    );
  }

  Widget _seccion(
    String titulo,
    List<String> items, {
    double factor = 1.0,
    bool scaleIngredientes = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(titulo, style: tituloSeccion),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: colorCardFondo,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colorBorde, width: 1),
          ),
          child: Column(
            children: items.asMap().entries.map((entry) {
              final index = entry.key + 1;
              String item = entry.value;
              if (scaleIngredientes) {
                final gramRegex = RegExp(
                  r'(\d+(?:[.,]\d+)?)\s*(g|gr|grs|ml)\b',
                  caseSensitive: false,
                );
                item = item.replaceAllMapped(gramRegex, (m) {
                  final raw = m.group(1)!.replaceAll(',', '.');
                  final value = double.tryParse(raw) ?? 0.0;
                  final scaled = (value * factor);
                  final unidad = m.group(2) ?? 'g';
                  final scaledStr = (scaled % 1 == 0)
                      ? scaled.toInt().toString()
                      : scaled.toStringAsFixed(1);
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
                        color: colorTexto,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Center(
                        child: Text(
                          '$index',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Text(item, style: textoNormal)),
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
