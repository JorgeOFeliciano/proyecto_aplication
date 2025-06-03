import 'package:flutter/material.dart';
import 'package:proyecto_aplication/data/maps.dart';
import 'package:proyecto_aplication/home/auth_service.dart';
import 'package:proyecto_aplication/items/items.dart';
import 'package:proyecto_aplication/users/restaurante/restaurante_crear.dart';
import 'package:proyecto_aplication/users/restaurante/restaurante_gesture.dart';
import 'package:proyecto_aplication/users/user/help.dart';
import 'package:proyecto_aplication/users/user/seggestion.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Map<String, dynamic>? currentUserData;
  bool isDarkMode = false;
  String? userId;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    userId = await AuthService.getCurrentUserId(); // ✅ Guarda el ID en la variable global
    if (userId != null) {
      setState(() {
        currentUserData = usuarios.firstWhere(
          (user) => user['id'] == userId,
          orElse: () => {},
        );
      });
    }
  }

  void _confirmarEliminarCuenta() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar cuenta'),
        content: const Text('¿Estás seguro de que quieres eliminar tu cuenta? Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          IconButtonCustom(
            label: "Eliminar Cuenta",
            onPressed: () {
              Navigator.pop(context);
              _eliminarCuenta();
            },
            backgroundColor: Colors.red,
            textColor: Colors.white,
            icon: Icons.delete,
          ),
        ],
      ),
    );
  }

  void _eliminarCuenta() {
    if (userId != null) {
      setState(() {
        usuarios.removeWhere((user) => user['id'] == userId);
        restaurants.removeWhere((rest) => rest['ownerId'] == userId);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cuenta eliminada correctamente')),
      );

      Navigator.pushReplacementNamed(context, '/login');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al eliminar la cuenta')),
      );
    }
  }

  void _irAyuda() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HelpScreen()),
    );
  }

  void _irACrearRestaurante() async {
    final bool? creado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateRestaurantScreen(),
      ),
    );

    if (creado == true) {
      setState(() {
        currentUserData?['tieneRestaurante'] = true;
      });
    }
  }

  void _irAGestionRestaurante() async {
    final userId = currentUserData?['id'];
    final userRestaurant = restaurants.firstWhere(
      (resto) => resto['ownerId'] == userId,
      orElse: () => {},
    );

    if (userRestaurant.isNotEmpty) {
      final bool? eliminado = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RestaurantManageScreen(restaurant: userRestaurant),
        ),
      );

      if (eliminado == true) {
        setState(() {
          currentUserData?['tieneRestaurante'] = false;
        });
      }
    }
  }

  void _toggleDarkMode(bool value) {
    setState(() {
      isDarkMode = value;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Modo ${isDarkMode ? 'oscuro' : 'claro'} activado')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: currentUserData == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(child: _buildProfileSection()),
                _buildButtonsSection(),
              ],
            ),
    );
  }

  Widget _buildProfileSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: currentUserData?['imagenPerfil'] != null && currentUserData?['imagenPerfil']!.isNotEmpty
                ? AssetImage(currentUserData!['imagenPerfil']!)
                : null,
            backgroundColor: Colors.grey[300],
            child: currentUserData?['imagenPerfil'] == null || currentUserData?['imagenPerfil']!.isEmpty
                ? const Icon(Icons.person, size: 50, color: Colors.white)
                : null,
          ),
          const SizedBox(height: 10),
          Text(
            currentUserData?['nombre'] ?? "Usuario",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          _buildModeToggle(),
        ],
      ),
    );
  }

  Widget _buildModeToggle() {
    return SwitchListTile(
      title: const Text('Modo oscuro'),
      value: isDarkMode,
      onChanged: _toggleDarkMode,
    );
  }

  Widget _buildButtonsSection() {
    final tieneRestaurante = currentUserData?['tieneRestaurante'] ?? false;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (!tieneRestaurante)
            IconButtonCustom(
              label: "Crear Restaurante",
              onPressed: _irACrearRestaurante,
              backgroundColor: Colors.white,
              textColor: Colors.black,
              icon: Icons.storefront,
            ),
          if (tieneRestaurante)
            IconButtonCustom(
              label: "Gestionar Restaurante",
              onPressed: _irAGestionRestaurante,
              backgroundColor: Colors.white,
              textColor: Colors.black,
              icon: Icons.edit,
            ),
          const SizedBox(height: 10),
          IconButtonCustom(
            label: "Eliminar Cuenta",
            onPressed: _confirmarEliminarCuenta,
            backgroundColor: Colors.white,
            textColor: Colors.black,
            icon: Icons.delete,
          ),
          const SizedBox(height: 10),
          IconButtonCustom(
            label: "Centro de Ayuda",
            onPressed: _irAyuda,
            backgroundColor: Colors.white,
            textColor: Colors.black,
            icon: Icons.help,
          ),
          const SizedBox(height: 10),
          IconButtonCustom(
            label: "Sugerencias y Comentarios",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SuggestionsScreen()),
              );
            },
            backgroundColor: Colors.white,
            textColor: Colors.black,
            icon: Icons.feedback,
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}