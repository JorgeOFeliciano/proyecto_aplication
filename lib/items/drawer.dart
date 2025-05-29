import 'package:flutter/material.dart';
import 'package:proyecto_aplication/data/maps.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // ✅ Encabezado del Drawer con imagen de fondo oscurecida
          UserAccountsDrawerHeader(
            accountName: const Text('Jorge Osvaldo'),
            accountEmail: const Text(''), 
            currentAccountPicture: CircleAvatar(
              backgroundImage: usuarios[0]['imagenPerfil'] != null && usuarios[0]['imagenPerfil']!.isNotEmpty
                  ? AssetImage(usuarios[0]['imagenPerfil']!)
                  : null,
              backgroundColor: Colors.transparent, // ✅ Fondo transparente
              child: usuarios[0]['imagenPerfil'] == null || usuarios[0]['imagenPerfil']!.isEmpty
                  ? const Icon(Icons.person, size: 50, color: Colors.white)
                  : null,
            ),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('coffe_bg.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.6), BlendMode.darken), // ✅ Oscurece la imagen
              ),
            ),
          ),

          // ✅ Opciones del menú
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Datos personales'),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/personal_data',
                arguments: Map<String, String>.from(usuarios[0]),
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
                arguments: Map<String, String>.from(usuarios[0]),
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
                    Navigator.pushNamed(context, '/contact');
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