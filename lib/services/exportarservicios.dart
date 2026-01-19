import 'package:flutter/services.dart';

class ExportService {
  /// Genera un CSV y lo copia al portapapeles.
  /// Compatible con Web, Windows, Android e iOS.
  static Future<String> exportToCSV(List<List<dynamic>> data, String fileName) async {
    try {
      // 1. Convertir datos a formato CSV
      String csvData = data.map((row) {
        return row.map((cell) {
          String cellStr = cell?.toString() ?? "";
          // Escapar celdas con comas, comillas o saltos de línea
          if (cellStr.contains(',') || cellStr.contains('"') || cellStr.contains('\n')) {
            cellStr = '"${cellStr.replaceAll('"', '""')}"';
          }
          return cellStr;
        }).join(',');
      }).join('\n');
      
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
}
