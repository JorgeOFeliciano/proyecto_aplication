import 'package:flutter/material.dart';
import 'package:proyecto_aplication/card/card_table.dart';
import 'package:proyecto_aplication/data/maps.dart';
import 'package:proyecto_aplication/items/drawer.dart';
import 'package:proyecto_aplication/items/top_bar.dart';

class Reserva extends StatefulWidget {
  const Reserva({Key? key}) : super(key: key);

  @override
  State<Reserva> createState() => _ReservaState();
}

class _ReservaState extends State<Reserva> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final String selectedFilter = 'Reservadas'; // 🔹 Solo mostrar reservadas

  @override
  Widget build(BuildContext context) {
    final filteredMesas = tables.where((mesa) => mesa['reservada'] == true).toList();

    return Scaffold(
      key: _scaffoldKey,
      drawer: const CustomDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            CustomTopSearchBar(
              onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
              onLocationTap: () {},
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
                      itemCount: filteredMesas.length,
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
