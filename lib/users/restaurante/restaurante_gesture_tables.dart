import 'package:flutter/material.dart';
import 'package:proyecto_aplication/data/maps.dart';
import 'package:proyecto_aplication/items/items.dart'; // Tus botones personalizados

class EditTablesScreen extends StatefulWidget {
  final Map<String, dynamic> restaurant;

  const EditTablesScreen({Key? key, required this.restaurant}) : super(key: key);

  @override
  State<EditTablesScreen> createState() => _EditTablesScreenState();
}

class _EditTablesScreenState extends State<EditTablesScreen> {
  final List<Map<String, dynamic>> _tables = [];

  @override
  void initState() {
    super.initState();
    // Cargar todas las mesas del restaurante **sin filtrar por estado**
    _tables.addAll(tables.where((m) => m['title'] == widget.restaurant['title']).toList());
  }

  void _addTable() {
    setState(() {
      int newIndex = _tables.length + 1;
      _tables.add({
        'nombre': 'Mesa $newIndex',
        'capacidad': 4, // Capacidad por defecto
        'imagen': 'assets/table_default.png', // Imagen por defecto
        'mensaje': 'Nueva mesa añadida',
      });
    });
  }

  void _saveChanges() {
    widget.restaurant['tables'] = _tables;
    Navigator.pop(context, widget.restaurant);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar Mesas"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Lista de mesas (sin filtrar por estado)
            Expanded(
              child: ListView.builder(
                itemCount: _tables.length,
                itemBuilder: (context, index) {
                  final mesa = _tables[index];
                  return _buildTableCard(mesa);
                },
              ),
            ),
            const SizedBox(height: 20),
            CustomButton(
              label: "Agregar Mesa",
              isActive: true,
              onPressed: _addTable,
            ),
            const SizedBox(height: 10),
            CustomButton(
              label: "Guardar Cambios",
              isActive: true,
              onPressed: _saveChanges,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableCard(Map<String, dynamic> mesa) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade500.withAlpha(38),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: mesa['imagen'] != null && mesa['imagen'].isNotEmpty
                ? Image.asset(
                    mesa['imagen'], 
                    width: 90, 
                    height: 90, 
                    fit: BoxFit.cover, 
                    errorBuilder: (_, __, ___) => const Icon(Icons.chair, size: 90, color: Colors.grey),
                  )
                : const Icon(Icons.chair, size: 90, color: Colors.grey),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(mesa['nombre'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 6),
                Text('Capacidad: ${mesa['capacidad']} personas'),
                const SizedBox(height: 6),
                Text(mesa['mensaje'], style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}