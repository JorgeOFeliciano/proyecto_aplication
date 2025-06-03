import 'package:flutter/material.dart';
import 'package:proyecto_aplication/data/maps.dart';
import 'package:proyecto_aplication/items/items.dart';
import 'package:proyecto_aplication/users/restaurante/restaurante_gesture_tables_edit.dart';

class EditTablesScreen extends StatefulWidget {
  final Map<String, dynamic> restaurant;

  const EditTablesScreen({Key? key, required this.restaurant}) : super(key: key);

  @override
  State<EditTablesScreen> createState() => _EditTablesScreenState();
}

class _EditTablesScreenState extends State<EditTablesScreen> {
  List<Map<String, dynamic>> _tables = [];
  String selectedTab = 'Disponibles';

  @override
  void initState() {
    super.initState();
    _tables = tables.where((m) => m['restaurantId'] == widget.restaurant['id']).toList();
  }

  void _addTable() {
    setState(() {
      int newIndex = _tables.length + 1;
      _tables.add({
        'id': '${widget.restaurant['id']}_M$newIndex',
        'restaurantId': widget.restaurant['id'],
        'nombre': 'Mesa $newIndex',
        'capacidad': 4,
        'imagen': 'assets/table_default.png',
        'mensaje': 'Nueva mesa añadida',
        'status': 'Disponible', // ✅ Ahora es un string
        'reservada': false,
        'fechaReserva': null,
        'horaReserva': null,
      });
    });
  }

  void _deleteTable(String tableId) {
    setState(() {
      _tables.removeWhere((mesa) => mesa['id'] == tableId);
    });
  }

  void _saveChanges() {
    tables.removeWhere((m) => m['restaurantId'] == widget.restaurant['id']);
    tables.addAll(_tables);

    widget.restaurant['tables'] = _tables;
    Navigator.pop(context, widget.restaurant);
  }

  @override
  Widget build(BuildContext context) {
    final currentList = selectedTab == 'Disponibles'
        ? _tables.where((m) => m['status'] == 'Disponible').toList()
        : _tables.where((m) => m['status'] != 'Disponible').toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Editar Mesas")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTabSelector(),
            const SizedBox(height: 10),
            Expanded(
              child: currentList.isEmpty
                  ? const Center(child: Text('No hay mesas en esta categoría.'))
                  : ListView.builder(
                      itemCount: currentList.length,
                      itemBuilder: (context, index) {
                        final mesa = currentList[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditTableDetailScreen(tableData: mesa),
                              ),
                            ).then((updatedTable) {
                              if (updatedTable != null) {
                                setState(() {
                                  _tables[index] = updatedTable;
                                });
                              }
                            });
                          },
                          child: _buildTableCard(mesa),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 20),
            CustomButton(label: "Agregar Mesa", isActive: true, onPressed: _addTable),
            const SizedBox(height: 10),
            CustomButton(label: "Guardar Cambios", isActive: true, onPressed: _saveChanges),
          ],
        ),
      ),
    );
  }

  Widget _buildTabSelector() {
    return Row(
      children: ['Disponibles', 'No disponibles'].map((tab) {
        final isSelected = selectedTab == tab;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: SimpleButton(
              label: tab,
              onPressed: () {
                setState(() {
                  selectedTab = tab;
                });
              },
              backgroundColor: isSelected ? Colors.brown[100]! : Colors.white,
              textColor: Colors.black87,
            ),
          ),
        );
      }).toList(),
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
          BoxShadow(color: Colors.grey.shade500.withAlpha(38), blurRadius: 6, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: mesa['imagen'] != null && mesa['imagen'].isNotEmpty
                ? Image.asset(mesa['imagen'], width: 90, height: 90, fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(Icons.chair, size: 90, color: Colors.grey))
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
                const SizedBox(height: 4),
                _buildStatusIcon(mesa['status']),
                const SizedBox(height: 6),
                Text(mesa['mensaje'], style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => _deleteTable(mesa['id']),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIcon(String status) {
    final isAvailable = status == 'Disponible';
    return Row(
      children: [
        Icon(isAvailable ? Icons.check_circle : Icons.cancel, color: isAvailable ? Colors.green : Colors.red, size: 18),
        const SizedBox(width: 6),
        Text(isAvailable ? 'Disponible' : 'No disponible',
            style: TextStyle(fontWeight: FontWeight.w600, color: isAvailable ? Colors.green : Colors.red)),
      ],
    );
  }
}