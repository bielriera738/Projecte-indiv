# 📚 CAMBIOS EN RECETAS.DART Y PERFIL.DART

## 🎯 RESUMEN GENERAL

Transformé la pantalla de Recetas de un chat simple a un sistema visual completo con:
- **ListView con tarjetas** de recetas  
- **Vista de detalle** con navegación
- **Sistema de filtros** por categoría
- **Base de datos** de 8 recetas completas

---

## 📋 RECETAS.DART - ESTRUCTURA COMPLETA

### 1️⃣ CLASE MODELO: `Receta`

```dart
class Receta {
  final String id;
  final String titulo;
  final String imagen;              // Emoji como imagen
  final int calorias;               // Calorías totales
  final int tiempoPreparacion;      // Minutos
  final String categoria;           // Desayuno, Comida, Cena
  final List<String> ingredientes;  // Lista de ingredientes
  final List<String> pasos;         // Pasos de preparación
  final int proteinas;              // Proteína en g
  final int carbohidratos;          // Carbs en g
  final int grasas;                 // Grasas en g
  final List<String> tags;          // Tags: "Definición", "Alto en proteína", etc
}
```

**¿Por qué?** Necesitamos un modelo estructurado para almacenar y manipular datos de recetas.

---

### 2️⃣ BASE DE DATOS: `recetasDatabase`

```dart
final List<Receta> recetasDatabase = [
  Receta(
    id: '1',
    titulo: 'Tortilla de Claras con Avena',
    imagen: '🥚',
    calorias: 350,
    tiempoPreparacion: 15,
    categoria: 'Desayuno',
    proteinas: 25,
    carbohidratos: 35,
    grasas: 8,
    tags: ['Definición', 'Alto en proteína'],
    ingredientes: [
      '4 claras de huevo',
      '50g de avena',
      '1 plátano',
      '10ml de aceite de oliva',
      'Sal y pimienta',
    ],
    pasos: [
      'Bate las claras de huevo con un tenedor',
      'Cocina la avena en agua 5 minutos',
      'Vierte las claras en la sartén con aceite',
      'Cuando cuaje, añade la avena cocinada',
      'Corta el plátano encima y sirve caliente',
    ],
  ),
  // ... 7 recetas más
];
```

**¿Por qué?** Un único lugar centralizado con todas las recetas. Fácil de mantener y expandir.

---

### 3️⃣ PANTALLA PRINCIPAL: `_RecetasScreenState`

#### a) **Variables de Estado**
```dart
String filtroActual = 'Todos';  // Filtro seleccionado actualmente

final List<String> categorias = [
  'Todos',
  'Desayuno',
  'Comida',
  'Cena',
  'Bajas en grasa'
];
```

#### b) **Función de Filtrado**
```dart
List<Receta> obtenerRecetasFiltradas() {
  if (filtroActual == 'Todos') {
    return recetasDatabase;  // Devuelve todas
  } else if (filtroActual == 'Bajas en grasa') {
    // Filtra por TAG
    return recetasDatabase
      .where((r) => r.tags.contains('Bajas en grasa'))
      .toList();
  } else {
    // Filtra por CATEGORÍA
    return recetasDatabase
      .where((r) => r.categoria == filtroActual)
      .toList();
  }
}
```

**¿Cómo funciona?**
- Si filtro = "Todos" → devuelve todas las recetas
- Si filtro = "Bajas en grasa" → busca en tags
- Si filtro = "Desayuno" → busca en categoría

#### c) **Build - Layout Principal**
```dart
@override
Widget build(BuildContext context) {
  final recetasFiltradas = obtenerRecetasFiltradas();
  
  return Scaffold(
    appBar: AppBar(...),
    body: Column(
      children: [
        // 1. FILTROS
        Container(...)  // Chips de filtro
        
        // 2. LISTA DE RECETAS
        Expanded(
          child: recetasFiltradas.isEmpty
            ? Center(child: "No hay recetas")
            : ListView.builder(...)
        )
      ],
    ),
  );
}
```

---

### 4️⃣ SECCIÓN DE FILTROS

```dart
Container(
  decoration: BoxDecoration(
    color: Colors.tealAccent.withOpacity(0.1),
    border: Border(bottom: BorderSide(color: Colors.tealAccent, width: 1)),
  ),
  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
  child: SingleChildScrollView(
    scrollDirection: Axis.horizontal,  // Scroll horizontal
    child: Row(
      children: categorias.map((categoria) {
        final isSelected = filtroActual == categoria;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: FilterChip(
            label: Text(
              categoria,
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.tealAccent,
                fontWeight: FontWeight.w600,
              ),
            ),
            backgroundColor: isSelected ? Colors.tealAccent : Colors.transparent,
            side: BorderSide(
              color: Colors.tealAccent,
              width: isSelected ? 0 : 1.5,
            ),
            onSelected: (selected) {
              setState(() => filtroActual = categoria);
            },
          ),
        );
      }).toList(),
    ),
  ),
)
```

**Detalles:**
- `FilterChip` es un Widget que parece un botón pequeño
- Cuando está seleccionado: fondo tealAccent + texto negro
- Cuando NO está seleccionado: transparente + texto tealAccent
- `onSelected` actualiza el filtro

---

### 5️⃣ TARJETA DE RECETA: `_tarjetaReceta()`

```dart
Widget _tarjetaReceta(BuildContext context, Receta receta) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RecetaDetailScreen(receta: receta),
        ),
      );
    },
    child: Card(
      color: const Color(0xFF051B18),
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: Colors.tealAccent, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // IMAGEN (EMOJI)
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.tealAccent.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.tealAccent, width: 1),
              ),
              child: Center(
                child: Text(receta.imagen, style: TextStyle(fontSize: 50)),
              ),
            ),
            
            // CONTENIDO
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TÍTULO
                  Text(
                    receta.titulo,
                    style: const TextStyle(
                      color: Colors.tealAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  
                  // CALORÍAS Y TIEMPO
                  Row(
                    children: [
                      Icon(Icons.local_fire_department, color: Colors.orangeAccent, size: 18),
                      Text('${receta.calorias} kcal'),
                      Icon(Icons.schedule, color: Colors.lightBlueAccent, size: 18),
                      Text('${receta.tiempoPreparacion} min'),
                    ],
                  ),
                  
                  // TAGS
                  Wrap(
                    spacing: 6,
                    children: receta.tags.take(2).map((tag) {
                      return Chip(
                        label: Text(tag, style: TextStyle(color: Colors.black)),
                        backgroundColor: Colors.tealAccent,
                        padding: EdgeInsets.zero,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            
            // FLECHA DERECHA
            const Icon(Icons.chevron_right, color: Colors.tealAccent, size: 28),
          ],
        ),
      ),
    ),
  );
}
```

**Componentes:**
- `GestureDetector` con `onTap` → navega a detalle
- `Row` con 3 partes: imagen | contenido | flecha
- Muestra solo 2 tags (`.take(2)`)
- Iconos para calorías y tiempo

---

### 6️⃣ PANTALLA DE DETALLE: `RecetaDetailScreen`

```dart
class RecetaDetailScreen extends StatelessWidget {
  final Receta receta;

  const RecetaDetailScreen({required this.receta, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(receta.titulo),
        backgroundColor: Colors.tealAccent.withOpacity(0.9),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // EMOJI GRANDE
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.tealAccent.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.tealAccent, width: 2),
              ),
              child: Center(
                child: Text(receta.imagen, style: TextStyle(fontSize: 100)),
              ),
            ),
            
            // MACROS (4 BOXES)
            Container(
              padding: const EdgeInsets.all(14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _infoBox('🔥', '${receta.calorias}', 'kcal'),
                  _infoBox('🥚', '${receta.proteinas}g', 'Proteína'),
                  _infoBox('🍞', '${receta.carbohidratos}g', 'Carbs'),
                  _infoBox('🥑', '${receta.grasas}g', 'Grasas'),
                ],
              ),
            ),
            
            // TIEMPO
            Container(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Icon(Icons.schedule, color: Colors.lightBlueAccent, size: 24),
                  Column(
                    children: [
                      Text('Tiempo de Preparación'),
                      Text('${receta.tiempoPreparacion} minutos',
                        style: TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold)
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // INGREDIENTES
            _seccion('📝 Ingredientes', receta.ingredientes),
            
            // PASOS
            _seccion('👨‍🍳 Pasos de Preparación', receta.pasos),
            
            // TAGS
            Container(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('🏷️ Tags', style: TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold)),
                  Wrap(
                    spacing: 8,
                    children: receta.tags.map((tag) {
                      return Chip(
                        label: Text(tag, style: TextStyle(color: Colors.black)),
                        backgroundColor: Colors.tealAccent,
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // HELPER: Cada macro en una caja
  Widget _infoBox(String emoji, String valor, String label) {
    return Column(
      children: [
        Text(emoji, style: TextStyle(fontSize: 28)),
        Text(valor, style: TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(color: Colors.white70, fontSize: 11)),
      ],
    );
  }

  // HELPER: Sección con lista numerada
  Widget _seccion(String titulo, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(titulo, style: TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold, fontSize: 16)),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF051B18),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.tealAccent, width: 1),
          ),
          child: Column(
            children: items.asMap().entries.map((entry) {
              final index = entry.key + 1;
              final item = entry.value;
              return Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // NÚMERO EN CÍRCULO
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.tealAccent,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Center(
                        child: Text('$index', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    SizedBox(width: 12),
                    // TEXTO
                    Expanded(
                      child: Text(item, style: TextStyle(color: Colors.white, fontSize: 14)),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
```

**Flujo:**
1. Usuario toca tarjeta → `Navigator.push()` abre `RecetaDetailScreen`
2. Detalle muestra:
   - Emoji grande (200px)
   - Macros en 4 boxes
   - Tiempo de preparación
   - Ingredientes numerados
   - Pasos numerados
   - Todos los tags

---

## 📱 PERFIL.DART - CAMBIOS PRINCIPALES

### 1️⃣ IMPORTS SIMPLIFICADOS

```dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
```

**Eliminado:** `NutritionService` (usado en chat, no en perfil)

---

### 2️⃣ VARIABLES DE ESTADO

```dart
class _MiPerfilState extends State<MiPerfil> {
  final _formKey = GlobalKey<FormState>();

  // CONTROLLERS
  late TextEditingController _nombreController;
  late TextEditingController _edadController;
  late TextEditingController _alturaController;
  late TextEditingController _pesoController;
  late TextEditingController _emailController;
  late TextEditingController _nombrePerfilController;

  // DROPDOWNS
  String _genero = '';
  String _objetivo = '';
  String _nivelActividad = '';

  // FLAGS
  bool _enviando = false;
  bool _mostrarGuardarPerfil = false;
  bool _modoEdicion = false;  // ← NUEVO: permite editar/ver

  // LISTAS DE OPCIONES
  final List<String> generos = ['Masculino', 'Femenino'];
  final List<String> objetivos = ['Definición', 'Volumen', 'Mantenimiento'];
  final List<String> nivelesActividad = ['Sedentario', 'Ligero', 'Moderado', 'Alto'];
  final List<String> alergiasDisponibles = ['Gluten', 'Lácteos', 'Mariscos', 'Ninguno'];
  final List<String> preferenciasDisponibles = ['Vegano', 'Vegetariano', 'Sin restricciones'];

  // MULTI-SELECT
  List<String> _alergiasSeleccionadas = [];
  List<String> _preferenciasSeleccionadas = [];
  List<String> _perfilesGuardados = [];
}
```

---

### 3️⃣ CÁLCULO DE MACROS

```dart
Map<String, dynamic> _calcularMacros() {
  // Validación
  if (_pesoController.text.isEmpty || _alturaController.text.isEmpty || ...) {
    return {'error': 'Por favor completa todos los campos requeridos'};
  }

  final peso = double.parse(_pesoController.text);
  final altura = double.parse(_alturaController.text);
  final edad = int.parse(_edadController.text);

  // FACTOR DE ACTIVIDAD (Harris-Benedict)
  double factorActividad = 1.375;
  if (_nivelActividad == "Sedentario") factorActividad = 1.2;
  if (_nivelActividad == "Ligero") factorActividad = 1.375;
  if (_nivelActividad == "Moderado") factorActividad = 1.55;
  if (_nivelActividad == "Alto") factorActividad = 1.725;

  // FÓRMULA MIFFLIN-ST JEOR
  double tdee;
  if (_genero == "Masculino") {
    tdee = (10 * peso + 6.25 * altura - 5 * edad + 5) * factorActividad;
  } else {
    tdee = (10 * peso + 6.25 * altura - 5 * edad - 161) * factorActividad;
  }

  // AJUSTE POR OBJETIVO
  int calorias;
  if (_objetivo == "Definición") {
    calorias = (tdee - 500).toInt();  // -500 kcal/día
  } else if (_objetivo == "Volumen") {
    calorias = (tdee + 300).toInt();  // +300 kcal/día
  } else {
    calorias = tdee.toInt();  // Mantenimiento
  }

  // MACROS AUTOMÁTICOS
  int proteinas = (peso * 2.0).toInt();  // 2g por kg
  int grasas = (calorias * 0.25 / 9).toInt();  // 25% calorías
  int carbohidratos = ((calorias - (proteinas * 4 + grasas * 9)) / 4).toInt();

  return {
    'calorias': calorias,
    'proteinas': proteinas,
    'carbohidratos': carbohidratos,
    'grasas': grasas,
  };
}
```

**Fórmula detallada:**
```
TDEE = (10×peso + 6.25×altura - 5×edad + 5) × factor_actividad
TDEE = Total Daily Energy Expenditure (gasto calórico diario)

Hombres:  +5
Mujeres:  -161

Factores de actividad:
- Sedentario (sin ejercicio):       1.2
- Ligero (1-3 días/semana):        1.375
- Moderado (3-5 días/semana):      1.55
- Alto (6-7 días/semana):          1.725

Objetivos:
- Definición: TDEE - 500 kcal
- Volumen:    TDEE + 300 kcal
- Mantenimiento: TDEE
```

---

### 4️⃣ MODO EDICIÓN

```dart
bool _modoEdicion = false;

// EN BUILD:
// Campos habilitados solo si _modoEdicion == true
TextField(
  enabled: _modoEdicion,  // ← CLAVE
  controller: _nombreController,
  // ...
)

// BOTÓN PARA CAMBIAR MODO
ElevatedButton(
  onPressed: () {
    setState(() => _modoEdicion = !_modoEdicion);
  },
  child: Text(_modoEdicion ? 'Cancelar' : 'Editar'),
)
```

**Comportamiento:**
- Por defecto: campos deshabilitados (solo lectura)
- Click en "Editar": `_modoEdicion = true`, campos se activan
- Click en "Cancelar": `_modoEdicion = false`, se descartan cambios

---

### 5️⃣ PERSISTENCIA

```dart
// GUARDAR
Future<void> _guardarCambios() async {
  final prefs = await SharedPreferences.getInstance();
  
  final perfil = {
    'nombre': _nombreController.text,
    'edad': _edadController.text,
    'altura': _alturaController.text,
    'peso': _pesoController.text,
    'email': _emailController.text,
    'genero': _genero,
    'objetivo': _objetivo,
    'nivelActividad': _nivelActividad,
    'alergias': _alergiasSeleccionadas,
    'preferencias': _preferenciasSeleccionadas,
    'macros': _calcularMacros(),
  };
  
  await prefs.setString('perfil_completo', jsonEncode(perfil));
}

// CARGAR
Future<void> _cargarPerfil() async {
  final prefs = await SharedPreferences.getInstance();
  final perfilJson = prefs.getString('perfil_completo');
  
  if (perfilJson != null) {
    final perfil = jsonDecode(perfilJson);
    setState(() {
      _nombreController.text = perfil['nombre']?.toString() ?? '';
      _genero = perfil['genero']?.toString() ?? '';
      // ... más campos
    });
  }
}
```

---

### 6️⃣ LOGOUT (CERRAR SESIÓN)

```dart
Future<void> _cerrarSesion() async {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Cerrar sesión'),
      content: Text('¿Seguro que deseas cerrar sesión?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancelar'),
        ),
        TextButton(
          onPressed: () async {
            final prefs = await SharedPreferences.getInstance();
            await prefs.clear();  // ← Elimina TODO
            
            Navigator.pop(context);
            Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
          },
          child: Text('Cerrar sesión', style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );
}
```

**¿Qué hace?**
1. Muestra diálogo de confirmación
2. Si confirma: `prefs.clear()` borra todo
3. Navega a la pantalla raíz
4. Usa `RemoveUntil` para evitar back

---

## 🔄 FLUJO COMPLETO

### RECETAS:
```
Usuario abre app
    ↓
Pantalla RecetasScreen
    ├─ Muestra filtros (Todos, Desayuno, etc)
    └─ Muestra ListView con tarjetas
    
Usuario toca un filtro
    ↓
setState() actualiza filtroActual
    ↓
obtenerRecetasFiltradas() filtra la lista
    ↓
ListView.builder se reconstruye
    
Usuario toca una tarjeta
    ↓
Navigator.push → RecetaDetailScreen
    ↓
Pantalla muestra detalle completo
    (imagen, macros, ingredientes, pasos, tags)
    
Usuario toca atrás
    ↓
Navigator.pop → vuelve a RecetasScreen
```

### PERFIL:
```
Usuario abre app
    ↓
Pantalla MiPerfil carga datos (initState)
    ├─ _cargarPerfil() desde SharedPreferences
    └─ Muestra campos deshabilitados

Usuario toca "Editar"
    ↓
setState() → _modoEdicion = true
    ↓
Campos se habilitan

Usuario modifica datos y toca "Guardar"
    ↓
_guardarCambios() → guardado en SharedPreferences
    ↓
_calcularMacros() genera nuevos macros automáticamente
    ↓
Muestra toast de confirmación

Usuario toca "Cerrar sesión"
    ↓
Diálogo de confirmación
    ↓
prefs.clear() borra todo
    ↓
Navega a pantalla inicial
```

---

## 💡 CONCEPTOS CLAVE

### 1. NAVEGACIÓN
```dart
// PUSH (ir a nueva pantalla)
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => NuevaPantalla()),
);

// POP (volver atrás)
Navigator.pop(context);

// NAMED ROUTE (ir a pantalla inicial)
Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
```

### 2. ESTADO (setState)
```dart
// Cambiar estado y reconstruir widget
setState(() {
  _modoEdicion = !_modoEdicion;
  filtroActual = 'Desayuno';
});
```

### 3. WIDGETS CLAVE

| Widget | Uso |
|--------|-----|
| `ListView.builder` | Lista dinámica de items |
| `FilterChip` | Botones de filtro |
| `GestureDetector` | Detectar taps/clics |
| `Card` | Tarjeta con elevación |
| `TextField` | Campo de entrada de texto |
| `Chip` | Etiqueta pequeña |
| `Container` | Caja con decoración |
| `Column / Row` | Layouts vertical/horizontal |
| `Wrap` | Items que saltan a siguiente línea |
| `Expanded` | Toma espacio disponible |
| `SingleChildScrollView` | Scroll horizontal/vertical |

### 4. SHARED PREFERENCES
```dart
// GUARDAR
final prefs = await SharedPreferences.getInstance();
await prefs.setString('key', 'valor');
await prefs.setInt('key', 123);
await prefs.setList('key', ['item1', 'item2']);

// CARGAR
final valor = prefs.getString('key');
final numero = prefs.getInt('key');
final lista = prefs.getStringList('key');

// ELIMINAR
await prefs.remove('key');
await prefs.clear();
```

### 5. FORMULARIOS CON VALIDACIÓN
```dart
final _formKey = GlobalKey<FormState>();

Form(
  key: _formKey,
  child: Column(
    children: [
      TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Campo requerido';
          }
          return null;
        },
      ),
      ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            // Formulario válido
          }
        },
        child: Text('Enviar'),
      ),
    ],
  ),
)
```

---

## 🎨 PALETA DE COLORES USADA

```dart
const Color fondo = Color(0xFF051D16);      // Verde oscuro
const Color fondoClaro = Color(0xFF051B18);  // Verde más claro
const Color primario = Colors.tealAccent;    // Teal brillante
const Color texto = Colors.white;            // Blanco
const Color textoSecundario = Colors.white70; // Blanco 70%
const Color acento = Colors.orangeAccent;    // Naranja
const Color acento2 = Colors.lightBlueAccent;// Azul claro
```

---

## 📐 PATRONES Y BUENAS PRÁCTICAS

### ✅ HACER:
```dart
// ✅ Separar lógica de UI
List<Receta> obtenerRecetasFiltradas() { ... }

// ✅ Usar constantes
const Duration duration = Duration(seconds: 2);

// ✅ Helpers para widgets repetidos
Widget _infoBox(String emoji, String valor, String label) { ... }

// ✅ Mapear listas en UI
categorias.map((cat) => FilterChip(...)).toList()
```

### ❌ NO HACER:
```dart
// ❌ Lógica de negocio en build()
build() {
  final filtradas = db.filter(...);  // ← Malo
}

// ❌ Hardcoding valores
Text('Mi valor'),  // ← Usa variables

// ❌ Widgets anidados sin separación
Container(
  child: Column(
    children: [
      Container(...)
      Container(...)
    ]
  )
)  // ← Mejor usar helpers
```

---

## 🚀 PRÓXIMOS PASOS

1. **Añadir más recetas** → Agregar items a `recetasDatabase`
2. **Buscar recetas** → TextField arriba con `where()`
3. **Guardar favoritos** → SharedPreferences + ❤️ icon
4. **Backend real** → Llamadas HTTP a servidor
5. **Imágenes reales** → NetworkImage en lugar de emojis
6. **Carrito** → Agregar recetas a lista de compra

---

## 📚 REFERENCIAS ÚTILES

- [Flutter Docs - Navigation](https://flutter.dev/docs/development/ui/navigation)
- [Flutter Docs - Shared Preferences](https://pub.dev/packages/shared_preferences)
- [Dart - List Methods](https://dart.dev/guides/libraries/library-tour#list)
- [Material Design Widgets](https://material.io/components/)
