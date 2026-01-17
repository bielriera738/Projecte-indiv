import 'package:flutter/services.dart';
import 'package:file_saver/file_saver.dart';
import 'dart:typed_data';

class ExportService {
  /// Genera un CSV y lo guarda como archivo descargable.
  /// En Windows: abre diálogo para elegir ubicación (Descargas por defecto)
  /// En Android: guarda en almacenamiento externo
  /// En Web: descarga automática desde el navegador
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
      
      // 2. Convertir a bytes
      Uint8List bytes = Uint8List.fromList(csvData.codeUnits);
      
      // 3. Guardar archivo (abre diálogo en Windows, descarga en Web)
      String result = await FileSaver.instance.saveFile(
        name: fileName,
        bytes: bytes,
        ext: 'csv',
        mimeType: MimeType.csv,
      );
      
      return result;
    } catch (e) {
      throw Exception("Error al exportar: $e");
    }
  }
  
  /// Exporta un string CSV directamente
  static Future<String> exportCSVString(String csvContent, String fileName) async {
    try {
      Uint8List bytes = Uint8List.fromList(csvContent.codeUnits);
      
      String result = await FileSaver.instance.saveFile(
        name: fileName,
        bytes: bytes,
        ext: 'csv',
        mimeType: MimeType.csv,
      );
      
      return result;
    } catch (e) {
      throw Exception("Error al exportar: $e");
    }
  }
}
