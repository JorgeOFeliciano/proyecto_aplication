import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:proyecto_aplication/data/maps.dart';
import 'package:proyecto_aplication/items/items.dart';

void actualizarEstadoMesa(
  String mesaNombre,
  DateTime fecha,
  String hora,
  String restauranteId, // ✅ Cambio para usar ID en lugar de title
  BuildContext context,
) {
  final int index = tables.indexWhere(
    (mesa) => mesa['nombre'] == mesaNombre && mesa['restaurantId'] == restauranteId, // ✅ Ahora usa restaurantId
  );
  if (index != -1) {
    tables[index]['status'] = "No Disponible";
    tables[index]['reservada'] = true;
    tables[index]['fechaReserva'] = DateFormat('dd/MM/yyyy').format(fecha);
    tables[index]['horaReserva'] = hora;
    tables[index]['restaurantId'] = restauranteId; // ✅ Actualiza el ID correctamente
  }
}

class DetalleReservaPage extends StatefulWidget {
  final Map<String, dynamic> mesaInfo;

  const DetalleReservaPage({super.key, required this.mesaInfo});

  @override
  State<DetalleReservaPage> createState() => _DetalleReservaPageState();
}

class _DetalleReservaPageState extends State<DetalleReservaPage> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = const TimeOfDay(hour: 20, minute: 0);

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  TimeOfDay parseTimeOfDay(String timeStr) {
    final parts = timeStr.split(":");
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (picked != null) {
      final Map<String, dynamic> restaurante = restaurants.firstWhere(
        (r) => r['id'] == widget.mesaInfo['restaurantId'], // ✅ Ahora usa restaurantId
        orElse: () => <String, dynamic>{},
      );

      if (restaurante.isNotEmpty) {
        final String inicio = restaurante['horariosDisponibles']['inicio'] ?? "00:00";
        final String fin = restaurante['horariosDisponibles']['fin'] ?? "23:59";

        final String selectedTimeStr =
            "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";

        final bool isWithinSchedule =
            selectedTimeStr.compareTo(inicio) >= 0 && selectedTimeStr.compareTo(fin) <= 0;

        if (!isWithinSchedule) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Este horario no está disponible para ${widget.mesaInfo['restaurantId']}.\n"
                "Elige entre $inicio y $fin",
              ),
            ),
          );
        } else {
          setState(() {
            selectedTime = picked;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final restaurante = restaurants.firstWhere(
      (r) => r['id'] == widget.mesaInfo['restaurantId'], // ✅ Ahora usa restaurantId
      orElse: () => {},
    );

    final String inicio = restaurante.isNotEmpty ? restaurante['horariosDisponibles']['inicio'] : "00:00";
    final String fin = restaurante.isNotEmpty ? restaurante['horariosDisponibles']['fin'] : "23:59";
    final String selectedTimeStr =
        "${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}";

    bool isWithinSchedule = selectedTimeStr.compareTo(inicio) >= 0 && selectedTimeStr.compareTo(fin) <= 0;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.mesaInfo['nombre']),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: widget.mesaInfo['imagen'] != null && widget.mesaInfo['imagen'].isNotEmpty
                    ? Image.asset(
                        widget.mesaInfo['imagen'],
                        height: 120,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.chair, size: 120, color: Colors.grey),
                      )
                    : const Icon(Icons.chair, size: 120, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(
                widget.mesaInfo['restaurantId'], // ✅ Muestra ID en lugar de título
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text("Fecha"),
              trailing: Text(DateFormat('dd/MM/yyyy').format(selectedDate)),
              onTap: () => _selectDate(context),
            ),
            ListTile(
              leading: const Icon(Icons.access_time),
              title: const Text("Hora"),
              trailing: Text(selectedTimeStr),
              onTap: () => _selectTime(context),
            ),
            const Divider(height: 32),
            const Text("Horario de Reservaciones", style: TextStyle(fontWeight: FontWeight.bold)),
            Text("De $inicio a $fin"),
            const SizedBox(height: 30),
            CustomButton(
              label: "Confirmar Reservación",
              onPressed: isWithinSchedule
                  ? () {
                      setState(() {
                        actualizarEstadoMesa(
                          widget.mesaInfo['nombre'],
                          selectedDate,
                          selectedTimeStr,
                          widget.mesaInfo['restaurantId'], // ✅ Usa el ID
                          context,
                        );
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Reservación confirmada."),
                        ),
                      );

                      Future.delayed(const Duration(milliseconds: 500), () {
                        if (!mounted) return;
                        Navigator.pop(context);
                      });
                    }
                  : null,
              isActive: isWithinSchedule,
            ),
          ],
        ),
      ),
    );
  }
}