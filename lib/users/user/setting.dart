import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  final Map<String, String> usuario;

  const SettingsScreen({super.key, required this.usuario});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late String imagenPerfil;
  String rolSeleccionado = 'Cliente'; // Rol por defecto
  bool mostrarFormulario = false; // Controla si se muestra el formulario

  final TextEditingController nombreRestauranteController = TextEditingController();
  final TextEditingController direccionController = TextEditingController();
  final TextEditingController contactoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    imagenPerfil = widget.usuario['imagenPerfil'] ?? '';
  }

  void cambiarRol(String nuevoRol) {
    setState(() {
      rolSeleccionado = nuevoRol;
      mostrarFormulario = nuevoRol == 'Dueño de Restaurante';
    });
  }

  void enviarSolicitud() {
    // Aquí puedes agregar lógica para enviar la solicitud a la base de datos
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Solicitud enviada para revisión')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configuración')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Imagen de perfil
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: imagenPerfil.isNotEmpty ? AssetImage(imagenPerfil) : null,
                backgroundColor: Colors.grey[300],
                child: imagenPerfil.isEmpty ? const Icon(Icons.person, size: 50, color: Colors.white) : null,
              ),
            ),
            const SizedBox(height: 20),
            // Dropdown para cambiar de rol
            const Text(
              'Selecciona tu rol:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            DropdownButton<String>(
              value: rolSeleccionado,
              items: const [
                DropdownMenuItem(value: 'Cliente', child: Text('Cliente')),
                DropdownMenuItem(value: 'Dueño de Restaurante', child: Text('Dueño de Restaurante')),
              ],
              onChanged: (value) => cambiarRol(value!),
            ),
            const SizedBox(height: 20),
            // Mostrar formulario si el usuario es dueño de restaurante
            if (mostrarFormulario) ...[
              const Text('Solicitar creación de restaurante', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              _buildTextField('Nombre del Restaurante', nombreRestauranteController),
              _buildTextField('Dirección', direccionController),
              _buildTextField('Contacto', contactoController),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: enviarSolicitud,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
                child: const Text('Enviar Solicitud'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}