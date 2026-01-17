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

  late TextEditingController _nombreController;
  late TextEditingController _edadController;
  late TextEditingController _alturaController;
  late TextEditingController _pesoController;
  late TextEditingController _emailController;
  late TextEditingController _nombrePerfilController;

  String _genero = '';
  String _objetivo = '';
  String _nivelActividad = '';

  bool _enviando = false;
  bool _mostrarGuardarPerfil = false;
  bool _modoEdicion = true;

  final List<String> generos = ['Masculino', 'Femenino'];
  final List<String> objetivos = ['Definición', 'Volumen', 'Mantenimiento'];
  final List<String> nivelesActividad = [
    'Sedentario',
    'Ligero',
    'Moderado',
    'Alto',
  ];
  final List<String> alergiasDisponibles = [
    'Gluten',
    'Lácteos',
    'Mariscos',
    'Ninguno',
  ];
  final List<String> preferenciasDisponibles = [
    'Vegano',
    'Vegetariano',
    'Sin restricciones',
  ];

  List<String> _alergiasSeleccionadas = [];
  List<String> _preferenciasSeleccionadas = [];
  List<String> _perfilesGuardados = [];
  String _ultimoUsuario = '';

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController();
    _edadController = TextEditingController();
    _alturaController = TextEditingController();
    _pesoController = TextEditingController();
    _emailController = TextEditingController();
    _nombrePerfilController = TextEditingController();
    _cargarPerfil();
    _cargarPerfilesGuardados();
  }

  Future<void> _cargarPerfilesGuardados() async {
    final prefs = await SharedPreferences.getInstance();
    final perfilesJson = prefs.getStringList('perfiles_guardados') ?? [];
    final ultimo = prefs.getString('ultimo_usuario') ?? '';
    setState(() {
      _perfilesGuardados = perfilesJson;
      _ultimoUsuario = ultimo;
    });
  }

  Future<void> _cargarPerfil() async {
    final prefs = await SharedPreferences.getInstance();
    final perfilJson = prefs.getString('perfil_completo');

    if (perfilJson != null) {
      final perfil = jsonDecode(perfilJson);
      setState(() {
        _nombreController.text = perfil['nombre']?.toString() ?? '';
        _edadController.text = perfil['edad']?.toString() ?? '';
        _alturaController.text = perfil['altura']?.toString() ?? '';
        _pesoController.text = perfil['peso']?.toString() ?? '';
        _emailController.text = perfil['email']?.toString() ?? '';
        _genero = perfil['genero']?.toString() ?? '';
        _objetivo = perfil['objetivo']?.toString() ?? '';
        _nivelActividad = perfil['nivelActividad']?.toString() ?? '';
        _alergiasSeleccionadas = List<String>.from(perfil['alergias'] ?? []);
        _preferenciasSeleccionadas = List<String>.from(
          perfil['preferencias'] ?? [],
        );
      });
    }
  }

  Map<String, dynamic> _calcularMacros() {
    try {
      if (_pesoController.text.isEmpty ||
          _alturaController.text.isEmpty ||
          _edadController.text.isEmpty ||
          _genero.isEmpty ||
          _objetivo.isEmpty ||
          _nivelActividad.isEmpty) {
        return {'error': 'Por favor completa todos los campos requeridos'};
      }

      final peso = double.parse(_pesoController.text);
      final altura = double.parse(_alturaController.text);
      final edad = int.parse(_edadController.text);

      double factorActividad = 1.375;
      if (_nivelActividad == "Sedentario") factorActividad = 1.2;
      if (_nivelActividad == "Ligero") factorActividad = 1.375;
      if (_nivelActividad == "Moderado") factorActividad = 1.55;
      if (_nivelActividad == "Alto") factorActividad = 1.725;

      double tdee;
      if (_genero == "Masculino") {
        tdee = (10 * peso + 6.25 * altura - 5 * edad + 5) * factorActividad;
      } else {
        tdee = (10 * peso + 6.25 * altura - 5 * edad - 161) * factorActividad;
      }

      int calorias;
      if (_objetivo == "Definición") {
        calorias = (tdee - 500).toInt();
      } else if (_objetivo == "Volumen") {
        calorias = (tdee + 300).toInt();
      } else {
        calorias = tdee.toInt();
      }

      int proteinas = (peso * 2.2).toInt();
      int grasas = (calorias * 0.25 / 9).toInt();
      int carbohidratos = ((calorias - (proteinas * 4 + grasas * 9)) / 4)
          .toInt();

      return {
        'calorias': calorias,
        'proteinas': proteinas,
        'grasas': grasas,
        'carbohidratos': carbohidratos,
        'tdee': tdee.toStringAsFixed(2),
      };
    } catch (e) {
      return {'error': 'Error al calcular: $e'};
    }
  }

  Future<void> _guardarCambios() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _enviando = true);

    try {
      final macros = _calcularMacros();
      if (macros.containsKey('error')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(macros['error']), backgroundColor: Colors.red),
        );
        setState(() => _enviando = false);
        return;
      }

      final perfilActualizado = {
        'nombre': _nombreController.text,
        'edad': int.parse(_edadController.text),
        'altura': double.parse(_alturaController.text),
        'peso': double.parse(_pesoController.text),
        'email': _emailController.text,
        'genero': _genero,
        'objetivo': _objetivo,
        'nivelActividad': _nivelActividad,
        'alergias': _alergiasSeleccionadas,
        'preferencias': _preferenciasSeleccionadas,
        'macros': macros,
        'fecha': DateTime.now().toIso8601String(),
      };

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('perfil_completo', jsonEncode(perfilActualizado));

      // Guardar como último usuario y registrar entrada de seguimiento
      final nombreUsuario = perfilActualizado['nombre'] as String;
      await prefs.setString('ultimo_usuario', nombreUsuario);
      final seguimientoKey = 'seguimiento_$nombreUsuario';
      final List<String> historial = prefs.getStringList(seguimientoKey) ?? [];
      final seguimientoEntry = jsonEncode({
        'fecha': DateTime.now().toIso8601String(),
        'macros': macros,
      });
      historial.add(seguimientoEntry);
      await prefs.setStringList(seguimientoKey, historial);

      // Intentar sincronizar la entrada de seguimiento con backend (no bloqueante)
      try {
        final syncUrl = Uri.parse(
          'http://192.168.1.100:8000/guardar-seguimiento/',
        );
        await http
            .post(
              syncUrl,
              headers: {'Content-Type': 'application/json'},
              body: seguimientoEntry,
            )
            .timeout(const Duration(seconds: 8));
      } catch (_) {
        // ignorar errores de red aquí; el registro queda en SharedPreferences
      }

      // Intentar sincronizar la entrada de seguimiento con backend (no bloqueante)
      try {
        final syncUrl = Uri.parse(
          'http://192.168.1.100:8000/guardar-seguimiento/',
        );
        await http
            .post(
              syncUrl,
              headers: {'Content-Type': 'application/json'},
              body: seguimientoEntry,
            )
            .timeout(const Duration(seconds: 8));
      } catch (_) {
        // ignorar errores de red aquí; el registro queda en SharedPreferences
      }

      final url = Uri.parse("http://192.168.1.100:8000/actualizar-perfil/");
      await http
          .put(
            url,
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(perfilActualizado),
          )
          .timeout(const Duration(seconds: 10));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Perfil actualizado correctamente'),
            backgroundColor: Colors.green,
          ),
        );
        setState(() {
          _modoEdicion = false;
          _enviando = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Error: $e'), backgroundColor: Colors.red),
        );
        setState(() => _enviando = false);
      }
    }
  }

  Future<void> _cerrarSesion() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey.shade800,
          title: const Text(
            "Cerrar Sesión",
            style: TextStyle(
              color: Colors.tealAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            "¿Estás seguro de que deseas cerrar sesión?",
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Cancelar",
                style: TextStyle(color: Colors.black54),
              ),
            ),
            TextButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.clear();

                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('✅ Sesión cerrada correctamente'),
                      backgroundColor: Colors.green,
                      duration: Duration(seconds: 2),
                    ),
                  );

                  Future.delayed(const Duration(seconds: 1), () {
                    if (mounted) {
                      Navigator.of(
                        context,
                      ).pushNamedAndRemoveUntil('/', (route) => false);
                    }
                  });
                }
              },
              child: const Text(
                "Cerrar Sesión",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _guardarPerfilConNombre() async {
    if (_nombrePerfilController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('❌ Por favor ingresa un nombre para el perfil'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final macros = _calcularMacros();
      if (macros.containsKey('error')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(macros['error']), backgroundColor: Colors.red),
        );
        return;
      }

      final perfilGuardado = {
        'nombre': _nombreController.text,
        'nombrePerfil': _nombrePerfilController.text,
        'edad': int.parse(_edadController.text),
        'altura': double.parse(_alturaController.text),
        'peso': double.parse(_pesoController.text),
        'email': _emailController.text,
        'genero': _genero,
        'objetivo': _objetivo,
        'nivelActividad': _nivelActividad,
        'alergias': _alergiasSeleccionadas,
        'preferencias': _preferenciasSeleccionadas,
        'macros': macros,
        'fecha': DateTime.now().toIso8601String(),
      };

      final prefs = await SharedPreferences.getInstance();

      await prefs.setString(
        'perfil_${_nombrePerfilController.text}',
        jsonEncode(perfilGuardado),
      );

      // Guardar como último usuario (usamos el nombre del perfil guardado) y registrar seguimiento
      await prefs.setString('ultimo_usuario', _nombrePerfilController.text);
      final seguimientoKey = 'seguimiento_${_nombrePerfilController.text}';
      final List<String> historial = prefs.getStringList(seguimientoKey) ?? [];
      final seguimientoEntry = jsonEncode({
        'fecha': DateTime.now().toIso8601String(),
        'macros': macros,
      });
      historial.add(seguimientoEntry);
      await prefs.setStringList(seguimientoKey, historial);

      _perfilesGuardados.add(_nombrePerfilController.text);
      await prefs.setStringList('perfiles_guardados', _perfilesGuardados);

      final url = Uri.parse(
        "http://192.168.1.100:8000/guardar-perfil-completo/",
      );
      await http
          .post(
            url,
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(perfilGuardado),
          )
          .timeout(const Duration(seconds: 10));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '✅ Perfil "${_nombrePerfilController.text}" guardado correctamente',
            ),
            backgroundColor: Colors.green,
          ),
        );
        setState(() {
          _mostrarGuardarPerfil = false;
          _nombrePerfilController.clear();
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Widget _buildChipList(List<String> items, List<String> seleccionadas) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items.map((item) {
        final isSelected = seleccionadas.contains(item);
        return FilterChip(
          label: Text(
            item,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
          selected: isSelected,
          selectedColor: Colors.black87,
          backgroundColor: Colors.grey.shade200,
          side: BorderSide(
            color: isSelected ? Colors.black87 : Colors.grey.shade400,
            width: 1.5,
          ),
          onSelected: _modoEdicion
              ? (_) {
                  setState(() {
                    if (isSelected) {
                      seleccionadas.remove(item);
                    } else {
                      seleccionadas.add(item);
                    }
                  });
                }
              : null,
        );
      }).toList(),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
    IconData? icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        enabled: _modoEdicion,
        style: const TextStyle(color: Colors.white, fontSize: 16),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          prefixIcon: icon != null ? Icon(icon, color: Colors.teal) : null,
          filled: true,
          fillColor: Colors.black87,
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.teal, width: 1.5),
            borderRadius: BorderRadius.circular(10),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.teal, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        validator: (value) => value!.isEmpty ? "Requerido" : null,
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    String value,
    List<String> items,
    Function(String?) onChanged, {
    IconData? icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        initialValue: value.isEmpty ? null : value,
        dropdownColor: Colors.black87,
        style: const TextStyle(color: Colors.white, fontSize: 16),
        disabledHint: Text(
          value.isEmpty ? label : value,
          style: const TextStyle(color: Colors.white70),
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          prefixIcon: icon != null ? Icon(icon, color: Colors.teal) : null,
          filled: true,
          fillColor: Colors.black87,
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.teal, width: 1.5),
            borderRadius: BorderRadius.circular(10),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.teal, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: _modoEdicion ? onChanged : null,
        validator: (value) => value == null ? "Requerido" : null,
      ),
    );
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _edadController.dispose();
    _alturaController.dispose();
    _pesoController.dispose();
    _emailController.dispose();
    _nombrePerfilController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final macros = _calcularMacros();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Mi Perfil",
          style: TextStyle(
            color: Colors.teal,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Tooltip(
            message: "Cerrar sesión",
            child: IconButton(
              icon: const Icon(Icons.logout, color: Colors.red, size: 24),
              onPressed: _cerrarSesion,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300, width: 1.4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Center(
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.teal,
                        child: Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (_ultimoUsuario.isNotEmpty)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.show_chart),
                          label: Text(
                            'Ver Seguimiento: $_ultimoUsuario',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          onPressed: () async {
                            final prefs = await SharedPreferences.getInstance();
                            final ultimo =
                                prefs.getString('ultimo_usuario') ?? '';
                            if (ultimo.isNotEmpty && mounted) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      SeguimientoScreen(username: ultimo),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'No hay usuario para seguimiento',
                                  ),
                                  backgroundColor: Colors.orange,
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    const SizedBox(height: 8),

                    _buildTextField(
                      "Nombre",
                      _nombreController,
                      icon: Icons.person,
                    ),
                    _buildTextField(
                      "Email",
                      _emailController,
                      keyboardType: TextInputType.emailAddress,
                      icon: Icons.email,
                    ),
                    _buildDropdown(
                      "Género",
                      _genero,
                      generos,
                      (value) => setState(() => _genero = value ?? ''),
                      icon: Icons.wc,
                    ),

                    const SizedBox(height: 20),
                    const Divider(color: Colors.tealAccent, thickness: 1),
                    const SizedBox(height: 20),

                    _buildTextField(
                      "Edad (años)",
                      _edadController,
                      keyboardType: TextInputType.number,
                      icon: Icons.cake_outlined,
                    ),
                    _buildTextField(
                      "Altura (cm)",
                      _alturaController,
                      keyboardType: TextInputType.number,
                      icon: Icons.height,
                    ),
                    _buildTextField(
                      "Peso (kg)",
                      _pesoController,
                      keyboardType: TextInputType.number,
                      icon: Icons.monitor_weight,
                    ),

                    const SizedBox(height: 20),
                    const Divider(color: Colors.tealAccent, thickness: 1),
                    const SizedBox(height: 20),

                    _buildDropdown(
                      "Objetivo",
                      _objetivo,
                      objetivos,
                      (value) => setState(() => _objetivo = value ?? ''),
                      icon: Icons.track_changes,
                    ),
                    _buildDropdown(
                      "Nivel de Actividad",
                      _nivelActividad,
                      nivelesActividad,
                      (value) => setState(() => _nivelActividad = value ?? ''),
                      icon: Icons.directions_run,
                    ),

                    const SizedBox(height: 28),

                    if (!macros.containsKey('error'))
                      Card(
                        color: const Color(0xFF071B18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                          side: const BorderSide(
                            color: Colors.orangeAccent,
                            width: 2,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(
                                    Icons.calculate,
                                    color: Colors.orangeAccent,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    "Macros Calculados",
                                    style: TextStyle(
                                      color: Colors.orangeAccent,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),
                              _filasMacro(
                                "🔥 Calorías",
                                "${macros['calorias']} kcal",
                                Colors.redAccent,
                              ),
                              const SizedBox(height: 10),
                              _filasMacro(
                                "🥚 Proteínas",
                                "${macros['proteinas']} g",
                                Colors.blueAccent,
                              ),
                              const SizedBox(height: 10),
                              _filasMacro(
                                "🍞 Carbohidratos",
                                "${macros['carbohidratos']} g",
                                Colors.amberAccent,
                              ),
                              const SizedBox(height: 10),
                              _filasMacro(
                                "🥑 Grasas",
                                "${macros['grasas']} g",
                                Colors.greenAccent,
                              ),
                            ],
                          ),
                        ),
                      ),

                    const SizedBox(height: 20),

                    if (_modoEdicion)
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              icon: _enviando
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Icon(Icons.save),
                              label: const Text(
                                "Guardar Cambios",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              onPressed: _enviando ? null : _guardarCambios,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              icon: const Icon(Icons.close),
                              label: const Text(
                                "Cancelar",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              onPressed: () {
                                _cargarPerfil();
                                setState(() => _modoEdicion = false);
                              },
                            ),
                          ),
                        ],
                      )
                    else
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black87,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.edit),
                          label: const Text(
                            "Editar Perfil",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          onPressed: () => setState(() => _modoEdicion = true),
                        ),
                      ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black87,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.save),
                        label: const Text(
                          "Guardar Perfil con Nombre",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        onPressed: () => setState(
                          () => _mostrarGuardarPerfil = !_mostrarGuardarPerfil,
                        ),
                      ),
                    ),

                    if (_mostrarGuardarPerfil) ...[
                      const SizedBox(height: 20),
                      Card(
                        color: Colors.grey.shade50,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              _buildTextField(
                                "Nombre del Perfil",
                                _nombrePerfilController,
                                icon: Icons.bookmark,
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                      ),
                                      icon: const Icon(Icons.check),
                                      label: const Text("Guardar"),
                                      onPressed: _guardarPerfilConNombre,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                      ),
                                      icon: const Icon(Icons.close),
                                      label: const Text("Cancelar"),
                                      onPressed: () => setState(
                                        () => _mostrarGuardarPerfil = false,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],

                    if (_perfilesGuardados.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      Card(
                        color: Colors.grey.shade50,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(
                                    Icons.folder_open,
                                    color: Colors.tealAccent,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    "Perfiles Guardados",
                                    style: TextStyle(
                                      color: Colors.tealAccent,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              ..._perfilesGuardados.map(
                                (perfil) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 6,
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.tealAccent.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: Colors.tealAccent,
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          perfil,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.copy,
                                            color: Colors.tealAccent,
                                            size: 20,
                                          ),
                                          onPressed: () {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Copia "$perfil" en el chat para recetas personalizadas',
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _filasMacro(String label, String valor, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.black87, fontSize: 16),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color, width: 1.5),
          ),
          child: Text(
            valor,
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
