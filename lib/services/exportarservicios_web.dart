// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:convert';

/// Implementación para Web: descarga el archivo directamente
Future<String?> saveCSVFile({
  required String csvContent,
  required String suggestedFileName,
}) async {
  final String safeName = suggestedFileName.toLowerCase().endsWith('.csv')
      ? suggestedFileName
      : '$suggestedFileName.csv';

  // Crear blob y descargar
  final bytes = utf8.encode(csvContent);
  final blob = html.Blob([bytes], 'text/csv');
  final url = html.Url.createObjectUrlFromBlob(blob);

  html.AnchorElement(href: url)
    ..setAttribute('download', safeName)
    ..click();

  html.Url.revokeObjectUrl(url);

  return safeName;
}
