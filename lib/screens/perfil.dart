import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Para manejar la fecha

class MiPerfil extends StatefulWidget {
  const MiPerfil({super.key});

  @override
  State<MiPerfil> createState() => _MiPerfilState();
}

class _MiPerfilState extends State<MiPerfil> {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController apellidoController = TextEditingController();
  final TextEditingController correoController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();
  final TextEditingController pesoController = TextEditingController();
  final TextEditingController alturaController = TextEditingController();
  final TextEditingController edadController = TextEditingController();

  String? generoSeleccionado;
  DateTime? fechaNacimiento;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B2E26),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Mi Perfil",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0B3D2E),
              Color(0xFF124F3B),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
          child: Column(
            children: [
              // 📸 Foto de perfil
              Center(
                child: Stack(
                  children: [
                    const CircleAvatar(
                      radius: 60,
                      backgroundImage: AssetImage('assets/images/imagen.jpg'),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 4,
                      child: GestureDetector(
                        onTap: () {
                          // Aquí podrías usar image_picker para cambiar la foto
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.greenAccent[700],
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(6),
                          child: const Icon(Icons.camera_alt,
                              color: Colors.white, size: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // 🧍 Datos personales
              _buildTextField("Nombre", nombreController, TextInputType.text),
              const SizedBox(height: 16),
              _buildTextField("Apellido", apellidoController, TextInputType.text),
              const SizedBox(height: 16),

              // 📅 Fecha de nacimiento
              GestureDetector(
                onTap: _seleccionarFechaNacimiento,
                child: AbsorbPointer(
                  child: TextField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white70,
                      labelText: 'Fecha de nacimiento',
                      hintText: fechaNacimiento == null
                          ? 'Selecciona tu fecha'
                          : DateFormat('dd/MM/yyyy').format(fechaNacimiento!),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              _buildTextField("Edad", edadController, TextInputType.number),
              const SizedBox(height: 16),

              // ⚧️ Género
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonFormField<String>(
                  initialValue: generoSeleccionado,
                  decoration: const InputDecoration(
                    labelText: 'Género',
                    border: InputBorder.none,
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Masculino', child: Text('Masculino')),
                    DropdownMenuItem(value: 'Femenino', child: Text('Femenino')),
                    DropdownMenuItem(value: 'Otro', child: Text('Otro')),
                  ],
                  onChanged: (valor) => setState(() => generoSeleccionado = valor),
                ),
              ),
              const SizedBox(height: 16),

              // ⚖️ Datos físicos
              _buildTextField("Peso (kg)", pesoController, TextInputType.number),
              const SizedBox(height: 16),
              _buildTextField("Altura (cm)", alturaController, TextInputType.number),
              const SizedBox(height: 16),

              // 📊 IMC (opcional)
              if (pesoController.text.isNotEmpty &&
                  alturaController.text.isNotEmpty)
                _buildIMC(),

              // 💾 Botón guardar
              ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Perfil guardado correctamente"),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                icon: const Icon(Icons.save),
                label: const Text("Guardar perfil"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent[700],
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 📅 Selector de fecha
  Future<void> _seleccionarFechaNacimiento() async {
    final DateTime? seleccion = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: const Locale('es', 'ES'),
    );
    if (seleccion != null) {
      setState(() {
        fechaNacimiento = seleccion;
        edadController.text =
            (DateTime.now().year - seleccion.year).toString(); // Calcula edad automática
      });
    }
  }

  // 🧱 Widget reutilizable para campos
  Widget _buildTextField(String label, TextEditingController controller, TextInputType type) {
    return TextField(
      controller: controller,
      keyboardType: type,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white70,
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  // 📊 Calcular IMC
  Widget _buildIMC() {
    double peso = double.tryParse(pesoController.text) ?? 0;
    double altura = (double.tryParse(alturaController.text) ?? 0) / 100;
    if (peso <= 0 || altura <= 0) return const SizedBox.shrink();
    double imc = peso / (altura * altura);
    String estado = '';
    if (imc < 18.5) {
      estado = 'Bajo peso';
    } else if (imc < 25) estado = 'Normal';
    else if (imc < 30) estado = 'Sobrepeso';
    else estado = 'Obesidad';

    return Column(
      children: [
        const SizedBox(height: 10),
        Text(
          "Tu IMC: ${imc.toStringAsFixed(1)} ($estado)",
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
