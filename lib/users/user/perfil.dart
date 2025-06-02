import 'dart:ui'; // Necesario para el efecto de desenfoque
import 'package:flutter/material.dart';
import 'package:proyecto_aplication/data/maps.dart';
import 'package:proyecto_aplication/home/auth_service.dart';

class Perfil extends StatefulWidget {
  const Perfil({super.key});

  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
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
    return Scaffold(
      body: Stack(
        children: [
          // ✅ Fondo con desenfoque
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/fondo_perfil.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(color: Colors.black.withAlpha(127)),
          ),

          Column(
            children: [
              const SizedBox(height: 50),
              Hero(
                tag: 'avatar_usuario',
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  backgroundImage: currentUserData?['imagenPerfil'] != null &&
                          currentUserData?['imagenPerfil']!.isNotEmpty
                      ? AssetImage(currentUserData!['imagenPerfil']!)
                      : null,
                  child: currentUserData?['imagenPerfil'] == null ||
                          currentUserData?['imagenPerfil']!.isEmpty
                      ? const Icon(Icons.person, size: 60, color: Colors.blueGrey)
                      : null,
                ),
              ),
              const SizedBox(height: 10),

              // ✅ Información del usuario activo
              Text(
                currentUserData?['nombre'] ?? 'Usuario desconocido',
                style: const TextStyle(
                    color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                '${currentUserData?['username'] ?? ''} · Se unió en ${currentUserData?['fechaRegistro'] ?? 'Fecha desconocida'}',
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
              Text(
                currentUserData?['correo'] ?? 'Correo no disponible',
                style: const TextStyle(color: Colors.white54, fontSize: 12),
              ),

              const SizedBox(height: 20),

              // ✅ Contenedor de estadísticas
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _ProfileStat(
                            title: 'Favoritos',
                            value: currentUserData?['favoritos'] ?? '0',
                            icon: Icons.favorite,
                            color: Colors.red),
                        _ProfileStat(
                            title: 'Reseñas',
                            value: currentUserData?['reseñas'] ?? '0',
                            icon: Icons.list_alt,
                            color: Colors.grey),
                        _ProfileStat(
                            title: 'Seguidores',
                            value: currentUserData?['seguidores'] ?? '0',
                            icon: Icons.people,
                            color: Colors.blue),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // ✅ Botón para agregar amigos
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: Icon(
                        Icons.person_add,
                        color: Colors.blue,
                        size: 24,
                      ),
                      label: Text(
                        'Agregar Amigos',
                        style: TextStyle(color: Colors.blue.shade700),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.blue.shade700),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),
                    ),
                    const SizedBox(height: 20),

                    const Text('Resumen',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 20,
                        runSpacing: 20,
                        children: [
                          _SummaryCard(
                              icon: Icons.redeem,
                              title: currentUserData?['puntos'] ?? '0',
                              subtitle: 'Puntos',
                              color: Colors.green),
                          _SummaryCard(
                              icon: Icons.table_bar,
                              title: currentUserData?['visitas'] ?? '0',
                              subtitle: 'Visitas',
                              color: Colors.brown),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _ProfileStat({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 40,
          height: 40,
          child: Icon(icon, size: 30, color: color),
        ),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Text(title, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const _SummaryCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 150,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(subtitle, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}