import 'package:http/http.dart' as http;
import 'dart:convert';

class BackendService {
  static const String baseUrl = 'http://127.0.0.1:8000/api'; // 👈 cambia por la IP real de tu API

  /// 🔹 Obtener datos del perfil del usuario
  static Future<Map<String, dynamic>> getPerfil(int idUsuario) async {
    final url = Uri.parse('$baseUrl/usuario/$idUsuario');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al obtener el perfil');
    }
  }

  /// 🔹 Actualizar datos del perfil
  static Future<void> actualizarPerfil(int idUsuario, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/usuario/$idUsuario');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al actualizar el perfil');
    }
  }
}
