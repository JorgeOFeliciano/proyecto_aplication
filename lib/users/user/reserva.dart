import 'package:flutter/material.dart';
import 'package:proyecto_aplication/card/card_table.dart';
import 'package:proyecto_aplication/data/maps.dart';
import 'package:proyecto_aplication/items/drawer.dart';
import 'package:proyecto_aplication/items/top_bar.dart';
import 'package:proyecto_aplication/users/user/shop_lista.dart';

class Reserva extends StatefulWidget {
  const Reserva({super.key});

  @override
  State<Reserva> createState() => _ReservaState();
}

class _ReservaState extends State<Reserva> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Map<String, dynamic>> filteredMesas = []; // ✅ Lista filtrada inicial

  @override
  void initState() {
    super.initState();
    _initializeReservas(); // ✅ Inicializa la lista de reservas filtradas
  }

  void _initializeReservas() {
    setState(() {
      filteredMesas = tables.where((mesa) => mesa['reservada'] == true).toList();
    });
  }

  // ✅ Función para filtrar reservas según el nombre del restaurante
  void _filterReservas(String query) {
    setState(() {
      filteredMesas = tables.where((mesa) {
        return mesa['reservada'] == true &&
            mesa['title'].toLowerCase().contains(query.toLowerCase()); // ✅ Filtra por restaurante
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const CustomDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            Builder(
              builder: (context) {
                return CustomTopSearchBar(
                  onMenuTap: () => Scaffold.of(context).openDrawer(),
                  onBack: () => Navigator.pop(context),
                  onCartTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ListShops()),
                    );
                  },
                  onSearchChanged: _filterReservas, // ✅ Filtra por restaurante
                );
              },
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Text(
                "Mis Reservas",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: filteredMesas.isEmpty
                  ? const Center(
                      child: Text(
                        "No tienes reservas activas.",
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      itemCount: filteredMesas.length, // ✅ Usar la lista filtrada
                      itemBuilder: (context, index) {
                        return MesaCard(mesa: filteredMesas[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}