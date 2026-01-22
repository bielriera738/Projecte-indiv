import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// Implementación para plataformas nativas (Android, iOS, Windows, macOS, Linux)
Future<String?> saveCSVFile({
  required String csvContent,
  required String suggestedFileName,
}) async {
  final String safeName = suggestedFileName.toLowerCase().endsWith('.csv')
      ? suggestedFileName
      : '$suggestedFileName.csv';

  // Obtener directorio según plataforma
  Directory? directory;

  if (Platform.isAndroid) {
    directory = await getExternalStorageDirectory();
  } else if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
    directory = await getDownloadsDirectory();
  }

  // Fallback a documentos de la app
  directory ??= await getApplicationDocumentsDirectory();

  final String filePath = '${directory.path}/$safeName';
  final File file = File(filePath);
  await file.writeAsString(csvContent, encoding: utf8);

  // En móvil: abrir diálogo de compartir para que el usuario elija dónde guardar
  if (Platform.isAndroid || Platform.isIOS) {
    await Share.shareXFiles(
      [XFile(filePath)],
      text: 'Macros - NutriVision AI',
      subject: 'Exportación CSV',
    );
  }

  return filePath;
}
