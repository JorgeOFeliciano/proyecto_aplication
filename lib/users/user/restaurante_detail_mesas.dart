import 'package:flutter/material.dart';
import 'package:proyecto_aplication/data/maps.dart';
import 'package:proyecto_aplication/items/items.dart';
import 'package:proyecto_aplication/users/user/restaurante_detail_mesas_detail.dart';

class TableReservationScreen extends StatefulWidget {
  const TableReservationScreen({super.key});

  @override
  State<TableReservationScreen> createState() => _TableReservationScreenState();
}

class _TableReservationScreenState extends State<TableReservationScreen> {
  String selectedTab = 'Disponibles';
  List<Map<String, dynamic>> _tables = [];
  String selectedRestaurantId = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (selectedRestaurantId.isEmpty) {
      final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      selectedRestaurantId = args['id'] ?? '';

      _tables = tables
          .where((m) => m['restaurantId'] == selectedRestaurantId)
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentList = selectedTab == 'Disponibles'
        ? _tables.where((m) => m['status'] == 'Disponible').toList()
        : _tables.where((m) => m['status'] != 'Disponible').toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Información de Mesas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTabSelector(),
            const SizedBox(height: 20),
            currentList.isEmpty
                ? const Expanded(
                    child: Center(
                      child: Text('No hay mesas disponibles.'),
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: currentList.length,
                      itemBuilder: (context, index) {
                        final mesa = currentList[index];
                        return GestureDetector(
                          onTap: () {
                            if (selectedTab == 'Disponibles') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      DetalleReservaPage(mesaInfo: mesa),
                                ),
                              );
                            }
                          },
                          child: _buildTableCard(mesa),
                        );
                      },
                    ),
                  ),
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
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.chair, size: 90, color: Colors.grey),
                  )
                : const Icon(Icons.chair, size: 90, color: Colors.grey),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(mesa['nombre'],
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 6),
                Text('Capacidad: ${mesa['capacidad']} personas'),
                const SizedBox(height: 4),
                _buildStatusIcon(),
                const SizedBox(height: 6),
                Text(mesa['mensaje'],
                    style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIcon() {
    final isAvailable = selectedTab == 'Disponibles';
    return Row(
      children: [
        Icon(
          isAvailable ? Icons.check_circle : Icons.cancel,
          color: isAvailable ? Colors.green : Colors.red,
          size: 18,
        ),
        const SizedBox(width: 6),
        Text(
          isAvailable ? 'Disponible' : 'No disponible',
          style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isAvailable ? Colors.green : Colors.red),
        ),
      ],
    );
  }
}
