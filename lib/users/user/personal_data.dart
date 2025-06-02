import 'package:flutter/material.dart';
import 'package:proyecto_aplication/data/maps.dart';
import 'package:proyecto_aplication/home/auth_service.dart';
import 'package:proyecto_aplication/users/user/personal_data_edit.dart';
import 'package:proyecto_aplication/users/user/personal_data_pass.dart';

class PersonalDataScreen extends StatefulWidget {
  final Map<String, String> usuario;

  const PersonalDataScreen({super.key, required this.usuario});

  @override
  State<PersonalDataScreen> createState() => _PersonalDataScreenState();
}

class _PersonalDataScreenState extends State<PersonalDataScreen> {
  Map<String, dynamic>? currentUserData;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Cargar información del usuario que inició sesión usando el ID
  void _loadUserData() async {
    String? userId = await AuthService.getCurrentUserId();
    if (userId != null) {
      setState(() {
        currentUserData = usuarios.firstWhere(
          (user) => user['id'] == userId,
          orElse: () => {},
        );
      });
    }
  }


  Widget infoField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1F2937))),
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
      body: currentUserData == null
          ? const Center(child: CircularProgressIndicator()) // ✅ Muestra un loader si los datos aún no están cargados
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  const Text('Información de Cuenta', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),

                  ListTile(title: Text(currentUserData?['correo'] ?? 'No disponible'), subtitle: const Text('Correo electrónico')),

                  ListTile(
                    title: const Text('********'),
                    subtitle: const Text('Contraseña'),
                    trailing: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CambiarContrasenaScreen(
                              usuario: Map<String, String>.from(currentUserData ?? {}),
                            ),
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
                              builder: (context) => EditarDatosScreen(
                                usuario: Map<String, String>.from(currentUserData ?? {}),
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.edit, size: 18),
                        label: const Text('Editar'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  infoField('Nombre(s)', currentUserData?['nombre'] ?? 'No disponible'),
                  infoField('Apellido(s)', currentUserData?['apellido'] ?? 'No disponible'),
                  infoField('Teléfono', currentUserData?['telefono'] ?? 'No disponible'),
                  infoField('Fecha de nacimiento', currentUserData?['fechaNacimiento'] ?? 'No disponible'),
                  infoField('Código Postal', currentUserData?['codigoPostal'] ?? 'No disponible'),
                  infoField('Ciudad', currentUserData?['ciudad'] ?? 'No disponible'),
                  infoField('País', currentUserData?['pais'] ?? 'No disponible'),
                ],
              ),
            ),
    );
  }
}