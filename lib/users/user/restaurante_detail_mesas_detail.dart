import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:proyecto_aplication/data/maps.dart';
import 'package:proyecto_aplication/items/items.dart';

void actualizarEstadoMesa(String mesaNombre, DateTime fecha, TimeOfDay hora, String restaurante, BuildContext context) {
  final int index = tables.indexWhere((mesa) => mesa['nombre'] == mesaNombre && mesa['title'] == restaurante);
  if (index != -1) {
    tables[index]['status'] = "No Disponible";
    tables[index]['reservada'] = true;
    tables[index]['fechaReserva'] = DateFormat('dd/MM/yyyy').format(fecha);
    tables[index]['horaReserva'] = MaterialLocalizations.of(context).formatTimeOfDay(hora);
    tables[index]['title'] = restaurante; // ✅ Guarda el restaurante correcto
  }
}
class DetalleReservaPage extends StatefulWidget {
  final Map<String, dynamic> mesaInfo;

  const DetalleReservaPage({Key? key, required this.mesaInfo}) : super(key: key);

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

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (picked != null) {
      final restaurante = restaurants.firstWhere(
        (r) => r['title'] == widget.mesaInfo['title'],
        orElse: () => {},
      );

      if (restaurante.isNotEmpty) {
        final TimeOfDay inicio = restaurante['horariosDisponibles']['inicio'];
        final TimeOfDay fin = restaurante['horariosDisponibles']['fin'];

        if (picked.hour < inicio.hour || picked.hour > fin.hour) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Este horario no está disponible para ${widget.mesaInfo['title']}.\n"
                "Elige entre ${inicio.hour}:00 y ${fin.hour}:00",
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
      (r) => r['title'] == widget.mesaInfo['title'],
      orElse: () => {},
    );
    final TimeOfDay inicio = restaurante.isNotEmpty ? restaurante['horariosDisponibles']['inicio'] : const TimeOfDay(hour: 0, minute: 0);
    final TimeOfDay fin = restaurante.isNotEmpty ? restaurante['horariosDisponibles']['fin'] : const TimeOfDay(hour: 23, minute: 59);

    bool isWithinSchedule = selectedTime.hour >= inicio.hour && selectedTime.hour <= fin.hour;

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
                child: Image.asset(widget.mesaInfo['imagen'], height: 120),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(
                widget.mesaInfo['title'],
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
              trailing: Text(selectedTime.format(context)),
              onTap: () => _selectTime(context),
            ),

            ListTile(
              leading: const Icon(Icons.event_seat),
              title: const Text("Mesa"),
              subtitle: Text(widget.mesaInfo['nombre']),
            ),
            const Divider(height: 32),

            const Text("Capacidad de Mesa", style: TextStyle(fontWeight: FontWeight.bold)),
            Text("${widget.mesaInfo['capacidad']} personas"),

            const Divider(height: 32),
            const Text("Estado de Mesa", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(widget.mesaInfo['status'], style: TextStyle(color: widget.mesaInfo['status'] == 'Disponible' ? Colors.green : Colors.red)),

            const Divider(height: 32),
            const Text("Características de la Mesa", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(widget.mesaInfo['mensaje']),

            const Divider(height: 32),
            const Text("Horario de Reservaciones", style: TextStyle(fontWeight: FontWeight.bold)),
            Text("De ${inicio.hour}:00 a ${fin.hour}:00"),

            const SizedBox(height: 30),

            CustomButton(
              label: "Confirmar Reservación",
              onPressed: isWithinSchedule
                  ? () {
                      setState(() {
                        actualizarEstadoMesa(widget.mesaInfo['nombre'], selectedDate, selectedTime, widget.mesaInfo['title'],context);
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Reservación confirmada. Estado de la mesa actualizado y fecha/hora guardadas.")),
                      );

                      Future.delayed(const Duration(milliseconds: 500), () {
                        Navigator.pop(context); // 🔹 Cierra la pantalla después de la confirmación
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