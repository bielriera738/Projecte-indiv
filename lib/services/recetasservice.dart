import 'package:http/http.dart' as http;
import 'dart:convert';
import '../screens/recetas.dart';

class RecetasService {
  static const String baseUrl = 'http://127.0.0.1:8000/api/v1';

  /// Carga todas las recetas desde la API
  static Future<List<Receta>> cargarRecetas() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/recetas'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Timeout al conectar con el servidor');
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        List<dynamic> data;

        // Manejar diferentes formatos de respuesta
        if (jsonData is List) {
          data = jsonData;
        } else if (jsonData is Map && jsonData.containsKey('data')) {
          data = jsonData['data'] as List;
        } else {
          throw Exception('Formato de respuesta inválido');
        }

        final recetas = data
            .map((item) => Receta.fromJson(item as Map<String, dynamic>))
            .toList();

        return recetas;
      } else {
        throw Exception(
          'Error al cargar recetas: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error al conectar con el servidor: ${e.toString()}');
    }
  }

  /// Carga una receta específica por ID
  static Future<Receta> cargarRecetaPorId(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/recetas/$id'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Timeout al conectar con el servidor');
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final recetaData =
            jsonData is Map ? jsonData : jsonData['data'] as Map<String, dynamic>;
        return Receta.fromJson(recetaData as Map<String, dynamic>);
      } else {
        throw Exception(
          'Error al cargar la receta: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error al conectar con el servidor: ${e.toString()}');
    }
  }

  /// Obtiene las categorías únicas de las recetas
  static List<String> obtenerCategorias(List<Receta> recetas) {
    final categoriasSet = <String>{'Todos'};
    for (var receta in recetas) {
      categoriasSet.add(receta.categoria);
    }
    return categoriasSet.toList();
  }
}
