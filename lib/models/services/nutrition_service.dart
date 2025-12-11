class NutritionService {
  static final Map<String, Map<String, dynamic>> _alimentos = {
    'pollo': {
      'nombre': 'Pechuga de Pollo',
      'calorias': 165.0,
      'proteinas_g': 31.0,
      'carbohidratos_g': 0.0,
      'grasas_g': 3.6,
    },
    'huevo': {
      'nombre': 'Huevo Entero',
      'calorias': 155.0,
      'proteinas_g': 13.0,
      'carbohidratos_g': 1.1,
      'grasas_g': 11.0,
    },
    'atun': {
      'nombre': 'Atún en Lata',
      'calorias': 132.0,
      'proteinas_g': 29.0,
      'carbohidratos_g': 0.0,
      'grasas_g': 1.3,
    },
    'arroz': {
      'nombre': 'Arroz Integral Cocido',
      'calorias': 111.0,
      'proteinas_g': 2.6,
      'carbohidratos_g': 23.0,
      'grasas_g': 0.9,
    },
    'avena': {
      'nombre': 'Avena Cruda',
      'calorias': 389.0,
      'proteinas_g': 16.9,
      'carbohidratos_g': 66.3,
      'grasas_g': 6.9,
    },
    'platano': {
      'nombre': 'Plátano Mediano',
      'calorias': 89.0,
      'proteinas_g': 1.1,
      'carbohidratos_g': 23.0,
      'grasas_g': 0.3,
    },
    'aguacate': {
      'nombre': 'Aguacate',
      'calorias': 160.0,
      'proteinas_g': 2.0,
      'carbohidratos_g': 8.6,
      'grasas_g': 14.7,
    },
    'salmon': {
      'nombre': 'Salmón',
      'calorias': 208.0,
      'proteinas_g': 20.0,
      'carbohidratos_g': 0.0,
      'grasas_g': 13.0,
    },
    'broccoli': {
      'nombre': 'Brócoli Cocido',
      'calorias': 34.0,
      'proteinas_g': 3.7,
      'carbohidratos_g': 6.6,
      'grasas_g': 0.4,
    },
    'quinoa': {
      'nombre': 'Quinoa Cocida',
      'calorias': 120.0,
      'proteinas_g': 4.4,
      'carbohidratos_g': 21.3,
      'grasas_g': 1.9,
    },
    'yogur': {
      'nombre': 'Yogur Griego',
      'calorias': 59.0,
      'proteinas_g': 10.2,
      'carbohidratos_g': 3.3,
      'grasas_g': 0.4,
    },
    'leche': {
      'nombre': 'Leche Desnatada',
      'calorias': 35.0,
      'proteinas_g': 3.6,
      'carbohidratos_g': 5.0,
      'grasas_g': 0.1,
    },
    'carne': {
      'nombre': 'Ternera Magra',
      'calorias': 250.0,
      'proteinas_g': 26.0,
      'carbohidratos_g': 0.0,
      'grasas_g': 15.0,
    },
    'papa': {
      'nombre': 'Papa Cocida',
      'calorias': 77.0,
      'proteinas_g': 1.7,
      'carbohidratos_g': 17.5,
      'grasas_g': 0.1,
    },
    'naranja': {
      'nombre': 'Naranja',
      'calorias': 47.0,
      'proteinas_g': 0.9,
      'carbohidratos_g': 12.0,
      'grasas_g': 0.3,
    },
    'manzana': {
      'nombre': 'Manzana Roja',
      'calorias': 52.0,
      'proteinas_g': 0.3,
      'carbohidratos_g': 14.0,
      'grasas_g': 0.2,
    },
    'almendra': {
      'nombre': 'Almendras Crudas',
      'calorias': 579.0,
      'proteinas_g': 21.2,
      'carbohidratos_g': 21.6,
      'grasas_g': 49.9,
    },
  };

  static Future<Map<String, dynamic>?> buscarAlimento(String nombre) async {
    final nombreNormalizado = nombre.toLowerCase()
        .replaceAll(RegExp(r'[áàäâ]'), 'a')
        .replaceAll(RegExp(r'[éèëê]'), 'e')
        .replaceAll(RegExp(r'[íìïî]'), 'i')
        .replaceAll(RegExp(r'[óòöô]'), 'o')
        .replaceAll(RegExp(r'[úùüû]'), 'u');

    for (final key in _alimentos.keys) {
      if (nombreNormalizado.contains(key) || key.contains(nombreNormalizado)) {
        return _alimentos[key];
      }
    }

    return null;
  }

  static Future<List<Map<String, dynamic>>> buscarAlimentosPorMacro({
    required int caloriasBuscadas,
    required int tolerancia,
  }) async {
    return [];
  }

  static Future<Map<String, dynamic>> obtenerAlimentosPorCategoria(String categoria) async {
    return {};
  }
}
