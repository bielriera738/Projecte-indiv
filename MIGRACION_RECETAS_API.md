# Cambios en Recetas - Migración a API

## Resumen de Cambios

Se ha eliminado completamente la lista hardcodeada de 17 recetas y se ha implementado un sistema de carga desde API REST.

### Archivos Modificados

#### 1. `lib/screens/recetas.dart`
- ✅ Eliminadas todas las 17 recetas hardcodeadas
- ✅ Agregado método `fromJson()` a la clase `Receta` para deserializar datos de la API
- ✅ Implementado `FutureBuilder` para cargar datos de forma asincrónica
- ✅ Estados de carga: loading, error, y datos vacíos
- ✅ Extracción dinámicas de categorías desde las recetas cargadas
- ✅ Manejo de errores con botón de reintento

#### 2. `lib/services/recetasservice.dart` (NUEVO)
Archivo de servicio centralizado para todas las llamadas a la API:
- `cargarRecetas()` - Carga todas las recetas
- `cargarRecetaPorId(String id)` - Carga una receta específica
- `obtenerCategorias(List<Receta> recetas)` - Extrae categorías únicas

### Configuración de la API

**URL Base**: `http://127.0.0.1:8000/api/v1`

**Endpoints**:
- `GET /recetas` - Obtiene todas las recetas
- `GET /recetas/{id}` - Obtiene una receta específica

**Estructura de datos esperada**:
```json
{
  "id": "1",
  "titulo": "Tortilla de Claras con Avena",
  "imagen": "🥚",
  "calorias": 350,
  "tiempoPreparacion": 15,
  "categoria": "Desayuno",
  "proteinas": 25,
  "carbohidratos": 35,
  "grasas": 8,
  "tags": ["Definición", "Alto en proteína"],
  "ingredientes": [
    "4 claras de huevo",
    "50g de avena",
    "1 plátano",
    "10ml de aceite de oliva",
    "Sal y pimienta"
  ],
  "pasos": [
    "Bate las claras de huevo con un tenedor",
    "Cocina la avena en agua 5 minutos",
    "Vierte las claras en la sartén con aceite",
    "Cuando cuaje, añade la avena cocinada",
    "Corta el plátano encima y sirve caliente"
  ]
}
```

### Características Implementadas

1. **Carga Asincrónica**: Los datos se cargan desde la API sin bloquear la interfaz
2. **Estados de Carga**: Muestra indicador de progreso, errores y mensajes vacíos
3. **Manejo de Errores**: Incluye timeout (10 segundos) y opción de reintento
4. **Categorías Dinámicas**: Las categorías se extraen automáticamente de los datos
5. **Filtrado**: Sigue funcionando igual, filtrando por categoría o tags
6. **Respuesta Flexible**: Maneja tanto listas directas como objetos con propiedad "data"

### Dependencias Requeridas

El proyecto ya tiene `http: ^1.2.2` en `pubspec.yaml`, así que no se necesita agregar nada.

### Notas Importantes

- La app intenta conectar a `http://127.0.0.1:8000` (localhost)
- Si usas Android emulator, reemplaza `127.0.0.1` con `10.0.2.2`
- El timeout está configurado en 10 segundos
- Los valores numéricos pueden ser String o int en la respuesta API, el código maneja ambos

