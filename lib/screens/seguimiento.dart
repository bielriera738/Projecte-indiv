import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SeguimientoScreen extends StatefulWidget {
  final String? username;
  const SeguimientoScreen({this.username, super.key});

  @override
  State<SeguimientoScreen> createState() => _SeguimientoScreenState();
}

class _SeguimientoScreenState extends State<SeguimientoScreen> {
  late Map<String, dynamic> _macrosObjetivo;
  late Map<String, dynamic> _macrosConsumidos;
  late TextEditingController _gramosController;
  String _alimentoSeleccionado = '';
  String _nombreUsuario = 'Usuario';
  bool _cargandoDatos = true;
  List<Map<String, dynamic>> _recetasPersonalizadas = [];
  List<Map<String, dynamic>> _historicoMacros = [];
  int _selectedTabIndex = 0;

  final Map<String, Map<String, dynamic>> baseAlimentos = {
    "pollo": {"nombre": "Pechuga de Pollo", "calorias": 165, "proteinas": 31, "carbs": 0, "grasas": 3.6},
    "pavo": {"nombre": "Pechuga de Pavo", "calorias": 135, "proteinas": 29, "carbs": 0, "grasas": 0.5},
    "pescado": {"nombre": "Salmón", "calorias": 208, "proteinas": 20, "carbs": 0, "grasas": 13},
    "atun": {"nombre": "Atún", "calorias": 132, "proteinas": 29, "carbs": 0, "grasas": 0.9},
    "huevo": {"nombre": "Huevo", "calorias": 155, "proteinas": 13, "carbs": 1.1, "grasas": 11},
    "arroz": {"nombre": "Arroz", "calorias": 130, "proteinas": 2.7, "carbs": 28, "grasas": 0.3},
    "avena": {"nombre": "Avena", "calorias": 389, "proteinas": 16.6, "carbs": 66.2, "grasas": 6.9},
    "pasta": {"nombre": "Pasta", "calorias": 174, "proteinas": 7.5, "carbs": 34.4, "grasas": 1.1},
    "papa": {"nombre": "Papa", "calorias": 77, "proteinas": 1.7, "carbs": 17, "grasas": 0.1},
    "aguacate": {"nombre": "Aguacate", "calorias": 160, "proteinas": 2, "carbs": 9, "grasas": 14.7},
  };

  @override
  void initState() {
    super.initState();
    _gramosController = TextEditingController();
    _macrosObjetivo = {};
    _macrosConsumidos = {
      'calorias': 0.0,
      'proteinas': 0.0,
      'carbs': 0.0,
      'grasas': 0.0,
    };
    _inicializarDatos();
  }

  Future<void> _inicializarDatos() async {
    await Future.wait([
      _cargarPerfil(),
      _cargarComidayDelDia(),
      _cargarRecetasPersonalizadas(),
      _cargarHistoricoMacros(),
    ]);
    if (mounted) {
      setState(() => _cargandoDatos = false);
    }
  }

  Future<void> _cargarPerfil() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final perfilJson = prefs.getString('perfil_completo');
      
      if (perfilJson != null) {
        final perfil = jsonDecode(perfilJson) as Map<String, dynamic>;
        final macros = perfil['macros'] as Map<String, dynamic>? ?? {};
        
        setState(() {
          // Usa username pasado si existe, sino usa el guardado en SharedPreferences
          _nombreUsuario = (widget.username != null && widget.username!.isNotEmpty) ? widget.username! : (perfil['nombre'] as String? ?? 'Usuario');
          _macrosObjetivo = {
            'calorias': (macros['calorias'] as num?)?.toDouble() ?? 2000.0,
            'proteinas': (macros['proteinas'] as num?)?.toDouble() ?? 150.0,
            'carbs': (macros['carbohidratos'] as num?)?.toDouble() ?? 200.0,
            'grasas': (macros['grasas'] as num?)?.toDouble() ?? 70.0,
          };
        });
      } else {
        if (widget.username != null && widget.username!.isNotEmpty) {
          setState(() => _nombreUsuario = widget.username!);
        }
      }
    } catch (e) {
      debugPrint("❌ Error cargando perfil: $e");
    }
  }

  Future<void> _cargarComidayDelDia() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final hoy = DateTime.now();
      final fechaFormato = "${hoy.year}-${hoy.month.toString().padLeft(2, '0')}-${hoy.day.toString().padLeft(2, '0')}";
      final comidasJson = prefs.getString('comidas_$fechaFormato');
      
      double calorias = 0.0;
      double proteinas = 0.0;
      double carbs = 0.0;
      double grasas = 0.0;
      
      if (comidasJson != null) {
        final comidas = jsonDecode(comidasJson) as List<dynamic>? ?? [];
        
        for (final comida in comidas) {
          if (comida is Map<String, dynamic>) {
            calorias += (comida['calorias'] as num?)?.toDouble() ?? 0.0;
            proteinas += (comida['proteinas'] as num?)?.toDouble() ?? 0.0;
            carbs += (comida['carbs'] as num?)?.toDouble() ?? 0.0;
            grasas += (comida['grasas'] as num?)?.toDouble() ?? 0.0;
          }
        }
      }
      
      if (mounted) {
        setState(() {
          _macrosConsumidos = {
            'calorias': calorias,
            'proteinas': proteinas,
            'carbs': carbs,
            'grasas': grasas,
          };
        });
      }
    } catch (e) {
      debugPrint("❌ Error cargando comidas: $e");
    }
  }

  Future<void> _cargarRecetasPersonalizadas() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final chatHistoryJson = prefs.getString('chat_nutricion');
      
      if (chatHistoryJson != null) {
        final chatHistory = jsonDecode(chatHistoryJson) as List<dynamic>? ?? [];
        final recetas = <Map<String, dynamic>>[];
        
        for (final mensaje in chatHistory) {
          if (mensaje is Map<String, dynamic>) {
            final contenido = mensaje['contenido'] as String? ?? '';
            if (contenido.contains('Receta:') || contenido.contains('Ingredientes:')) {
              recetas.add({
                'titulo': _extraerTitulo(contenido),
                'contenido': contenido,
                'fecha': mensaje['timestamp'] ?? DateTime.now().toIso8601String(),
              });
            }
          }
        }
        
        if (mounted) {
          setState(() => _recetasPersonalizadas = recetas.length > 10 ? recetas.sublist(0, 10) : recetas);
        }
      }
    } catch (e) {
      debugPrint("❌ Error cargando recetas: $e");
    }
  }

  Future<void> _cargarHistoricoMacros() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historicoList = <Map<String, dynamic>>[];
      
      for (int i = 0; i < 7; i++) {
        final fecha = DateTime.now().subtract(Duration(days: i));
        final fechaFormato = "${fecha.year}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}";
        final comidasJson = prefs.getString('comidas_$fechaFormato');
        
        double calorias = 0.0, proteinas = 0.0, carbs = 0.0, grasas = 0.0;
        
        if (comidasJson != null) {
          final comidas = jsonDecode(comidasJson) as List<dynamic>? ?? [];
          for (final comida in comidas) {
            if (comida is Map<String, dynamic>) {
              calorias += (comida['calorias'] as num?)?.toDouble() ?? 0.0;
              proteinas += (comida['proteinas'] as num?)?.toDouble() ?? 0.0;
              carbs += (comida['carbs'] as num?)?.toDouble() ?? 0.0;
              grasas += (comida['grasas'] as num?)?.toDouble() ?? 0.0;
            }
          }
        }
        
        final nombreDia = _obtenerNombreDia(fecha.weekday);
        historicoList.add({
          'fecha': fechaFormato,
          'dia': nombreDia,
          'calorias': calorias,
          'proteinas': proteinas,
          'carbs': carbs,
          'grasas': grasas,
        });
      }
      
      if (mounted) {
        setState(() => _historicoMacros = historicoList.reversed.toList());
      }
    } catch (e) {
      debugPrint("❌ Error cargando histórico: $e");
    }
  }

  String _extraerTitulo(String contenido) {
    final lines = contenido.split('\n');
    for (final line in lines) {
      if (line.contains('Receta:') && line.length > 10) {
        return line.replaceFirst(RegExp(r'Receta:\s*'), '').trim();
      }
    }
    return 'Receta Personalizada';
  }

  String _obtenerNombreDia(int weekday) {
    const dias = ['lun', 'mar', 'mié', 'jue', 'vie', 'sáb', 'dom'];
    return dias[weekday - 1];
  }

  Future<void> _agregarComida() async {
    if (_alimentoSeleccionado.isEmpty || _gramosController.text.isEmpty) {
      _mostrarMensaje("❌ Selecciona alimento y cantidad", Colors.red);
      return;
    }

    try {
      final gramos = double.tryParse(_gramosController.text);
      if (gramos == null || gramos <= 0) {
        _mostrarMensaje("❌ Ingresa una cantidad válida", Colors.red);
        return;
      }

      final alimento = baseAlimentos[_alimentoSeleccionado];
      if (alimento == null) {
        _mostrarMensaje("❌ Alimento no encontrado", Colors.red);
        return;
      }
      
      final factor = gramos / 100;
      final comidaNueva = {
        'nombre': alimento['nombre'] as String,
        'gramos': gramos,
        'calorias': ((alimento['calorias'] as num) * factor).toDouble(),
        'proteinas': ((alimento['proteinas'] as num) * factor).toDouble(),
        'carbs': ((alimento['carbs'] as num) * factor).toDouble(),
        'grasas': ((alimento['grasas'] as num) * factor).toDouble(),
        'fecha': DateTime.now().toIso8601String(),
      };

      final prefs = await SharedPreferences.getInstance();
      final hoy = DateTime.now();
      final hoyFormato = "${hoy.year}-${hoy.month.toString().padLeft(2, '0')}-${hoy.day.toString().padLeft(2, '0')}";
      
      List<dynamic> comidas = [];
      final comidasJson = prefs.getString('comidas_$hoyFormato');
      if (comidasJson != null) {
        comidas = jsonDecode(comidasJson) as List<dynamic>;
      }
      
      comidas.add(comidaNueva);
      await prefs.setString('comidas_$hoyFormato', jsonEncode(comidas));

      _gramosController.clear();
      setState(() => _alimentoSeleccionado = '');
      
      await _cargarComidayDelDia();
      _mostrarMensaje("✅ ${alimento['nombre']} agregado", Colors.green);
    } catch (e) {
      _mostrarMensaje("❌ Error: $e", Colors.red);
      debugPrint("Error agregando comida: $e");
    }
  }

  void _mostrarMensaje(String mensaje, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(color == Colors.green ? Icons.check_circle : Icons.error, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(mensaje)),
          ],
        ),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  double _calcularPorcentaje(double consumido, double objetivo) {
    if (objetivo == 0) return 0;
    final porcentaje = (consumido / objetivo) * 100;
    return porcentaje > 100 ? 100 : porcentaje;
  }

  Color _obtenerColorProgreso(double consumido, double objetivo) {
    if (objetivo == 0) return Colors.redAccent;
    final porcentaje = (consumido / objetivo) * 100;
    if (porcentaje < 70) return Colors.redAccent;
    if (porcentaje < 100) return Colors.amberAccent;
    return Colors.greenAccent;
  }

  @override
  Widget build(BuildContext context) {
    if (_cargandoDatos) {
      return Scaffold(
        backgroundColor: const Color(0xFF051D16),
        appBar: AppBar(
          title: const Text("📊 Seguimiento", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22)),
          backgroundColor: const Color(0xFF0F4D3C),
          elevation: 0,
        ),
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.tealAccent),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF051D16),
      appBar: AppBar(
        title: const Text("📊 Seguimiento", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22)),
        backgroundColor: const Color(0xFF0F4D3C),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: const Color(0xFF0F4D3C),
              child: Row(
                children: [
                  _construirTab(0, "📅 Hoy", Icons.today),
                  _construirTab(1, "🍽️ Recetas", Icons.restaurant),
                  _construirTab(2, "📈 Histórico", Icons.show_chart),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: _construirContenidoTab(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _construirTab(int index, String label, IconData icon) {
    final isSelected = _selectedTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTabIndex = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? Colors.tealAccent : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: isSelected ? Colors.tealAccent : Colors.white70, size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.tealAccent : Colors.white70,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _construirContenidoTab() {
    switch (_selectedTabIndex) {
      case 0:
        return _construirTabHoy();
      case 1:
        return _construirTabRecetas();
      case 2:
        return _construirTabHistorico();
      default:
        return const SizedBox();
    }
  }

  Widget _construirTabHoy() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          color: const Color(0xFF0F4D3C),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.tealAccent,
                  child: Icon(Icons.person, color: Colors.black, size: 30),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("¡Hola, $_nombreUsuario! 👋", style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      Text(
                        _obtenerFechaHoy(),
                        style: const TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),

        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1BB098), Color(0xFF16A085)],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1BB098).withOpacity(0.4),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              const Text("CALORÍAS HOY", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 1)),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text("${_macrosConsumidos['calorias'].toStringAsFixed(0)}", style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
                      const Text("Consumido", style: TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                  Container(
                    height: 60,
                    width: 2,
                    color: Colors.white30,
                  ),
                  Column(
                    children: [
                      Text("${_macrosObjetivo['calorias'].toInt()}", style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
                      const Text("Objetivo", style: TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: _calcularPorcentaje(_macrosConsumidos['calorias'], _macrosObjetivo['calorias']) / 100,
                  minHeight: 8,
                  backgroundColor: Colors.white30,
                  valueColor: AlwaysStoppedAnimation<Color>(_obtenerColorProgreso(_macrosConsumidos['calorias'], _macrosObjetivo['calorias'])),
                ),
              ),
              const SizedBox(height: 8),
              Text("${_calcularPorcentaje(_macrosConsumidos['calorias'], _macrosObjetivo['calorias']).toStringAsFixed(0)}% completado", style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
        const SizedBox(height: 24),

        const Text("MACRONUTRIENTES", style: TextStyle(color: Colors.tealAccent, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1)),
        const SizedBox(height: 16),

        _construirMacroCard("🥚 Proteínas", "${_macrosConsumidos['proteinas'].toStringAsFixed(1)}g", "${_macrosObjetivo['proteinas'].toInt()}g", Colors.blueAccent, _macrosConsumidos['proteinas'], _macrosObjetivo['proteinas']),
        const SizedBox(height: 12),

        _construirMacroCard("🍞 Carbohidratos", "${_macrosConsumidos['carbs'].toStringAsFixed(1)}g", "${_macrosObjetivo['carbs'].toInt()}g", Colors.amberAccent, _macrosConsumidos['carbs'], _macrosObjetivo['carbs']),
        const SizedBox(height: 12),

        _construirMacroCard("🥑 Grasas", "${_macrosConsumidos['grasas'].toStringAsFixed(1)}g", "${_macrosObjetivo['grasas'].toInt()}g", Colors.greenAccent, _macrosConsumidos['grasas'], _macrosObjetivo['grasas']),

        const SizedBox(height: 28),

        const Text("REGISTRAR COMIDA", style: TextStyle(color: Colors.tealAccent, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1)),
        const SizedBox(height: 16),

        Card(
          color: const Color(0xFF072119),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.tealAccent.withOpacity(0.3), width: 1.5),
                  ),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _alimentoSeleccionado.isEmpty ? null : _alimentoSeleccionado,
                    hint: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text("Selecciona alimento", style: TextStyle(color: Colors.white70)),
                    ),
                    dropdownColor: const Color(0xFF072119),
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                    icon: const Icon(Icons.arrow_drop_down, color: Colors.tealAccent),
                    underline: const SizedBox(),
                    items: baseAlimentos.entries.map((e) {
                      return DropdownMenuItem(
                        value: e.key,
                        child: Text(e.value['nombre'] as String, style: const TextStyle(color: Colors.white)),
                      );
                    }).toList(),
                    onChanged: (value) => setState(() => _alimentoSeleccionado = value ?? ''),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _gramosController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Gramos (ej: 150)",
                    hintStyle: const TextStyle(color: Colors.white54),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.06),
                    prefixIcon: const Icon(Icons.scale, color: Colors.tealAccent),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.tealAccent.withOpacity(0.3), width: 1.5),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.tealAccent.withOpacity(0.3), width: 1.5),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.tealAccent,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.add_circle_outline, size: 22),
                    label: const Text("Agregar Comida", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    onPressed: _agregarComida,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _construirTabRecetas() {
    if (_recetasPersonalizadas.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.restaurant_menu, color: Colors.tealAccent, size: 64),
            const SizedBox(height: 16),
            const Text("Sin recetas personalizadas", style: TextStyle(color: Colors.white70, fontSize: 16)),
            const SizedBox(height: 8),
            const Text("Solicita recetas en el chat para verlas aquí", style: TextStyle(color: Colors.white54, fontSize: 13)),
          ],
        ),
      );
    }

    return Column(
      children: [
        const Text("RECETAS DEL CHAT", style: TextStyle(color: Colors.tealAccent, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1)),
        const SizedBox(height: 16),
        ..._recetasPersonalizadas.map((receta) {
          return Card(
            color: const Color(0xFF0F4D3C),
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    receta['titulo'] as String,
                    style: const TextStyle(color: Colors.tealAccent, fontSize: 16, fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    (receta['contenido'] as String).length > 200
                        ? "${(receta['contenido'] as String).substring(0, 200)}..."
                        : receta['contenido'] as String,
                    style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.5),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _construirTabHistorico() {
    return Column(
      children: [
        const Text("ÚLTIMOS 7 DÍAS", style: TextStyle(color: Colors.tealAccent, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1)),
        const SizedBox(height: 16),
        ..._historicoMacros.map((dia) {
          final porcentajeCal = _calcularPorcentaje((dia['calorias'] as num).toDouble(), _macrosObjetivo['calorias'] as double);
          return Card(
            color: const Color(0xFF072119),
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${dia['dia']} - ${dia['fecha']}", style: const TextStyle(color: Colors.tealAccent, fontSize: 14, fontWeight: FontWeight.bold)),
                      Text("${porcentajeCal.toStringAsFixed(0)}%", style: TextStyle(color: _obtenerColorProgreso((dia['calorias'] as num).toDouble(), _macrosObjetivo['calorias'] as double), fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _construirMacroMini("${(dia['calorias'] as num).toInt()}cal", Colors.greenAccent),
                      _construirMacroMini("${(dia['proteinas'] as num).toStringAsFixed(0)}p", Colors.blueAccent),
                      _construirMacroMini("${(dia['carbs'] as num).toStringAsFixed(0)}c", Colors.amberAccent),
                      _construirMacroMini("${(dia['grasas'] as num).toStringAsFixed(0)}g", Colors.redAccent),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: porcentajeCal > 100 ? 1.0 : porcentajeCal / 100,
                      minHeight: 6,
                      backgroundColor: Colors.white12,
                      valueColor: AlwaysStoppedAnimation<Color>(_obtenerColorProgreso((dia['calorias'] as num).toDouble(), _macrosObjetivo['calorias'] as double)),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _construirMacroMini(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.5), width: 1),
      ),
      child: Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }

  Widget _construirMacroCard(String label, String consumido, String objetivo, Color color, double valConsumido, double valObjetivo) {
    final porcentaje = _calcularPorcentaje(valConsumido, valObjetivo);
    
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF072119),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: TextStyle(color: color, fontSize: 15, fontWeight: FontWeight.bold)),
              Text(
                "$consumido / $objetivo",
                style: TextStyle(color: Colors.white70, fontSize: 13),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: porcentaje > 100 ? 1.0 : porcentaje / 100,
              minHeight: 6,
              backgroundColor: Colors.white12,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "${porcentaje.toStringAsFixed(0)}%",
            style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  String _obtenerFechaHoy() {
    final hoy = DateTime.now();
    final dias = ['lunes', 'martes', 'miércoles', 'jueves', 'viernes', 'sábado', 'domingo'];
    final meses = ['enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio', 'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'];
    
    return "${dias[hoy.weekday - 1]}, ${hoy.day} de ${meses[hoy.month - 1]}";
  }

  @override
  void dispose() {
    _gramosController.dispose();
    super.dispose();
  }
}
