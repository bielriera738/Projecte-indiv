import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://127.0.0.1:8000"; // Flask API

  static Future<Map<String, dynamic>> calcularMacros({
    required double peso,
    required double altura,
    required int edad,
    required String objetivo,
  }) async {
    final url = Uri.parse("$baseUrl/calcular-macros");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "peso": peso,
          "altura": altura,
          "edad": edad,
          "objetivo": objetivo,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
            "Error API: ${response.statusCode} → ${response.body}");
      }
    } catch (e) {
      throw Exception("Error de conexión con la API: $e");
    }
  }
}
