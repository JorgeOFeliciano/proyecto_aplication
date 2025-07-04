import 'package:flutter/material.dart';
import 'package:proyecto_aplication/data/maps.dart'; // ✅ Asegura acceso a la lista `restaurants`

class ReservaDetalleScreen extends StatelessWidget {
  final Map<String, dynamic> mesaInfo;

  const ReservaDetalleScreen({super.key, required this.mesaInfo});

  @override
  Widget build(BuildContext context) {
    // ✅ Obtén el título del restaurante usando `restaurantId`
    final String restaurantTitle = restaurants.firstWhere(
      (r) => r['id'] == mesaInfo['restaurantId'], // ✅ Busca por ID en la lista de restaurantes
      orElse: () => {'title': 'Restaurante desconocido'}, // ✅ Evita errores si el restaurante no existe
    )['title'];

    // Manejo seguro de horarios
    final horarioInicio = mesaInfo['horariosDisponibles']?['inicio'] ?? "00:00";
    final horarioFin = mesaInfo['horariosDisponibles']?['fin'] ?? "23:59";

    return Scaffold(
      appBar: AppBar(title: const Text("Detalle de Mesa")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 📸 Imagen de la mesa con control de errores
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: mesaInfo['imagen'] != null && mesaInfo['imagen'].isNotEmpty
                    ? Image.asset(
                        '${mesaInfo['imagen']}',
                        width: 280,
                        height: 180,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        width: 280,
                        height: 180,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                      ),
              ),
            ),
            const SizedBox(height: 24),

            // 🌟 Nombre del restaurante
            Center(
              child: Text(
                restaurantTitle, // ✅ Muestra el título del restaurante en lugar de restaurantId
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),

            _buildDetailRow(Icons.table_bar, "Mesa", mesaInfo['nombre']),
            _buildDetailRow(Icons.people, "Capacidad", "${mesaInfo['capacidad']} personas"),
            _buildDetailRow(Icons.calendar_today, "Fecha de Reserva", mesaInfo['fechaReserva'] ?? "No especificada"),
            _buildDetailRow(Icons.watch_later, "Hora de Reserva", mesaInfo['horaReserva'] ?? "No especificada"),

            const SizedBox(height: 24),
            const Divider(thickness: 1, color: Colors.grey),

            const Text("Estado de la Mesa", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            const Divider(thickness: 1, color: Colors.grey),

            const Text("Características", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(mesaInfo['mensaje'], style: const TextStyle(fontSize: 16)),

            const SizedBox(height: 24),
            const Divider(thickness: 1, color: Colors.grey),

            const Text("Horario de Reservaciones", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildDetailRow(Icons.access_time, "Horario", "De $horarioInicio a $horarioFin"),
          ],
        ),
      ),
    );
  }

  /// Método auxiliar para construir filas de información con íconos
  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey),
        const SizedBox(width: 8),
        Expanded(child: Text(label, style: const TextStyle(fontSize: 16))),
        Text(value, style: const TextStyle(fontSize: 16)),
      ],
    );
  }
}