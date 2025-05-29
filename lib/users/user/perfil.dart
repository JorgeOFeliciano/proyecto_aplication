import 'dart:ui'; // Necesario para el efecto de desenfoque
import 'package:flutter/material.dart';
import 'package:proyecto_aplication/data/maps.dart';

class Perfil extends StatelessWidget {
  const Perfil({super.key});

  @override
  Widget build(BuildContext context) {
    final usuario = usuarios[0]; // Puedes cambiar el índice o pasarlo dinámicamente

    return Scaffold(
      body: Stack(
        children: [
          // 🌆 Imagen de fondo con difuminado
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/fondo_perfil.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), // ✅ Difuminado suave
            child: Container(color: Colors.black.withAlpha(127)) // 0.5 * 255 ≈ 127,
          ),

          Column(
            children: [
              // 🔙 Barra de navegación
            

              const SizedBox(height: 50),

              // 🦸 Avatar con animación Hero
              Hero(
                tag: 'avatar_usuario',
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 60, color: Colors.blueGrey),
                ),
              ),
              const SizedBox(height: 10),
              
              Text(
                usuario['nombre'],
                style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                '${usuario['username']} · Se unió en ${usuario['fechaRegistro']}',
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
              Text(
                usuario['correo'],
                style: const TextStyle(color: Colors.white54, fontSize: 12),
              ),

              const SizedBox(height: 20),

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
                        _ProfileStat(title: 'Favoritos', value: usuario['favoritos'], icon: Icons.favorite, color: Colors.red),
                        _ProfileStat(title: 'Reseñas', value: usuario['reseñas'], icon: Icons.list_alt, color: Colors.grey),
                        _ProfileStat(title: 'Seguidores', value: usuario['seguidores'], icon: Icons.people, color: Colors.blue),
                      ],
                    ),
                    const SizedBox(height: 10),
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: Icon(
                        Icons.person_add,
                        color: Colors.blue, // ✅ Cambia el color aquí
                        size: 24, // Opcional: Ajusta el tamaño del icono
                      ),
                      label: Text(
                        'Agregar Amigos',
                        style: TextStyle(color: Colors.blue.shade700), // ✅ Color del texto igual al borde
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.blue.shade700), // ✅ Borde azul
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text('Resumen', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 20,
                        runSpacing: 20,
                        children: [
                          _SummaryCard(icon: Icons.redeem, title: usuario['puntos'], subtitle: 'Puntos', color: Colors.green),
                          _SummaryCard(icon: Icons.table_bar, title: usuario['visitas'], subtitle: 'Visitas', color: Colors.brown),
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
        SizedBox( // ✅ Fijamos el tamaño del icono
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

// 📦 Widget de resumen con mejor diseño y alineación
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