import 'package:flutter/services.dart';
import 'package:csv/csv.dart';

// Importación condicional para dart:io (no disponible en web)
import 'exportarservicios_io.dart' if (dart.library.html) 'exportarservicios_web.dart' as platform;

class ExportService {
  /// Genera el contenido CSV de forma robusta (escapa comas/comillas/saltos).
  static String generateCsv(List<List<dynamic>> data) {
    return const ListToCsvConverter(eol: '\n').convert(data);
  }

  /// Genera un CSV y lo copia al portapapeles.
  /// Compatible con Web, Windows, Android e iOS.
  static Future<String> exportToCSV(List<List<dynamic>> data, String fileName) async {
    try {
      // 1. Convertir datos a formato CSV
      final String csvData = generateCsv(data);
      
      // 2. Copiar al portapapeles
      await Clipboard.setData(ClipboardData(text: csvData));
      
      return "CSV copiado al portapapeles";
    } catch (e) {
      throw Exception("Error al exportar: $e");
    }
  }
  
  /// Exporta un string CSV directamente al portapapeles
  static Future<String> exportCSVString(String csvContent, String fileName) async {
    try {
      await Clipboard.setData(ClipboardData(text: csvContent));
      return "CSV copiado al portapapeles";
    } catch (e) {
      throw Exception("Error al exportar: $e");
    }
  }

  /// Guarda un CSV en una ubicación elegida por el usuario.
  /// Devuelve la ruta guardada, o null si el usuario cancela.
  static Future<String?> saveCSVStringWithPicker({
    required String csvContent,
    required String suggestedFileName,
  }) async {
    return platform.saveCSVFile(csvContent: csvContent, suggestedFileName: suggestedFileName);
  }
}
