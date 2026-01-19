import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'seguimiento.dart';

class MiPerfil extends StatefulWidget {
  const MiPerfil({super.key});

  @override
  State<MiPerfil> createState() => _MiPerfilState();
}

class _MiPerfilState extends State<MiPerfil> {
  final _formKey = GlobalKey<FormState>();

  // Controladores de texto
  late TextEditingController _nombreController;
  late TextEditingController _edadController;
  late TextEditingController _alturaController;
  late TextEditingController _pesoController;
  late TextEditingController _pesoObjetivoController;
  late TextEditingController _emailController;
  late TextEditingController _nombrePerfilController;

  // Variables de estado con valores por defecto para evitar NULL
  String _genero = 'Masculino';
  String _objetivo = 'Mantenimiento';
  String _nivelActividad = 'Sedentario';

  bool _enviando = false;
  final bool _mostrarGuardarPerfil = false;
  bool _modoEdicion = false; // Empezamos en modo lectura para ver los datos de la DB

  final List<String> generos = ['Masculino', 'Femenino'];
  final List<String> objetivos = ['Definición', 'Volumen', 'Mantenimiento'];
  final List<String> nivelesActividad = [
    'Sedentario',
    'Ligero',
    'Moderado',
    'Alto',
  ];
  final List<String> alergiasDisponibles = ['Gluten', 'Lácteos', 'Mariscos', 'Ninguno'];
  final List<String> preferenciasDisponibles = ['Vegano', 'Vegetariano', 'Sin restricciones'];

  List<String> _alergiasSeleccionadas = [];
  List<String> _preferenciasSeleccionadas = [];
  List<String> _perfilesGuardados = [];
  String _ultimoUsuario = '';

  // ---------------------------------------------------------------------------
  // CONFIGURACIÓN DE LA API (IMPORTANTE)
  // ---------------------------------------------------------------------------
  // Si usas Emulador Android: 'http://10.0.2.2:8000/api/v1'
  // Si usas iOS o Web: 'http://127.0.0.1:8000/api/v1'
  // Si usas celular físico: 'http://TU_IP_LOCAL:8000/api/v1'
  final String baseUrl = "http://10.0.2.2:8000/api/v1"; 

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController();
    _edadController = TextEditingController();
    _alturaController = TextEditingController();
    _pesoController = TextEditingController();
    _pesoObjetivoController = TextEditingController();
    _emailController = TextEditingController();
    _nombrePerfilController = TextEditingController();
    
    // Carga inicial
    _cargarDatosLocales().then((_) {
      // Una vez cargado lo local (email), intentamos bajar datos frescos de la DB
      if (_emailController.text.isNotEmpty) {
        _descargarPerfilDeBaseDeDatos(_emailController.text);
      }
    });
  }

  // 1. CARGAR DATOS LOCALES (Caché rápida)
  Future<void> _cargarDatosLocales() async {
    final prefs = await SharedPreferences.getInstance();
    final perfilJson = prefs.getString('perfil_completo');
    
    // Cargar lista de usuarios guardados
    setState(() {
      _perfilesGuardados = prefs.getStringList('perfiles_guardados') ?? [];
      _ultimoUsuario = prefs.getString('ultimo_usuario') ?? '';
    });

    if (perfilJson != null) {
      _actualizarUIConJson(jsonDecode(perfilJson));
    }
  }

  // 2. DESCARGAR DE LA BASE DE DATOS (API -> App)
  Future<void> _descargarPerfilDeBaseDeDatos(String email) async {
    try {
      final url = Uri.parse("$baseUrl/perfil/$email");
      final response = await http.get(url).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        setState(() {
          // Mapeamos las claves que vienen de Python (Backend) a los controladores de Flutter
          _nombreController.text = data['nombre'] ?? _nombreController.text;
          _edadController.text = data['edad']?.toString() ?? _edadController.text;
          
          // OJO AQUÍ: Usamos las claves nuevas de la DB
          if (data['altura_cm'] != null) _alturaController.text = data['altura_cm'].toString();
          if (data['peso_kg'] != null) _pesoController.text = data['peso_kg'].toString();
          if (data['peso_objetivo_kg'] != null) _pesoObjetivoController.text = data['peso_objetivo_kg'].toString();
          
          _genero = data['genero'] ?? _genero;
          _objetivo = data['objetivo'] ?? _objetivo;
          _nivelActividad = data['nivel_actividad'] ?? _nivelActividad;
        });

        // Actualizamos preferencias si existieran en otro endpoint (opcional)
        // _descargarPreferencias(data['id']);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Datos sincronizados con la nube ☁️'), backgroundColor: Colors.teal),
        );
      }
    } catch (e) {
      debugPrint("Error de conexión con la DB: $e");
      // No mostramos error al usuario para no molestar, usamos los datos locales
    }
  }

  // Helper para actualizar UI desde un JSON
  void _actualizarUIConJson(Map<String, dynamic> data) {
    setState(() {
      _nombreController.text = data['nombre'] ?? '';
      _emailController.text = data['email'] ?? '';
      _edadController.text = data['edad']?.toString() ?? '';
      // Soporte para claves viejas y nuevas
      _alturaController.text = (data['altura_cm'] ?? data['altura'])?.toString() ?? '';
      _pesoController.text = (data['peso_kg'] ?? data['peso'])?.toString() ?? '';
      _pesoObjetivoController.text = (data['peso_objetivo_kg'] ?? data['pesoObjetivo'])?.toString() ?? '';
      
      _genero = data['genero'] ?? 'Masculino';
      _objetivo = data['objetivo'] ?? 'Mantenimiento';
      _nivelActividad = data['nivel_actividad'] ?? data['nivelActividad'] ?? 'Sedentario';
      
      if (data['alergias'] != null) _alergiasSeleccionadas = List<String>.from(data['alergias']);
      if (data['preferencias'] != null) _preferenciasSeleccionadas = List<String>.from(data['preferencias']);
    });
  }

  // 3. GUARDAR CAMBIOS (App -> API -> DB)
  Future<void> _guardarCambios() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _enviando = true);

    try {
      final macros = _calcularMacros();
      
      // Construimos el JSON EXACTO que espera el Backend (Python)
      final perfilParaBackend = {
        'nombre': _nombreController.text,
        'email': _emailController.text,
        'edad': int.parse(_edadController.text),
        'altura_cm': double.parse(_alturaController.text), // Clave nueva
        'peso_kg': double.parse(_pesoController.text),     // Clave nueva
        'peso_objetivo_kg': double.tryParse(_pesoObjetivoController.text) ?? 0.0,
        'genero': _genero,
        'objetivo': _objetivo,
        'nivel_actividad': _nivelActividad,
      };

      // 1. Guardar Localmente (SharedPreferences)
      final prefs = await SharedPreferences.getInstance();
      // Agregamos extras locales que no van al backend principal
      final perfilLocal = Map.from(perfilParaBackend);
      perfilLocal['alergias'] = _alergiasSeleccionadas;
      perfilLocal['preferencias'] = _preferenciasSeleccionadas;
      perfilLocal['macros'] = macros;
      
      await prefs.setString('perfil_completo', jsonEncode(perfilLocal));
      await prefs.setString('ultimo_usuario', _nombreController.text);

      // 2. Enviar a la Base de Datos (API)
      try {
        final url = Uri.parse("$baseUrl/perfil"); // Endpoint POST/PUT
        final response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(perfilParaBackend),
        ).timeout(const Duration(seconds: 5));

        if (response.statusCode == 200 || response.statusCode == 201) {
           print("✅ Guardado en base de datos correctamente");
        } else {
           print("⚠️ Error backend: ${response.body}");
        }
      } catch (e) {
        print("❌ Error de red (modo offline): $e");
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Perfil actualizado exitosamente'), backgroundColor: Colors.green),
        );
        setState(() {
          _modoEdicion = false;
          _enviando = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
        setState(() => _enviando = false);
      }
    }
  }

  // ... (El resto de tus métodos: _calcularMacros, build, widgets... se mantienen igual)
  // ... (He simplificado esta parte, ASEGÚRATE de que tus widgets _buildTextField están definidos abajo)

  Map<String, dynamic> _calcularMacros() {
    try {
      if (_pesoController.text.isEmpty || _alturaController.text.isEmpty || _edadController.text.isEmpty) {
        return {'error': 'Completa los campos'};
      }
      final peso = double.parse(_pesoController.text);
      final altura = double.parse(_alturaController.text);
      final edad = int.parse(_edadController.text);

      double factor = 1.2;
      if (_nivelActividad == "Ligero") factor = 1.375;
      if (_nivelActividad == "Moderado") factor = 1.55;
      if (_nivelActividad == "Alto") factor = 1.725;

      double tdee = (10 * peso + 6.25 * altura - 5 * edad + 5) * factor;
      if (_genero == "Femenino") tdee = (10 * peso + 6.25 * altura - 5 * edad - 161) * factor;

      int cal = tdee.toInt();
      if (_objetivo == "Definición") cal -= 500;
      if (_objetivo == "Volumen") cal += 300;

      return {
        'calorias': cal,
        'proteinas': (peso * 2).toInt(),
        'grasas': (cal * 0.25 / 9).toInt(),
        'carbohidratos': ((cal - ((peso * 2 * 4) + (cal * 0.25))) / 4).toInt(),
        'estimacion': 'Calculado'
      };
    } catch (e) {
      return {'error': 'Error cálculo'};
    }
  }

  @override
  Widget build(BuildContext context) {
    final macros = _calcularMacros();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mi Perfil", style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(_modoEdicion ? Icons.close : Icons.edit, color: Colors.teal),
            onPressed: () => setState(() => _modoEdicion = !_modoEdicion),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Form(
              key: _formKey,
              child: Card(
                elevation: 6,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.account_circle, size: 70, color: Colors.teal),
                      const SizedBox(height: 16),
                      _buildTextField("Nombre", _nombreController, icon: Icons.person),
                      _buildTextField("Email", _emailController, icon: Icons.email, keyboardType: TextInputType.emailAddress),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(child: _buildTextField("Edad", _edadController, keyboardType: TextInputType.number)),
                          const SizedBox(width: 16),
                          Expanded(child: _buildTextField("Altura (cm)", _alturaController, keyboardType: TextInputType.number)),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(child: _buildTextField("Peso (kg)", _pesoController, keyboardType: TextInputType.number)),
                          const SizedBox(width: 16),
                          Expanded(child: _buildTextField("Meta (kg)", _pesoObjetivoController, keyboardType: TextInputType.number)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildDropdown("Genero", _genero, generos, (v) => setState(() => _genero = v!)),
                      _buildDropdown("Nivel Actividad", _nivelActividad, nivelesActividad, (v) => setState(() => _nivelActividad = v!)),
                      _buildDropdown("Objetivo", _objetivo, objetivos, (v) => setState(() => _objetivo = v!)),
                      
                      const SizedBox(height: 20),
                      if (!macros.containsKey('error')) 
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.teal.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.teal, width: 1.5)
                          ),
                          child: Column(
                            children: [
                              Text("Calorias: ${macros['calorias']} kcal", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal)),
                              const SizedBox(height: 8),
                              Text("Proteinas: ${macros['proteinas']}g  |  Carbohidratos: ${macros['carbohidratos']}g  |  Grasas: ${macros['grasas']}g", 
                                style: const TextStyle(fontSize: 14), textAlign: TextAlign.center),
                            ],
                          ),
                        ),

                      const SizedBox(height: 20),
                      if (_modoEdicion)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            icon: _enviando ? const SizedBox() : const Icon(Icons.save, color: Colors.white, size: 22),
                            label: Text(_enviando ? "Guardando..." : "Guardar Cambios", style: const TextStyle(fontSize: 16, color: Colors.white)),
                            onPressed: _enviando ? null : _guardarCambios,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Widget auxiliar para TextFields
  Widget _buildTextField(String label, TextEditingController controller, {TextInputType keyboardType = TextInputType.text, IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        enabled: _modoEdicion,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontSize: 13),
          prefixIcon: icon != null ? Icon(icon, color: Colors.teal, size: 20) : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          isDense: true,
          filled: true,
          fillColor: _modoEdicion ? Colors.white : Colors.grey.shade100,
        ),
        validator: (v) => v!.isEmpty ? "Requerido" : null,
      ),
    );
  }

  // Widget auxiliar para Dropdowns
  Widget _buildDropdown(String label, String value, List<String> items, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: DropdownButtonFormField<String>(
        value: value,
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 14)))).toList(),
        onChanged: _modoEdicion ? onChanged : null,
        style: const TextStyle(fontSize: 14, color: Colors.black87),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontSize: 13),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          isDense: true,
          filled: true,
          fillColor: _modoEdicion ? Colors.white : Colors.grey.shade100,
        ),
      ),
    );
  }
}