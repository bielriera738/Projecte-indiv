import 'dart:io';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';

class ExportService {
  static Future<String> exportToCSV(List<List<dynamic>> data, String fileName) async {
    try {
      String csvData = const ListToCsvConverter().convert(data);
      final directory = await getApplicationDocumentsDirectory();
      final path = "${directory.path}/$fileName.csv";
      final file = File(path);
      await file.writeAsString(csvData);
      return path;
    } catch (e) {
      throw Exception("Error al exportar CSV: $e");
    }
  }
}
