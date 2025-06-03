import 'package:flutter/material.dart';
import 'package:proyecto_aplication/data/maps.dart';
import 'package:proyecto_aplication/home/auth_service.dart';
import 'package:proyecto_aplication/users/user/contact.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
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


  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: currentUserData == null
          ? const Center(child: CircularProgressIndicator()) // ✅ Indicador de carga mientras se obtiene el usuario
          : ListView(
              padding: EdgeInsets.zero,
              children: [
                // ✅ Encabezado del Drawer con la información del usuario activo
                UserAccountsDrawerHeader(
                  accountName: Text(currentUserData?['nombre'] ?? 'Usuario'),
                  accountEmail: Text(currentUserData?['correo'] ?? 'No disponible'),
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: currentUserData?['imagenPerfil'] != null &&
                            currentUserData?['imagenPerfil']!.isNotEmpty
                        ? AssetImage(currentUserData!['imagenPerfil']!)
                        : null,
                    backgroundColor: Colors.transparent,
                    child: currentUserData?['imagenPerfil'] == null ||
                            currentUserData?['imagenPerfil']!.isEmpty
                        ? const Icon(Icons.person, size: 50, color: Colors.white)
                        : null,
                  ),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: const AssetImage('assets/coffe_bg.jpg'),
                      fit: BoxFit.cover,
                      colorFilter:
                          ColorFilter.mode(Colors.black.withAlpha(153), BlendMode.darken),
                    ),
                  ),
                ),

                // ✅ Opciones del menú con datos personales y configuración
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Datos personales'),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/personal_data',
                      arguments: Map<String, String>.from(currentUserData?.map(
                        (key, value) => MapEntry(key, value.toString()),
                      ) ?? {}),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Configuración'),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/settings',
                      arguments: Map<String, String>.from(currentUserData?.map(
                        (key, value) => MapEntry(key, value.toString()),
                      ) ?? {}),
                    );
                  },
                ),

                // ✅ Sección de ayuda
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        '¿Cómo podemos ayudarte?',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Si tienes problemas con tu orden o necesitas aclarar o solicitar más información sobre tu compra, no dudes en contactarnos.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ContactScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Contáctanos'),
                      ),
                    ],
                  ),
                ),

                // ✅ Cerrar sesión
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Cerrar sesión'),
                  onTap: () {
                    AuthService.logoutUser();
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/',
                      (Route<dynamic> route) => false,
                    );
                  },
                ),
              ],
            ),
    );
  }
}