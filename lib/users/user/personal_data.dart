import 'package:flutter/material.dart';
import 'package:proyecto_aplication/users/user/personal_data_edit.dart';
import 'package:proyecto_aplication/users/user/personal_data_pass.dart';

class PersonalDataScreen extends StatefulWidget {
  final Map<String, String> usuario;

  const PersonalDataScreen({super.key, required this.usuario});

  @override
  State<PersonalDataScreen> createState() => _PersonalDataScreenState();
}

class _PersonalDataScreenState extends State<PersonalDataScreen> {
  late String nombre;
  late String apellido;
  late String correo;
  late String telefono;
  late String fechaNacimiento;
  late String codigoPostal;
  late String ciudad;
  late String pais;
  late String password;

  @override
  void initState() {
    super.initState();
    final usuario = widget.usuario;
    nombre = usuario['nombre']!;
    apellido = usuario['apellido']!;
    correo = usuario['correo']!;
    telefono = usuario['telefono']!;
    fechaNacimiento = usuario['fechaNacimiento']!;
    codigoPostal = usuario['codigoPostal']!;
    ciudad = usuario['ciudad']!;
    pais = usuario['pais']!;
    password = usuario['password']!;
  }

  Widget infoField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1F2937)),
          ),
          const SizedBox(height: 8),
          const Divider(color: Color(0xFFD1D5DB), thickness: 1, height: 1),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Datos Personales')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text('Información de Cuenta', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            ListTile(title: Text(correo), subtitle: const Text('Correo electrónico')),

            ListTile(
              title: const Text('********'),
              subtitle: const Text('Contraseña'),
              trailing: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CambiarContrasenaScreen(usuario: Map<String, String>.from(widget.usuario)),
                    ),
                  );
                },
                child: const Text('Cambiar'),
              ),
            ),

            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Datos Personales', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditarDatosScreen(usuario: widget.usuario),
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit, size: 18),
                  label: const Text('Editar'),
                ),
              ],
            ),

            const SizedBox(height: 10),

            infoField('Nombre(s)', nombre),
            infoField('Apellido(s)', apellido),
            infoField('Teléfono', telefono),
            infoField('Fecha de nacimiento', fechaNacimiento),
            infoField('Código Postal', codigoPostal),
            infoField('Ciudad', ciudad),
            infoField('País', pais),
          ],
        ),
      ),
    );
  }
}