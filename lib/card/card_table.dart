import 'package:flutter/material.dart';
import 'package:proyecto_aplication/users/user/reserva_detail.dart';

class MesaCard extends StatelessWidget {
  final Map<String, dynamic> mesa;

  const MesaCard({super.key, required this.mesa});

  @override
  Widget build(BuildContext context) {
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
                    Text(mesa['title']!, style: Theme.of(context).textTheme.headlineMedium),
                    Text('🍽️ Mesa: ${mesa['nombre']}'),
                    Text('👥 Capacidad: ${mesa['capacidad']} personas'),
                    Text('📅 Fecha de Reserva: ${mesa['fechaReserva'] ?? "No especificada"}'),
                    Text('🕒 Hora de Reserva: ${mesa['horaReserva'] ?? "No especificada"}'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}