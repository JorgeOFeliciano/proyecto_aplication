import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditarDatosScreen extends StatefulWidget {
  final Map<String, String> usuario; // ✅ Recibe la información del usuario

  const EditarDatosScreen({super.key, required this.usuario});

  @override
  State<EditarDatosScreen> createState() => _EditarDatosScreenState();
}

class _EditarDatosScreenState extends State<EditarDatosScreen> {
  late String nombre;
  late String apellido;
  late String correo;
  late String telefono;
  late String fechaNacimiento;
  late String codigoPostal;
  late String ciudad;
  late String pais;
  late String imagenPerfil;
  bool cambiosRealizados = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _cargarDatosUsuario();
  }

  // ✅ Cargar la información del usuario recibido como parámetro
  void _cargarDatosUsuario() {
    final usuario = widget.usuario;
    nombre = usuario['nombre'] ?? '';
    apellido = usuario['apellido'] ?? '';
    correo = usuario['correo'] ?? '';
    telefono = usuario['telefono'] ?? '';
    fechaNacimiento = usuario['fechaNacimiento'] ?? '';
    codigoPostal = usuario['codigoPostal'] ?? '';
    ciudad = usuario['ciudad'] ?? '';
    pais = usuario['pais'] ?? '';
    imagenPerfil = usuario['imagenPerfil'] ?? '';
  }

  void detectarCambios() {
    setState(() {
      cambiosRealizados = true;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime initialDate = fechaNacimiento.isNotEmpty 
        ? DateFormat('dd/MM/yyyy').parse(fechaNacimiento) 
        : DateTime.now(); // ✅ Usa la fecha almacenada o la fecha actual

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate, // ✅ Usa la fecha que está guardada
      firstDate: DateTime(1900), // ✅ Permite seleccionar desde el año 1900
      lastDate: DateTime.now(), // ✅ Bloquea fechas futuras
    );

    if (picked != null) {
      setState(() {
        fechaNacimiento = DateFormat('dd/MM/yyyy').format(picked);
        detectarCambios();
      });
    }
  }

  void _guardarCambios() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Información actualizada')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Datos Personales'),
        backgroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 20),
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: imagenPerfil.isNotEmpty ? AssetImage(imagenPerfil) : null,
                      child: imagenPerfil.isEmpty ? const Icon(Icons.person, size: 50, color: Colors.blueGrey) : null,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      nombre,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField('Nombre(s)', nombre, (value) { nombre = value; detectarCambios(); }),
              _buildTextField('Apellido(s)', apellido, (value) { apellido = value; detectarCambios(); }),
              _buildTextField('Correo electrónico', correo, (value) { correo = value; detectarCambios(); }, keyboardType: TextInputType.emailAddress),
              _buildTextField('Teléfono', telefono, (value) { telefono = value; detectarCambios(); }, keyboardType: TextInputType.phone),

              _buildTextField(
                'Fecha de nacimiento', 
                fechaNacimiento, 
                (value) => fechaNacimiento = value, 
                keyboardType: TextInputType.none, // ✅ Evita que aparezca el teclado
                onTap: () => _selectDate(context), // ✅ Abre el selector de fecha al tocar el campo
              ),
              _buildTextField('Código Postal', codigoPostal, (value) { codigoPostal = value; detectarCambios(); }),
              _buildTextField('Ciudad', ciudad, (value) { ciudad = value; detectarCambios(); }),
              _buildTextField('País', pais, (value) { pais = value; detectarCambios(); }),

              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: cambiosRealizados ? Colors.brown : Colors.grey,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                ),
                onPressed: cambiosRealizados ? _guardarCambios : null,
                child: const Text('Guardar cambios'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancelar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String value, Function(String) onChanged, 
    {TextInputType keyboardType = TextInputType.text, VoidCallback? onTap}) { // ✅ Agrega `onTap`
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector( // ✅ Agrega un detector de gestos para manejar `onTap`
        onTap: onTap, // ✅ Activa el selector de fecha cuando el usuario toca el campo
        child: AbsorbPointer( // ✅ Evita que el teclado se abra
          child: TextFormField(
            initialValue: value,
            onChanged: onChanged,
            keyboardType: keyboardType,
            style: const TextStyle(fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              labelText: label.toUpperCase(),
              labelStyle: const TextStyle(fontWeight: FontWeight.bold),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color.fromARGB(255, 200, 200, 200), width: 2),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Este campo es obligatorio';
              }
              return null;
            },
          ),
        ),
      ),
    );
  }
}