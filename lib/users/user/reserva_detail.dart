import 'package:flutter/material.dart';

class ReservaDetalleScreen extends StatelessWidget {
  final Map<String, dynamic> mesaInfo;

  const ReservaDetalleScreen({Key? key, required this.mesaInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ✅ Manejo seguro de horarios
    final horarioInicio = mesaInfo['horariosDisponibles']?['inicio']?.hour ?? 0;
    final horarioFin = mesaInfo['horariosDisponibles']?['fin']?.hour ?? 23;

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
                        'assets/${mesaInfo['imagen']}',
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
                mesaInfo['title'],
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),

            // 🍽️ Detalles de la mesa
            Row(
              children: [
                const Icon(Icons.table_bar, size: 20, color: Colors.grey),
                const SizedBox(width: 8),
                Expanded(child: const Text("Mesa:", style: TextStyle(fontSize: 16))),
                Text(mesaInfo['nombre'], style: const TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.people, size: 20, color: Colors.grey),
                const SizedBox(width: 8),
                Expanded(child: const Text("Capacidad:", style: TextStyle(fontSize: 16))),
                Text("${mesaInfo['capacidad']} personas", style: const TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 20, color: Colors.grey),
                const SizedBox(width: 8),
                Expanded(child: const Text("Fecha de Reserva:", style: TextStyle(fontSize: 16))),
                Text(mesaInfo['fechaReserva'] ?? "No especificada", style: const TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.watch_later, size: 20, color: Colors.grey),
                const SizedBox(width: 8),
                Expanded(child: const Text("Hora de Reserva:", style: TextStyle(fontSize: 16))),
                Text(mesaInfo['horaReserva'] ?? "No especificada", style: const TextStyle(fontSize: 16)),
              ],
            ),

            const SizedBox(height: 24),
            const Divider(thickness: 1, color: Colors.grey),

            // 🛑 Estado de la mesa con alineación
            const Text("Estado de la Mesa", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            

            const SizedBox(height: 24),
            const Divider(thickness: 1, color: Colors.grey),

            // 🏷️ Información adicional
            const Text("Características", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(mesaInfo['mensaje'], style: const TextStyle(fontSize: 16)),

            const SizedBox(height: 24),
            const Divider(thickness: 1, color: Colors.grey),

            // 🕒 Horario de Reservaciones
            const Text("Horario de Reservaciones", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.access_time, size: 20, color: Colors.grey),
                const SizedBox(width: 8),
                Expanded(child: const Text("Horario:", style: TextStyle(fontSize: 16))),
                Text("De $horarioInicio:00 a $horarioFin:00",
                    style: const TextStyle(fontSize: 16)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}