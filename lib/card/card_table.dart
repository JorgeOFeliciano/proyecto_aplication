import 'package:flutter/material.dart';
import 'package:proyecto_aplication/users/user/reserva_detail.dart';
import 'package:proyecto_aplication/data/maps.dart'; // ✅ Asegura que tienes acceso a la lista `restaurants`

class MesaCard extends StatelessWidget {
  final Map<String, dynamic> mesa;

  const MesaCard({super.key, required this.mesa});

  @override
  Widget build(BuildContext context) {
    // ✅ Obtén el título del restaurante usando su restaurantId
    final String restaurantTitle = restaurants.firstWhere(
      (r) => r['id'] == mesa['restaurantId'], // ✅ Busca el restaurante por ID
      orElse: () => {'title': 'Restaurante desconocido'}, // ✅ Maneja errores si el restaurante no existe
    )['title'];

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReservaDetalleScreen(mesaInfo: mesa),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 6,
        shadowColor: Colors.brown.shade200,
        margin: const EdgeInsets.only(bottom: 12, top: 12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: mesa['imagen'] != null && mesa['imagen'].isNotEmpty
                    ? Image.asset(
                        mesa['imagen'],
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.chair, size: 100, color: Colors.grey),
                      )
                    : const Icon(Icons.chair, size: 100, color: Colors.grey),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      restaurantTitle, // ✅ Ahora muestra el título del restaurante en lugar de restaurantId
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    _buildInfoRow(Icons.chair, 'Mesa: ${mesa['nombre']}', Colors.blueGrey),
                    _buildInfoRow(Icons.people, 'Capacidad: ${mesa['capacidad']} personas', Colors.green),
                    _buildInfoRow(Icons.calendar_today, 'Fecha de Reserva: ${mesa['fechaReserva'] ?? "No especificada"}', Colors.teal),
                    _buildInfoRow(Icons.access_time, 'Hora de Reserva: ${mesa['horaReserva'] ?? "No especificada"}', Colors.orange),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, Color iconColor) {
    return Row(
      children: [
        Icon(icon, color: iconColor),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: TextStyle(color: Colors.grey.shade500))),
      ],
    );
  }
}